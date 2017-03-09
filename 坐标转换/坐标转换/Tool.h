//
//  Tool.h
//  坐标转换
//
//  Created by vina on 16/4/11.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class beaconModel;
@interface Tool : NSObject
///文件路径
@property(nonatomic,copy)NSString *filePath;
///保存ibeacon
-(void)save;
///读取plist-字典
-(NSDictionary *)readPlist;
///三角定位
-(CGPoint)ibeaconLocation:(NSArray<beaconModel*>*)ibeaconPoint;
@end
