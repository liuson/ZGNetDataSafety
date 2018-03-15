//
//  ViewController.m
//  ZGDataSafety
//
//  Created by 彰雪林 on 2018/3/13.
//  Copyright © 2018年 彰雪林. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ZGMD5.h"
#import "ZGDes.h"
#import "ZGRSA.h"
#import "ZGKeychainItemWrapper.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //MD5---------------------------------------------------------------------
    //string
    [self testMD5String];
    //data
    [self testMD5Data];
    //add saft
    [self testAddSaftMD5String];
    //hmac
    [self testHmacMD5String];
   
    //DES---------------------------------------------------------------------
    [self testDES];
    
    //RSA---------------------------------------------------------------------
    [self testRSA];
    
    //Keychain----------------------------------------------------------------
    [self testKeychain];
}


/**
 获取字符串的MD5值比较简单,其它对象可以先转化成NSData对象再进行操作
 */
- (void)testMD5String {
    NSString *md5TestString = @"测试MD5";
    NSString *md5MString = [ZGMD5 getmd5WithString:md5TestString];
    NSLog(@"%@",md5MString);
}
/**
可以根据路径直接获取文件数据,也可以将对象写入文件件后获取为NSData对象
 */
- (void)testMD5Data {
    NSString *md5TestString = @"测试MD5";
    NSData *md5TestData = [md5TestString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *md5MString = [ZGMD5 getMD5WithData:md5TestData];
    NSLog(@"%@",md5MString);
}

//(明文+加盐)MD5加密调用
- (void)testAddSaftMD5String {
    NSString *md5TestString = @"测试MD5";
    md5TestString = [md5TestString stringByAppendingString:@"123456"];
    NSData *md5TestData = [md5TestString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *md5MString = [ZGMD5 getMD5WithData:md5TestData];
    NSLog(@"%@",md5MString);
}

//hmacMD5加密调用（先加密+乱序）
- (void)testHmacMD5String {
    NSString *md5TestString = @"测试MD5";
    NSString *md5MString = [ZGMD5 hmacMD5StringWithKey:@"123456" string:md5TestString];
    NSLog(@"%@",md5MString);
}

/**
 // 公钥加密时调用类方法：
 + (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
 + (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
 // 私钥解密时调用类方法
 + (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
 + (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privacy;
 */
- (void)testDES {
    NSString *encrypt = [ZGDes encryptWithText:@"中华人民共和国万岁！！"];
    NSLog(@"enctry = %@",encrypt);
    NSString *decrypt = [ZGDes decryptWithText:encrypt];
    NSLog(@"decrypt = %@",decrypt);
}

- (void)testRSA {
    // 获取公钥的数据
    // 公钥：iOS客户端使用，我们拿到公钥后，只需要根据公钥处理数据就可以了
    NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\n MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYRCxFDv5hxT8pYmRS0fayUsqu\nfwTTgKsCj49DWAPR+H7KLAmrrvvCfkBXOESqKfpRw7sXdqhpPIVBdq1gX0Ak9VOn\nsxLQhiSfu5USZWmSoU1Mk4/ZAJNsvYKDIhm92yvXMpezxw2+2sB1Sb2+Tv1ajnQm\n1JQsH8wR20gWxhwSrQIDAQAB\n-----END PUBLIC KEY-----";
    
    // 私钥：用于解密数据千万不能泄露，否则数据不安全
    NSString *privateKey = @"-----BEGIN PRIVATE KEY-----\nMIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANhELEUO/mHFPyli\nZFLR9rJSyq5/BNOAqwKPj0NYA9H4fsosCauu+8J+QFc4RKop+lHDuxd2qGk8hUF2\nrWBfQCT1U6ezEtCGJJ+7lRJlaZKhTUyTj9kAk2y9goMiGb3bK9cyl7PHDb7awHVJ\nvb5O/VqOdCbUlCwfzBHbSBbGHBKtAgMBAAECgYEArJoUPvWNftie5VeavCLI4l+D\nVasYXfkWAxAyhcvsGJtcDd0Bxtz8H6kFjtbgrnKcTr+JRVu1Y3Ai5jFihETg+maZ\nO0Uk/nhJrRrnec68WeK5GGiQRpu+v+EKsgGmdOXYS3guln2a5u9PGI79FymEVHTE\nSESYRSwQG1naO2NzV8ECQQDuJ+e7xIMnRcppoU3RSMml3tACyp+Av9G4zY7zTlLd\nywns02wKHBG40KulD36KAhBer46YmnKyl3hhOlnp22KRAkEA6HhmtyJuVTGNFM8U\nwxV4ncIit2I17mS+uU0nYE8FG2n3q4y8Ui0lJ/nma/ioT2qbgs6eQAP+bP+gL+kw\nt28EXQJAXMJiOfpCcyt1uUrAeoF1OQvdzRiKo6US1H4L7axWDlkk1n9Kl21zYZ61\nHCc6zBodsiOC0OFnRzRECOqnVrTCYQJBAJ87aU/jm6NrL3Gjbls558ZXZaQq9zn1\nc9ZFDMWhGqRubyDoY03+ckbxm201g0Pyh9aPZEIA+lL6vWRT2/SpbFkCQQCkMqvH\nqQ5voEwoIyDNZIsDzsluG861pccbWVGk2ka4l8V/LKpPR+S0JnDgK6j1g7PuFmO1\nPgcCC5O1ojniMPlz\n-----END PRIVATE KEY-----";
    
    // 创建字符串
    NSString *testStr = @"学习是第一生产力";
    NSString *encPublicKey;
    NSString *encPrivateKey;
    encPublicKey = [ZGRSA encryptString:testStr publicKey:publicKey];
    
    NSLog(@"%@", encPublicKey);
    encPrivateKey = [ZGRSA decryptString:encPublicKey privateKey:privateKey];
    
    NSLog(@"%@",encPrivateKey);
}

/**
 引入标准头文件,生成钥匙串对象,存储加密的数据,获得钥匙串对象,获取加密的数据
 */
- (void)testKeychain {
     // 1.创建钥匙串对象
     // 参数1：标识，用于识别加密的内容（回传标识符）
     // 参数2：分组，一般为nil
     ZGKeychainItemWrapper *keychainItem = [[ZGKeychainItemWrapper alloc] initWithIdentifier:@"myItemWrapper" accessGroup:nil];

     // 常用于加密用户名和密码
     // 系统提供的键值对中的两个键，非系统的键，是无法添加到字典中的
     id kUserName = (__bridge id) kSecAttrAccount;
     id kUserPassword = (__bridge id) kSecValueData;

     [keychainItem setObject:@"zhangge" forKey:kUserName];
     [keychainItem setObject:@"123456" forKey:kUserPassword];

     // 从keychain中获取存储的数据
     // 用户
     NSString *userName = [keychainItem objectForKey:kUserName];
     // 密码
     NSString *userPassword = [keychainItem objectForKey:kUserPassword];
     NSLog(@"%@，%@", userName, userPassword);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
