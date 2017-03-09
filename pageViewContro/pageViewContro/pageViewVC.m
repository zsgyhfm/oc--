//
//  pageViewVC.m
//  pageViewContro
//
//  Created by 依山观澜 on 16/4/10.
//  Copyright © 2016年 依山观澜. All rights reserved.
//

#import "pageViewVC.h"

@interface pageViewVC ()

@end

@implementation pageViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)init
{
    if (self=[super init])
    {
        self.imgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.imgView];
        self.imgView.backgroundColor=[UIColor orangeColor];
    }
    return self;
}


@end
