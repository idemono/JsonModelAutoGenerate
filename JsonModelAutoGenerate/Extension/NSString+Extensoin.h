//
//  NSString+Extensoin.h
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini on 2018/7/31.
//  Copyright © 2018年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensoin)

//.m .h 文件头部Copyright
+ (NSString *)copyingRightWithFileName:(NSString *)fileName;
//获取对象类型的String
+ (NSString *)getClassName:(id)obj;
//.h文件中,每个属性 如:@property(nonatomic,copy)NSString *name;
+ (NSString *)getPropertyDescStr:(NSString *)name type:(NSString *)type;
//获取对象特性 如:copy,assign
+ (NSString *)getPropertyType:(NSString *)classType;
@end
