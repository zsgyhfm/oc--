//
//  MapImageView.m
//  坐标转换
//
//  Created by vina on 16/4/11.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "MapImageView.h"

@implementation MapImageView

-(void)drawRect:(CGRect)rect
{


//    CGContextRef tex=UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(tex,  466.833328,1.666664);
//    CGContextAddLineToPoint(tex, 566.833328,1.666664);
//
//    CGContextAddLineToPoint(tex, 563.833344,89.833328);
//    CGContextAddLineToPoint(tex,  463.833344,89.833328);
//    CGContextClosePath(tex);
//    [[UIColor blackColor]set];
//    CGContextSetLineWidth(tex, 4);
//    CGContextStrokePath(tex);
    [self mapMargin];
    [self technolege];
    [self gate];
}

//地图描边
-(void)mapMargin
{
    NSLog(@"地图描边");

    CGContextRef tex=UIGraphicsGetCurrentContext();
    //第一个点
    CGContextMoveToPoint(tex,  3    ,3);
    //第二个点
    CGContextAddLineToPoint(tex, 565.666656,3);
    //第三个点
    CGContextAddLineToPoint(tex,  561.333313,276.333313);
    //第四个点
    CGContextAddLineToPoint(tex,  627.666656,276.333313);
    //第五个点
    CGContextAddLineToPoint(tex,  617.666656,533.666656);
    //第六个点
    CGContextAddLineToPoint(tex,  689.666656,542.333313);
    //第七个点
    CGContextAddLineToPoint(tex,  692.333313,807.000000);
    //第八个点
    CGContextAddLineToPoint(tex,  750,816.33331);
    //第九个点
    CGContextAddLineToPoint(tex,  750,1070);
    //第十个点
    CGContextAddLineToPoint(tex,  3,1026.000000);
    CGContextClosePath(tex);
    [[UIColor blackColor]set];
    CGContextSetLineWidth(tex, 4);
    CGContextStrokePath(tex);



}
///技术部区域
-(void)technolege
{
    CGContextRef ref=UIGraphicsGetCurrentContext();
    //1.
    CGContextMoveToPoint(ref, 565.666656,3);
    //2
    CGContextAddLineToPoint(ref,  561.333313,276.333313);
    //3
    CGContextAddLineToPoint(ref,  461.333313,276.333313);
    //4
    CGContextAddLineToPoint(ref,  465.666656,3);

    //闭合
    CGContextClosePath(ref);

    //颜色
    [[UIColor orangeColor]set];
    CGContextSetLineCap(ref, kCGLineCapRound);
    CGContextStrokePath(ref);
}

//大门
-(void)gate
{
    CGContextRef ref=UIGraphicsGetCurrentContext();
    //1.
    CGContextMoveToPoint(ref, 0,209.574097);
    //2
    CGContextAddLineToPoint(ref,  50,209.574097);
    //3
    CGContextAddLineToPoint(ref,  50,409.574097);
    //4
    CGContextAddLineToPoint(ref,  0,409.574097);

    //闭合
//    CGContextClosePath(ref);

    //颜色
    [[UIColor orangeColor]set];
    CGContextSetLineCap(ref, kCGLineCapRound);
    CGContextStrokePath(ref);

}
@end
