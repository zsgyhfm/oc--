//
//  beaconModel.h
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
/*模型里面的数据 要用NSNumber类型 因为数组和字典里面只能存元素*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface beaconModel : NSObject
///设备名称
//@property(nonatomic,copy)NSString *name;
///坐标点x
@property(nonatomic,assign)CGFloat pointX;
///坐标点y
@property(nonatomic,assign)CGFloat pointY;
///用户距离设备的距离
@property(nonatomic,assign)CGFloat distance;
///主要值
@property(nonatomic,assign)NSInteger maxNum;
///次要要值
@property(nonatomic,assign)NSInteger minNum;

///字典转模型
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

///创建最终定位模型
-initWithPoint:(CGPoint)point andMaxNum:(NSInteger)maxNum  andMinNum:(NSInteger)minNum andDistance:(CGFloat)distance;
///创建网络取得的模型
-initWithPoint:(CGPoint)point andMaxNum:(NSInteger)maxNum  andMinNum:(NSInteger)minNum ;
@end
