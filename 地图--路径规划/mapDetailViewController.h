//
//  mapDetailViewController.h
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,lineType)
{
    lineTypeCar,
    lineTypeWalk,
    lineTypeBuss

};

@class bussinessModel;
@interface mapDetailViewController : BaseViewController
@property(nonatomic,strong)bussinessModel *model;
@property(nonatomic,assign)lineType linetype;
@property(nonatomic,assign)NSInteger inter;
@end
