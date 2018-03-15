//
//  ZGMD5.m
//  ZGDataSafety
//
//  Created by 彰雪林 on 2018/3/15.
//  Copyright © 2018年 彰雪林. All rights reserved.
//

#import "ZGMD5.h"

@implementation ZGMD5
#define CC_MD5_DIGEST_LENGTH 16

+ (NSString*)getmd5WithString:(NSString *)string {
    const char *original_str = [string UTF8String];
    // 使用字符串数组去存取加密后相关的内容(MD5 16进制,32位)
    // CC_MD5_DIGEST_LENGTH 表示长度 CC_MD5_DIGEST_LENGTH = 16
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    // 进行MD5加密
    // 参数1:需要加密的内容
    // 参数2:要加密的data的一个长度
    // 参数3:存储加密结果的数组(MD5)
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

//pragma mark - HMACMD5加密方法
+ (NSString *)hmacMD5StringWithKey:(NSString *)key string:(NSString *)string {
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [strM appendFormat:@"%02x", buffer[i]];
    }
    return strM;
}

+ (NSString *)getMD5WithData:(NSData *)data {
    const char *original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    //也可以定义一个字节数组来接收计算得到的MD5值
    //    Byte byte[16];
    //    CC_MD5(original_str, strlen(original_str), byte);
    //    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    //    for(int  i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
    //        [outPutStr appendFormat:@"%02x",byte[i]];
    //    }
    //    [temp release];
    
    return [outPutStr lowercaseString];
}

+ (NSMutableString *)dataMD5:(NSData *)data {
     CC_MD5_CTX md5;
     CC_MD5_Init(&md5);
     CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
     unsigned char result[CC_MD5_DIGEST_LENGTH];
     CC_MD5_Final(result, &md5);
     NSMutableString *mutableString = [NSMutableString string];
     for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
         [mutableString appendFormat:@"%02x", result[i]];
     }
     return mutableString;
 }

+ (NSString *)getFileMD5WithPath:(NSString*)path {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData) {
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

@end
