//
//  ViewController.m
//  添加标记点到图片
//
//  Created by vina on 16/4/6.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
@interface ViewController ()
//图片
@property(nonatomic,strong)UIImageView *imgView;
//复原按钮
@property(nonatomic,strong)UIButton *resetButton;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
    self.view.backgroundColor=[UIColor redColor];
}

#pragma mark - 布局UI
-(void)setUI
{
    NSLog(@"布局UI");
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    img.backgroundColor=[UIColor grayColor];
    img.frame=self.view.bounds;


    img.center=self.view.center;
    img.userInteractionEnabled=YES;

    //捏合手势
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchClick:)];
    //点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //拖拽手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [img addGestureRecognizer:pinch];
    [img addGestureRecognizer:tap];
    [img addGestureRecognizer:pan];

    [self.view addSubview:img];

    img.contentMode=UIViewContentModeScaleAspectFit;

    self.imgView=img;

    //添加复位按钮
    UIButton *btm=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 100, 30)];
    [btm setTitle:@"复位" forState:(UIControlStateNormal)];
    [btm setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [btm addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    btm.backgroundColor=[UIColor whiteColor];
    self.resetButton=btm;

    [self.view addSubview:btm];

}
#pragma mark - 复位按钮方法
-(void)resetClick
{

    NSLog(@"复位前%f",self.imgView.frame.origin.x);

    [UIView animateWithDuration:1 animations:^{
       self.imgView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
     NSLog(@"复位后%f",self.imgView.frame.origin.x);
 }

#pragma mark - 手势的回调方法
//捏合手势
-(void)pinchClick:(UIPinchGestureRecognizer *)pinch
{
//判断如果图片偏移到屏幕边上就禁止捏合
    if (self.imgView.frame.origin.x<-(self.imgView.frame.size.width-100) ||self.imgView.frame.origin.x>self.imgView.frame.size.width*2-100||self.imgView.frame.origin.x>(self.view.frame.size.width-100)||self.imgView.frame.origin.y<-(self.view.frame.size.height-100)) {
        return;
    }
    float scale=pinch.scale;
      self.imgView.transform=CGAffineTransformScale(self.imgView.transform, scale, scale);
    CGFloat currentScale=self.imgView.frame.size.width/[UIScreen mainScreen].bounds.size.width;
    //限制缩放比例
    if (currentScale>3)
    {
        //如果图片尺寸大于3倍就停止捏合

        [UIView animateWithDuration:1 animations:^{
            self.imgView.transform=CGAffineTransformMakeScale(2.99 , 2.99);
        }];

    }
    else if(currentScale<0.7)
    {
        NSLog(@"小于0.7");
        [UIView animateWithDuration:1 animations:^{
            self.imgView.transform=CGAffineTransformMakeScale(0.71, 0.71);
        }];
    }

    pinch.scale=1;
    NSLog(@"图片的宽度倍数%f",self.imgView.frame.size.width/[UIScreen mainScreen].bounds.size.width);



}
//点击手势
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    //获取点
   CGPoint point= [tap locationInView:tap.view];
    NSLog(@"触摸点的x=%f 触摸的y=%f",point.x,point.y);

    //根据获得的点的坐标绘制图
    UIImage *img=[UIImage imageNamed:@"1"];
    UIImageView *vc=[[UIImageView alloc] initWithImage:img];
    vc.frame=CGRectMake(point.x, point.y, 8, 8);
    vc.layer.cornerRadius=4;
    vc.layer.masksToBounds=YES;

    [self.imgView addSubview:vc];

}
//拖拽手势
-(void)panClick:(UIPanGestureRecognizer *)pan
{

    CGPoint point =[pan translationInView:self.view];

    self.imgView.transform=CGAffineTransformTranslate(self.imgView.transform, point.x, point.y);

    //设置当前移动后的tranform为起点-大概是这么意思-否则拖拽完毕后 第二次拖拽 会还原到原来位置 在移动
    [pan setTranslation:CGPointZero inView:self.view];

    //redView偏移到左边  redView只剩下一半在屏幕,返回到一半的样子
    if (self.imgView.frame.origin.x<=-(self.imgView.frame.size.width-100))
    {

        [UIView animateWithDuration:1 animations:^{
            CGRect fram= self.imgView.frame;
            fram.origin.x=-(self.imgView.frame.size.width-100);
            self.imgView.frame=fram;
        }];

    }

    //偏移到右边 redView只剩下一半在屏幕,返回到一半的样子
    if (self.imgView.frame.origin.x>(self.view.frame.size.width-100))
    {

        [UIView animateWithDuration:1 animations:^{
            CGRect fram= self.imgView.frame;
            fram.origin.x=self.view.frame.size.width-100;
            self.imgView.frame=fram;
        }];

    }
    //偏移下面
    if (self.imgView.frame.origin.y>self.view.frame.size.height-100) {
        [UIView animateWithDuration:1 animations:^{
            CGRect fram= self.imgView.frame;
            fram.origin.y=self.view.frame.size.height-100;
            self.imgView.frame=fram;
        }];
    }
    //偏移上面
    if (self.imgView.frame.origin.y<-(self.view.frame.size.height-100)) {
        [UIView animateWithDuration:1 animations:^{
            CGRect fram= self.imgView.frame;
            fram.origin.y=-(self.view.frame.size.height-100);
            self.imgView.frame=fram;
        }];
    }


}
@end
