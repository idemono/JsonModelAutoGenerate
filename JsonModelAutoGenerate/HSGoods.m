//
//  HSGoods.m
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini的Mac mini on 2018/07/31
//  Copyright © 2018年 HS. All rights reserved.
//

#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

#import "HSGoods.h"
@implementation HSGoodsData 

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc":@"description"};
}

YYModelSynthCoderAndHash

@end

@implementation HSGoods 

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}

YYModelSynthCoderAndHash

@end

