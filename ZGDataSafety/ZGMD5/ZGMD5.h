//
//  ZGMD5.h
//  ZGDataSafety
//
//  Created by 彰雪林 on 2018/3/15.
//  Copyright © 2018年 彰雪林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface ZGMD5 : NSObject

//计算NSData的MD5值
+(NSString*)getMD5WithData:(NSData*)data;
+ (NSString *)hmacMD5StringWithKey:(NSString *)key string:(NSString *)string;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
