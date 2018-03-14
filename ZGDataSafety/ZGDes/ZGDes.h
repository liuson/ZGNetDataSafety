//
//  ZGDes.h
//  ZGDataSafety
//
//  Created by 彰雪林 on 2018/3/13.
//  Copyright © 2018年 彰雪林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGDes : NSObject

+ (NSString *)encryptWithText:(NSString *)sText;
+ (NSString *)decryptWithText:(NSString *)sText;

@end
