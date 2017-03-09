//
//  ViewController.m
//  坐标转换
//
//  Created by vina on 16/4/7.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
/*
 
 注意：地图的中心点不能用父视图进行计算-利用宽高
 
 */

#import "ViewController.h"
#import "MapImageView.h"
#import "BRTBeaconSDK.h"
#import "beaconModel.h"
#import "Tool.h"
#define Dscale 0.5
#define locationSize 50
static NSString *const UUID1=@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString *const UUID2=@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
@interface ViewController ()<UIPopoverPresentationControllerDelegate>
///加载的地图
@property (strong, nonatomic)  UIImageView *img;
///popo弹窗
@property(nonatomic,strong)UIViewController *vc;
//存储地图的实际大小
@property(nonatomic,assign)CGSize mapSize;
///全局按钮-
@property(nonatomic,strong)UIButton *onlyBtn;
///当前视图是否在边缘
@property(nonatomic,assign)BOOL isMargin;
///UUID数组
@property(nonatomic,strong)NSArray *UUIDArr;
///ibeacon模型
@property(nonatomic,strong)beaconModel *model;
///最终定位数据
@property(nonatomic,strong)NSMutableArray *locationArr;
///请求的ibeacon坐标数据源
@property(nonatomic,strong)NSArray *testIbeaconArr;
///搜素数据源
@property(nonatomic,strong)NSArray *tableArr;
///工具类
@property(nonatomic,strong)Tool *tool;
///当前定位点
@property(nonatomic,strong)UIButton *currentLocationButton;
///是否定位成功
@property(nonatomic,assign)BOOL isLocationSeccuss;
///定位按钮
@property(nonatomic,strong)UIButton *locationBtn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //布局UI
    [self setUI];
    
    //拖拽手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    //缩放手势
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchClick:)];
    [self.img addGestureRecognizer:pan];
    [self.img addGestureRecognizer:pinch];
    
    self.isMargin=NO;
    
    
    //TODO:测试
//    NSArray *arr1=@[@{@"name":@"1"}];
//    NSMutableArray *arr=[NSMutableArray array];
//    [arr addObject:@1];
//    [arr removeAllObjects];
//    
//    NSLog(@"不可变数组数组%@",[arr1 class]);
//    NSLog(@"可变数组数组%@",[arr class]);
    
}



