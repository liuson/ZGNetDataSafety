//
//  ViewController.m
//  ZGDataSafety
//
//  Created by 彰雪林 on 2018/3/13.
//  Copyright © 2018年 彰雪林. All rights reserved.
//

#import "ViewController.h"
#import "ZGDes.h"
#import "ZGRSA.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //DES
    NSString *encrypt = [ZGDes encryptWithText:@"中华人民共和国万岁！！"];
    NSLog(@"enctry = %@",encrypt);
    NSString *decrypt = [ZGDes decryptWithText:encrypt];
    NSLog(@"decrypt = %@",decrypt);
    
    
    
    //RSA
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
