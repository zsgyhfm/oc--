//
//  ViewController.m
//  pageViewContro
//
//  Created by 依山观澜 on 16/4/10.
//  Copyright © 2016年 依山观澜. All rights reserved.
//

#import "ViewController.h"
#import "pageViewVC.h"
@interface ViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property(nonatomic,strong)NSArray *sourceArr;
@property(nonatomic,assign)NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初试化标记
    self.index=0;
    
    //设置第一页
    pageViewVC *vc=[[pageViewVC alloc] init];
    vc.imgView.image=[UIImage imageNamed:self.sourceArr[self.index]];
    
      //设置 要显示的控制器 参数 direction 导航方向
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //这个代理必须设定
    self.delegate=self;
    self.dataSource=self;
   
}

#pragma mark - dataSource代理
//下一个控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index++;
    if (self.index==self.sourceArr.count)
    {
        self.index--;
        return nil;
    }else
    {
        pageViewVC *vc=[[pageViewVC alloc] init];
        vc.imgView.image=[UIImage imageNamed:self.sourceArr[self.index]];
        return vc;
    }
}
//上一个
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.index--;
    if (self.index<0)
    {
        self.index=0;
        return nil;
    }else
    {
        
        pageViewVC *vc=[[pageViewVC alloc] init];
        vc.imgView.image=[UIImage imageNamed:self.sourceArr[self.index]];
        return vc;
    }
    return nil;
}

#pragma mark - 代理
//设置翻页起点方向
-(UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController
{
    return UIInterfaceOrientationLandscapeLeft;
}

//设置翻页起点脊柱
-(UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - 懒加载
-(NSArray *)sourceArr
{
    
    if (_sourceArr==nil) {
        _sourceArr=@[@"1",@"2",@"3"];
    }
    return _sourceArr;

}
@end