#pragma mark - 布局
-(void)setUI
{
    UIImage *map=[UIImage imageNamed:@"底图"];
    self.mapSize=map.size;
    self.img.image=map;
    [self.view addSubview:self.img];
    [self.img sizeToFit];
    [self drawF];
    
    //添加画板View
    UIView *vc=[[MapImageView alloc] initWithFrame:self.img.bounds];
    vc.backgroundColor=[UIColor clearColor];
    vc.userInteractionEnabled=NO;
    [self.img addSubview: vc];
    
    //地图的中心点不等同与屏幕中心点-所以地图中心点要根据实际尺寸来计算中心点
    CGPoint mapCenter=CGPointMake(self.mapSize.width/2, self.mapSize.height/2);
    
    CGPoint mapCenter1=CGPointMake(34.333313,305.000000);
    CGPoint mapCenter2=CGPointMake(516.333313,148.333313);
    CGPoint mapCenter3=CGPointMake(323.065822,528.199065);
    CGPoint mapCenter4=CGPointMake(338.333313,60);
    
    NSLog(@"view中心点(%f,%f)",self.view.center.x,self.view.center.y/2);
    NSLog(@"标记点(%f,%f)",self.mapSize.width/2,self.mapSize.height/2);
    NSLog(@"地图宽高(%f,%f)",self.mapSize.width,self.mapSize.height);
    
    //添加标记点到地图
    [self.img addSubview:[self locationIbeaconWithPoint:mapCenter andTitle:@"柱子"]];
    [self.img addSubview:[self locationIbeaconWithPoint:mapCenter1 andTitle:@"大门ibeacon3"]];
    [self.img addSubview:[self locationIbeaconWithPoint:mapCenter2 andTitle:@"技术部"]];
    [self.img addSubview:[self locationIbeaconWithPoint:mapCenter3 andTitle:@"ibeacon1"]];
    [self.img addSubview:[self locationIbeaconWithPoint:mapCenter4 andTitle:@"ibeacon2"]];
    
    
    ///添加定位按钮到view
    UIButton *locationBtn=[[UIButton alloc] initWithFrame:CGRectMake(30, 30, 30, 30)];
    [locationBtn setImage:[UIImage imageNamed:@"1"] forState:(UIControlStateNormal)];
    self.locationBtn=locationBtn;
    NSArray *gif=[NSArray arrayWithObjects:   [UIImage imageNamed:@"1"],
                  [UIImage imageNamed:@"2"],
                  [UIImage imageNamed:@"3"],
                  [UIImage imageNamed:@"4"],
                  [UIImage imageNamed:@"5"],
                  [UIImage imageNamed:@"6"],
                  [UIImage imageNamed:@"7"],
                  [UIImage imageNamed:@"8"],
                  nil
                  ];
    
    locationBtn.imageView.animationImages=gif;
    locationBtn.imageView.animationDuration=1.5;
    locationBtn.imageView.animationRepeatCount=MAXFLOAT;
    [locationBtn addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    
    
    //给地图添加kvo监听
    [self.img addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
    
    
}
#pragma mark - 开始室内定位
-(void)startLocation:(UIButton *)sender
{
    //是地图回复原装
    self.img.transform=CGAffineTransformIdentity;
    //初始化
    self.isLocationSeccuss=NO;
    sender.selected=!sender.selected;
    if (sender.selected)
    {
        //TODO: 开始扫描定位
        [self searchBeacon];
        
        //开始播放按钮动画
        [self.locationBtn.imageView startAnimating];
        
    }else
    {
        //停止扫描
        [BRTBeaconSDK stopRangingBrightBeacons];
        [self.locationBtn.imageView stopAnimating];
        
    }
    
}

#pragma mark - 创建标记
-(UIButton *)locationIbeaconWithPoint:(CGPoint)point andTitle:(NSString *)title
{
    UIButton *beacon=[UIButton buttonWithType:UIButtonTypeSystem];
    
    beacon.frame=CGRectMake(point.x-locationSize/2, point.y-locationSize, locationSize, locationSize/2);
    [beacon addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [beacon setTitle:title forState:(UIControlStateNormal)];
    beacon.titleLabel.font=[UIFont systemFontOfSize:15];
    
    beacon.layer.borderWidth=1;
    //给按钮添加监听防止缩放--无法实现
    
    
    return beacon;
    
}

#pragma mark - 按钮KVO监听地图的fram
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"KVO%f",self.img.frame.origin.x);
   
    // //如果处在边缘 禁止缩放手势
    if (self.img.frame.origin.x<-(self.img.frame.size.width-150))
    {
        CGRect fram= self.img.frame;
        fram.origin.x=-(self.img.frame.size.width-150);
        self.img.frame=fram;
        self.isMargin=YES;
        
    }
    
    if (self.img.frame.origin.x>(self.view.frame.size.width-150))
    {
       
        CGRect fram= self.img.frame;
        fram.origin.x=(self.view.frame.size.width-150);
        self.img.frame=fram;
        self.isMargin=YES;
        //            NSLog(@"X值=%f",fram.origin.x);
    }
    
    if (self.img.frame.origin.y<-(self.img.frame.size.height-150))
    {
        CGRect fram= self.img.frame;
        fram.origin.y=-(self.img.frame.size.height-150);
        self.img.frame=fram;
        self.isMargin=YES;
        
    }
    
    if (self.img.frame.origin.y>(self.view.frame.size.height-150))
    {
        NSLog(@"%f",self.img.frame.size.height-150);
        CGRect fram= self.img.frame;
        fram.origin.y=(self.view.frame.size.height-150);
        self.img.frame=fram;
        self.isMargin=YES;
    }


}

#pragma mark - 点击地图按钮事件
-(void)locationClick:(UIButton *)sender
{
    
    if (self.onlyBtn!=sender) {
        sender.selected=!sender.selected;
        self.onlyBtn.selected=NO;
        self.onlyBtn.layer.borderColor=[[UIColor blackColor]CGColor];
    }
    
    if (sender.selected)
    {
        sender.layer.borderColor=[[UIColor redColor]CGColor];
    }
    
    
    NSString *point=[NSString stringWithFormat:@"坐标[%f,%f]",sender.frame.origin.x+locationSize/2,sender.frame.origin.y+locationSize];
    //创建要弹出的控制器
    //设置弹出样式
    self.vc.modalPresentationStyle=UIModalPresentationPopover;
    
    self.vc.preferredContentSize=CGSizeMake(100, 50);
    self.vc.popoverPresentationController.delegate=self;
    self.vc.popoverPresentationController.sourceRect=sender.bounds;
    self.vc.popoverPresentationController.sourceView=sender;
    self.vc.popoverPresentationController.permittedArrowDirections=UIPopoverArrowDirectionDown;
    
    //设置popoverView的 穿透view
    //    self.vc.popoverPresentationController.passthroughViews=@[self.img];
    //    NSString *point=[NSString stringWithFormat:@"(%.2f,%.2f)",sender.frame.origin.x,sender.frame.origin.y+50];
    
    for (id vc in self.vc.view.subviews)
    {
        
        if ([vc isKindOfClass:[UILabel class]])
        {
            UILabel *lable=(UILabel *)vc;
            lable.text=[sender.titleLabel.text stringByAppendingString:point];
            
        }
        
    }
    
    self.onlyBtn=sender;//保证同时只有一个按钮被选中
    
    
    [self presentViewController: self.vc animated:YES completion:nil];
    
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    
    return UIModalPresentationNone;
    
}

#pragma mark - 拖拽手势
-(void)panClick:(UIPanGestureRecognizer *)pan
{
    
    CGPoint currentpoint=[pan translationInView:self.img];
    

    
    //设置拖拽范围
    if ( pan.state==UIGestureRecognizerStateChanged)
    {
        //TODO: 注意浮点类型是无限接近某个值-可以转成nsinterger类型
        NSLog(@"x=%f y=%f",self.img.frame.origin.x,self.img.frame.origin.y);
//        NSLog(@"最小x=%f",-(self.img.frame.size.width-150));
        float a=self.img.frame.size.width-150;
         NSLog(@"最小x=%f",a);
        BOOL ok1=(self.img.frame.origin.x)>=(-(self.img.frame.size.width-149));
        
        
        BOOL ok2=(self.img.frame.origin.x<=(self.view.frame.size.width-149));
       
        BOOL ok3=( self.img.frame.origin.y<=self.view.frame.size.height-149);
        BOOL ok4=self.img.frame.origin.y<=self.view.frame.size.height-149;
        
//        BOOL ok5=(self.img.frame.origin.x>=-(self.img.frame.size.width-149) && self.img.frame.origin.x<=(self.view.frame.size.width-150))
//        && (self.img.frame.origin.y>=-(self.img.frame.size.height-150) && self.img.frame.origin.y<=self.view.frame.size.height-150);
        BOOL ok5=ok1&&ok2&&ok3&&ok4;
        
        NSLog(@"OK1=%d",ok1);
        NSLog(@"OK2=%d",ok2);
        NSLog(@"OK3=%d",ok3);
        NSLog(@"OK4=%d",ok4);
        NSLog(@"OK5=%d",ok5);
        
//        (self.img.frame.origin.x>=-(self.img.frame.size.width-149) && self.img.frame.origin.x<=(self.view.frame.size.width-150))
//        && (self.img.frame.origin.y>=-(self.img.frame.size.height-150) && self.img.frame.origin.y<=self.view.frame.size.height-150)
        if (ok5)
        {
            self.isMargin=NO;//不在边缘
            self.img.transform=CGAffineTransformTranslate(self.img.transform, currentpoint.x, currentpoint.y);
        }
        

    }

    //设置下次拖拽点为起点
    [pan setTranslation:CGPointZero inView:self.img];
    
    
}
#pragma mark - 缩放手势
-(void)pinchClick:(UIPinchGestureRecognizer *)pinchClick
{

        CGFloat scale=pinchClick.scale;
        NSLog(@"缩放比例%f",scale);
        CGFloat currentScale=self.img.frame.size.width/self.mapSize.width;
        
        if (pinchClick.state==UIGestureRecognizerStateChanged)
        {
            if (currentScale<=2&&currentScale>=0.3)
            {
                
                self.img.transform=CGAffineTransformScale(self.img.transform, scale, scale);
            }
        }
        else if(pinchClick.state==UIGestureRecognizerStateEnded)
        {
            if (currentScale>2)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.img.transform=CGAffineTransformMakeScale(1.9, 1.9);
                }];
                self.img.layer.position=self.view.layer.position;
            }
            
            if (currentScale<0.3)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    self.img.transform=CGAffineTransformMakeScale( 0.3, 0.3);
                }];
                
            }
     //这里需要注意 每次缩放完毕要讲缩放比例初始化为1.--错误不必使用
