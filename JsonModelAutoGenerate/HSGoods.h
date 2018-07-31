//
//  HSGoods.h
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini的Mac mini on 2018/07/31
//  Copyright © 2018年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<YYModel/YYModel.h>)
  #import <YYModel/YYModel.h>
#else
  #import "YYModel.h"
#endif


@interface HSGoodsData : NSObject<NSCoding, NSCopying>

@property (nonatomic ,copy)NSString  *thum_picurl;
@property (nonatomic ,copy)NSNumber  *id;
@property (nonatomic ,copy)NSString  *title;
@property (nonatomic ,copy)NSString  *desc;
@property (nonatomic ,copy)NSString  *addr;
@property (nonatomic ,copy)NSString  *tel;


@end

@interface HSGoods : NSObject<NSCoding, NSCopying>

@property (nonatomic ,assign)BOOL  status;
@property (nonatomic ,copy)HSGoodsData  *data;
@property (nonatomic ,copy)NSString  *message;
@property (nonatomic ,copy)NSNumber  *statusCode;


@end

