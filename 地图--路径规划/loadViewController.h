//
//  loadViewController.h
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
@class bussinessModel;
typedef NS_ENUM(NSInteger,loadType)
{
    loadTypeWalk,
    loadTypeCar,
    loadTypeBus
    
};
@interface loadViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray *walkarray;
@property(nonatomic,strong)NSMutableArray *busarray;
@property(nonatomic,strong)NSMutableArray *cararray;
@property(nonatomic,assign)loadType loadtype;
@property(nonatomic,strong)bussinessModel *model;
@end
