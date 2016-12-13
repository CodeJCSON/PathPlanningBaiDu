//
//  loadCell.h
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAMapKit.h"

@interface loadCell : BaseTableViewCell
/**
 
 传入的是导航的路段
 */
-(void)gaveme:(AMapPath*)stap;

/**
 传入的是公交的路径
 
 */
-(void)gaveBusMe:(AMapTransit *)transit;
@end