//        scale=1;
        
    }
    
    
}

#pragma mark -  绘制基准线
-(void)drawF
{
    UIView *vc=[[UIView alloc] initWithFrame:CGRectMake(0, self.mapSize.height/2, self.img.frame.size.width/Dscale, 1)];
    UIView *vc1=[[UIView alloc] initWithFrame:CGRectMake(self.mapSize.width/2, 0, 1, self.mapSize.height)];
    vc.backgroundColor=[UIColor blackColor];
    vc1.backgroundColor=[UIColor blackColor];
    [self.img addSubview:vc];
    [self.img addSubview:vc1];
}



#pragma mark - 点击地图
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch=[touches anyObject];
    
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        CGPoint point =[touch locationInView:self.img];
        NSLog(@"地图中的点(%f,%f)",point.x,point.y);
    }
    
}




///搜索附近ibeacon
#pragma mark - 扫描BrightBeacon设备，uuids为NSUUID数组
-(void)searchBeacon{
    //    NSLog(@"开始搜索设备%@",self.UUIDArr);
    //搜索设备 属于耗时操作 异步执行
    //创建线程
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [BRTBeaconSDK startRangingBeaconsInRegions:nil onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error) {
            
            //根据距离排序
            self.tableArr=[beacons sortedArrayUsingComparator:^NSComparisonResult(BRTBeacon *obj1, BRTBeacon *obj2) {
                if ([obj1.distance floatValue]>[obj2.distance floatValue]) {
                    //左边小于右边
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
            NSLog(@"搜索的结果%@",self.tableArr);
            //创建数组保存匹配结果
            self.locationArr=[NSMutableArray array];
            
            //循环遍历 对比ibeacon的坐标
            for (int i=0; i<self.tableArr.count; i++)
            {   NSLog(@"循环内");
                BRTBeacon *beacon=self.tableArr[i];
                ///取得搜索结果数组中的结果进行匹配
                
                for (beaconModel *model in self.testIbeaconArr)
                {
                    //如果主要值和次要值等匹配 （等同）
                    if (beacon.major.integerValue==model.maxNum && beacon.minor.integerValue==model.minNum)
                    {
                        model.distance=beacon.distance.floatValue;
                        [self.locationArr addObject:model];
                    }
                }
            }
            
            NSLog(@"匹配的结果%@",self.locationArr);
            
            //当有三个或以上匹配的结果再执行定位
            if (self.locationArr.count>2)
            {
                //匹配完成后 执行定位操作
                //如果当前点存在则从地图上移除
                if (self.currentLocationButton)
                {
                    [self.currentLocationButton removeFromSuperview];
                }
                
                CGPoint location=  [self.tool ibeaconLocation:self.locationArr];
                
                //创建定位点
                self.currentLocationButton=[self locationIbeaconWithPoint:location andTitle:@"当前位置"];
                
                //添加到地图
                [self.img addSubview:self.currentLocationButton];
                
            }else
            {
                //主线程
                if (!self.isLocationSeccuss)
                {
                    self.isLocationSeccuss=YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
                        NSLog(@"%@",label);
                        [self.view addSubview:label];
                        label.text=@"附近匹配的ibeaocn设备不足三个无法定位";
                        label.font=[UIFont systemFontOfSize:13];
                        label.numberOfLines=0;
                        label.center=self.view.center;
                        label.backgroundColor=[UIColor blackColor];
                        label.textColor=[UIColor whiteColor];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.alpha=0;
                        
                        [UIView animateWithDuration:1 animations:^{
                            label.alpha=1;
                        }];
                        //延迟消失
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:1 animations:^{
                                label.alpha=0;
                                
                            }];
                            
                        });
                        
                    });
                    
                }
                
                
            }
            
            
        }];
        //进程循环
        [[NSRunLoop currentRunLoop] run];
        
    });
    
}


