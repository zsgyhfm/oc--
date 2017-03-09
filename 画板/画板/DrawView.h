//
//  DrawView.h
//  画板
//
//  Created by vina on 16/4/7.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

///颜色
@property(nonatomic,strong)UIColor *color;
///存放线条颜色
@property(nonatomic,strong)NSMutableArray *lineColors;

-(void)save;
@end
