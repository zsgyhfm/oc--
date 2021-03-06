//
//  DrawView.m
//  画板
//
//  Created by vina on 16/4/7.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "DrawView.h"
@interface DrawView()
///存放线条
@property(nonatomic,strong)NSMutableArray *lines;


@end
@implementation DrawView

#pragma mark -  绘制线条
-(void)drawRect:(CGRect)rect
{

    //获取上下文-当前上下文
    CGContextRef context=UIGraphicsGetCurrentContext();

    //设置两端样式
    CGContextSetLineCap(context, kCGLineCapRound);

    //设置转角样式
    CGContextSetLineJoin(context, kCGLineJoinRound);

    //设置宽度
    CGContextSetLineWidth(context, 4);



    [self.lines enumerateObjectsUsingBlock:^(NSMutableArray *line, NSUInteger idx, BOOL *stop) {

        [line enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
            CGPoint point = [pointValue CGPointValue];
            if (idx == 0) {
                // 确定起点
                CGContextMoveToPoint(context, point.x, point.y);
            } else {
                CGContextAddLineToPoint(context,point.x, point.y);
            }
        }];
        // 根据idx获得颜色-这样可以让每条线都有自己的颜色
        //如果颜色数组的长度小于线段长度那么显示颜色数组最后一个颜色

        UIColor *color=self.lineColors[idx];
        [color set];
        // 渲染
        CGContextStrokePath(context);
    }];




}

#pragma mark - 保存 截图
-(void)save
{
    //1.开启图像上下文
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    //渲染到上下文
   [ self.layer  renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文获得图片
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    //保存到相册--这里需要注意 这里参数里面的方法必须包含这几个参数
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImage:error:contextinfo:), nil);
    // 关闭
    UIGraphicsEndImageContext();
}
//保存图片后的回调方法
-(void)saveImage:(UIImage *)img error:(NSError *)error contextinfo:(void *)contextinfo{
    NSLog(@"错误%@",error);
}

-(CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view{

    return CGPointZero;
}
#pragma mark - 获取线条的点
//获取线段的第一个点
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches  anyObject];

    //获得触摸点
    CGPoint currentPoint=[touch locationInView:self];

    //将点转换为NSValue存入数组
    NSValue *point=[NSValue valueWithCGPoint:currentPoint];
    NSMutableArray *line=[NSMutableArray arrayWithObject:point];

    // 设置线的颜色
    UIColor *color=self.color;
    if (self.color) {
        [self.lineColors addObject:color];
    }else{
        [self.lineColors addObject:[UIColor blackColor]];
    }

    [self.lines addObject:line];
    //通知重绘
    [self setNeedsDisplay];
}

//手势结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];

}
// 当手势被打断调用
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 或许线条其他的点
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch=[touches  anyObject];

    //获得触摸点
    CGPoint currentPoint=[touch locationInView:self];
    
    //将点存入数组
    NSMutableArray *line=[self.lines lastObject];
    [line addObject:[NSValue valueWithCGPoint:currentPoint]];

    //通知重绘
    [self setNeedsDisplay];

}

#pragma mark - 懒加载
-(NSMutableArray *)lines
{
    if (_lines==nil) {
        _lines=[NSMutableArray array];
    }
    return _lines ;
}
-(NSMutableArray *)lineColors
{
    if (_lineColors==nil) {
        _lineColors=[NSMutableArray array];

    }
    return _lineColors ;
}
@end