#pragma mark - 懒加载
-(UIImageView *)img
{
    if (_img==nil)
    {
        _img=[[UIImageView alloc] initWithFrame:self.view.bounds];
        _img.backgroundColor=[UIColor whiteColor];
        _img.userInteractionEnabled=YES;
        self.img.transform=CGAffineTransformMakeScale(Dscale, Dscale);
        self.img.layer.position=self.view.layer.position;
        
    }
    return _img ;
}
//懒加载弹出的控制器
-(UIViewController *)vc
{
    if (_vc==nil) {
        _vc=[[UIViewController alloc] init];
        _vc.view.frame=CGRectMake(0, 0, 100, 100);
        _vc.view.backgroundColor=[UIColor orangeColor];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        label.textAlignment=NSTextAlignmentCenter;
        label.numberOfLines=0;
        label.backgroundColor=[UIColor yellowColor];
        label.font=[UIFont systemFontOfSize:13];
        [_vc.view addSubview:label];
        
    }
    return _vc ;
}
///懒加载UUDI数组
-(NSArray *)UUIDArr{
    if (_UUIDArr==nil) {
        NSUUID *uid1=[[NSUUID alloc] initWithUUIDString:UUID1];
        NSUUID *uid2=[[NSUUID alloc] initWithUUIDString:UUID2];
        _UUIDArr=@[uid1,uid2];
    }
    return _UUIDArr ;
}
///测试的数据源-保存ibeacon的坐标信息
-(NSArray *)testIbeaconArr
{
    if (_testIbeaconArr==nil) {
        
        beaconModel *model=[[beaconModel alloc] initWithPoint:CGPointMake(34.333313, 305.000000) andMaxNum:0 andMinNum:66];
        
        beaconModel *model2=[[beaconModel alloc] initWithPoint:CGPointMake(375, 535) andMaxNum:0 andMinNum:65];
        
        beaconModel *model3=[[beaconModel alloc] initWithPoint:CGPointMake(34.333313, 305.000000) andMaxNum:0 andMinNum:67];
        
        _testIbeaconArr=@[model,model2,model3];
        
    }
    return _testIbeaconArr ;
}
///工具类
-(Tool *)tool
{
    if (_tool==nil) {
        _tool=[[Tool alloc] init];
    }
    return _tool ;
}
@end
