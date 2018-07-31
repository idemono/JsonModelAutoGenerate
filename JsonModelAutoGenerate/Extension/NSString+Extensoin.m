//
//  NSString+Extensoin.m
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini on 2018/7/31.
//  Copyright © 2018年 HS. All rights reserved.
//

#import "NSString+Extensoin.h"

@implementation NSString (Extensoin)

+ (NSString *)copyingRightWithFileName:(NSString *)fileName {
    NSMutableString * value = [NSMutableString string];
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSString * dateStr = [dateFormatter stringFromDate:date];
    [value appendString:@"//\n"];
    [value appendString:[NSString stringWithFormat:@"//  %@\n",fileName]];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    [value appendString:[NSString stringWithFormat:@"//  %@\n", [infoDict objectForKey:@"CFBundleName"]]];
    [value appendString:@"//\n"];
    [value appendString:[NSString stringWithFormat:@"//  Created by %@ on %@\n", [NSHost currentHost].localizedName,dateStr]];
    [value appendString:[NSString stringWithFormat:@"//  %@\n", [infoDict objectForKey:@"NSHumanReadableCopyright"]]];
    [value appendString:@"//\n\n"];
    
    return value;
}

+ (NSString *)getClassName:(id)obj{
    NSString *className = [[obj className] lowercaseString];
    NSString *standClassName = @"NSString";
    if ([className containsString:@"string"]){
        standClassName = @"NSString";
    }else if ([className containsString:@"null"]){
        standClassName = @"NSString";
    }else if ([className containsString:@"array"]){
        standClassName = @"NSArray";
    }else if ([className containsString:@"dictionary"]){
        standClassName = @"NSDictionary";
    }else if ([className containsString:@"number"]){
        standClassName = @"NSNumber";
    }else if ([className containsString:@"bool"]){
        standClassName = @"BOOL";
    }
    return standClassName;
}

+ (NSString *)getPropertyDescStr:(NSString *)name type:(NSString *)type{
    
    NSMutableString * value = [NSMutableString string];
    [value appendString:@"@property (nonatomic ,"];
    [value appendString:[self getPropertyType:type]];
    [value appendString:@")"];
    [value appendString:type];
    [value appendString:@"  "];
    if (![type isEqualToString:@"BOOL"]) {
        [value appendString:@"*"];
    }
    [value appendString:name];
    [value appendString:@";\n"];
    return value;
}


+ (NSString *)getPropertyType:(NSString *)classType{
    if ([classType isEqualToString:@"BOOL"] ){
        return @"assign";
    }else{
        return @"copy";
    }
}

@end
