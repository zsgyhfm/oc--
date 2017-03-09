//
//  beaconModel.m
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "beaconModel.h"

@implementation beaconModel
-(instancetype)initWithDic:(NSDictionary *)dic
{

    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"KVC属性为寻找到");
}

+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}


-(instancetype)initWithPoint:(CGPoint)point andMaxNum:(NSInteger)maxNum andMinNum:(NSInteger)minNum andDistance:(CGFloat)distance
{
    if (self=[super init])
    {
        _pointX=point.x;
        _pointY=point.y;
        _maxNum=maxNum;
        _minNum=minNum;
        _distance=distance;
    }
    return self;
}

-initWithPoint:(CGPoint)point andMaxNum:(NSInteger)maxNum  andMinNum:(NSInteger)minNum
{

    if (self=[super init])
    {
        _pointX=point.x;
        _pointY=point.y;
        _maxNum=maxNum;
        _minNum=minNum;
    }
    return self;
}

@end
