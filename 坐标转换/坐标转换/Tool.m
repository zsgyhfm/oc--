//
//  Tool.m
//  坐标转换
//
//  Created by vina on 16/4/11.
//  Copyright © 2016年zsgyhfm. All rights reserved.
//

#import "Tool.h"
#import "beaconModel.h"
#import "BRTBeaconSDK.h"

@interface Tool ()

@end
@implementation Tool

#pragma mark - 保存/读取本地plist文件
//保存ibeacon坐标位置文件
-(void)save
{
    //保存地址
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    //拼接路径
    NSString *filePath=[path stringByAppendingPathComponent:@"ibeacon.plist"];
    self.filePath=filePath;

    //写入的数据
    //大门
    CGPoint gate=CGPointMake(34.333313,305.000000);
    NSValue *point1=[NSValue valueWithCGPoint:gate];
    NSData *date1=[NSKeyedArchiver archivedDataWithRootObject:point1 ];
    

    //柱子
    CGPoint center=CGPointMake(375,535);
    NSValue *point2=[NSValue valueWithCGPoint:center];
    NSData *date2=[NSKeyedArchiver archivedDataWithRootObject:point2 ];

    //会议室门口
    //柱子
    CGPoint huiyi=CGPointMake(375,535);
    NSValue *point3=[NSValue valueWithCGPoint:huiyi];
    NSData *date3=[NSKeyedArchiver archivedDataWithRootObject:point3 ];
    
    NSDictionary *ibeaconDic=@{@"gateIbeacon":date1,
                               @"center":date2,
                               @"huiyi":date3
                               };


    //保存到本地
    //判断是否保存成功
   
    if ([ibeaconDic writeToFile:filePath atomically:YES]) {
        NSLog(@"保存成功");
    }else
    {
        NSLog(@"保存失败");
    }
}

///读取本地plist
-(NSDictionary *)readPlist
{
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:self.filePath];
//  NSData *date=  dic[@"gateIbeacon"];
//    [self translate:date];
//    NSLog(@"%@",[self translate:date]);
    return dic;
}

///将二进制转换为转换前的类型
-(id)translate:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}



#pragma mark - 三角定位算法
/**
 *  三角定位引擎
 *
 *  @param ibeaconPoint 传入一个包含三个ibeacon的坐标的数组
 *
 *  @return 返回当前人所处的坐标点
 */
-(CGPoint)ibeaconLocation:(NSArray<beaconModel*>*)ibeaconPoint{

    //遍历数组
    beaconModel *model1=ibeaconPoint[0];
    beaconModel *model2=ibeaconPoint[1];
    beaconModel *model3=ibeaconPoint[2];

    //取得三个点的坐标
    CGFloat p1x=model1.pointX;
    CGFloat p2x=model2.pointX ;
    CGFloat p3x=model3.pointX;

    CGFloat p1y=model1.pointY;
    CGFloat p2y=model2.pointY;
    CGFloat p3y=model3.pointY ;

    //取得用户到三个点的距离
    CGFloat d1=model1.distance ;
    CGFloat d2=model2.distance;
    CGFloat d3=model3.distance;
    //三点定位
    CGFloat x=0;
    CGFloat x1=0;
    CGFloat x2=0;
    CGFloat x3=0;
    CGFloat y=0;
    CGFloat y1=0;
    CGFloat y2=0;
    CGFloat y3=0;


    //
    x1=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1y-p3y);
    x2=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1y-p2y);
    x3=((p1x-p2x)*(p1y-p3y)-(p1x-p3x)*(p1y-p3y))*2;
    x=(x1-x2)/x3;



    y1=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1x-p3x);
    y2=(pow(p1x, 2)-pow(p3x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1x-p2x);
    y3=((p1y-p2y)*(p1x-p3x)-(p1y-p3y)*(p1x-p2x))*2;
    y=(y1-y2)/y3;

    return CGPointMake(x, y);
}




@end
