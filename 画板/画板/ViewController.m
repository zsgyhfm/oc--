//
//  ViewController.m
//  画板
//
//  Created by vina on 16/4/7.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DrawView.h"
@interface ViewController ()
///画板
@property(nonatomic,strong)DrawView *drawView;

///颜色选择
@property(nonatomic,strong)UIButton *colorBtn;
///保存按钮
@property(nonatomic,strong)UIButton *saveBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addDraw];

    [self selectColor];
    [self.view addSubview:self.saveBtn];
}

//添加画板
-(void)addDraw{

    self.drawView=[[DrawView alloc] initWithFrame:CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-100)];
    self.drawView.backgroundColor=[UIColor whiteColor];
    self.drawView.layer.borderWidth=1;
    //初始颜色是黑色

    [self.view addSubview:self.drawView];

    NSLog(@"数组长度%@",self.drawView.lineColors);

}

//添加按钮
-(void)selectColor{
    //添加按钮
    [self.view addSubview:self.colorBtn];


}
///设置颜色
-(void)selectLineColor
{
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(256)/ 255.0f green:arc4random_uniform(256)/ 255.0f blue:arc4random_uniform(256)/ 255.0f alpha:1.0];
    self.drawView.color=color;
    NSLog(@"随机颜色%@",color);
    
}
//保存截图
-(void)saveImage
{
    [self.drawView save];
}

#pragma mark - 懒加载
-(UIButton *)colorBtn
{
    if (_colorBtn==nil) {
        _colorBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _colorBtn.frame=CGRectMake(20, 20, 100, 30);
        _colorBtn.backgroundColor=[UIColor orangeColor];
        [_colorBtn setTitle:@"随机颜色" forState:(UIControlStateNormal)];
        [_colorBtn addTarget:self action:@selector(selectLineColor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorBtn ;
}

-(UIButton *)saveBtn
{
    if (_saveBtn==nil) {
        _saveBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _saveBtn.frame=CGRectMake(120, 20, 100, 30);
        _saveBtn.backgroundColor=[UIColor redColor];
        [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
        [_saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn ;
}
@end
