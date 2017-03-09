//
//  ViewController.m
//  UIVisualEffectView-图片模糊效果
//
//  Created by vina on 16/4/20.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
///图片背景
@property(nonatomic,strong)UIImageView  *imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUI];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}
/*
 UIVisualEffectView 是一个模糊视图容器 其中需要包含一个 模糊对象UIBlurEffect

 */

#pragma mark - 布局
-(void)setUI
{
    [self.view addSubview:self.imageView];

    self.imageView.image=[UIImage imageNamed:@"1.jpg"];

    //创建一个模糊效果的对象
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    //将模糊对象传递给 模糊对象视图
    UIVisualEffectView *effectView=[[UIVisualEffectView alloc] initWithEffect:blur];

//    effectView.frame=CGRectMake(100, 550, self.view.frame.size.width-200, 100);

    effectView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);

    effectView.alpha=1;//设置 透明度。建议不要设置小于1的值

//    effectView.backgroundColor=[UIColor clearColor];//设定模糊视图的颜色
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];

//    lable.text=@"看个毛啊";
    [effectView addSubview:lable];

    //添加模糊视图到当前view
    [self.view addSubview:effectView];

    //如果从代码层次使用autoLayout 就需要禁用这个 否则无法生效 继续沿用以前的autoresizingMask
    self.view.translatesAutoresizingMaskIntoConstraints=NO;

    CGRect arear=CGRectZero;//区域
    CGRect point=CGRectZero;//当前定位点（也可当做是一个矩形）
    CGRect result=   CGRectIntersection(arear, point);//传入两个矩形 对比如果没有有交集就返回空
    CGRectIsNull(result);//判断结果是否为空
}

#pragma mark - 懒加载
-(UIImageView *)imageView
{
    if (_imageView==nil) {
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;

    }
    return _imageView ;
}
@end
