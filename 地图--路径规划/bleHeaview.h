//
//  tableHeaview.h
//  meituan
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAMapKit.h"

#define bleHeaviewH 95*Kscr
@class bleHeaview;
@protocol bleHeaviewDeleget <NSObject>

-(void)uptableviewwithtime:(bleHeaview*)blview;;

@end
@interface bleHeaview : BaseView

-(void)upimage;
-(void)downimage;

@property(nonatomic,assign)BOOL ischange;
@property(nonatomic,assign)id<bleHeaviewDeleget>deleget;
/**
 
 传入的是导航的路段
 */
-(void)gaveme:(AMapPath*)stap;

/**
 传入的是公交的路径
 
 */
-(void)gaveBusMe:(AMapTransit *)transit;

@end
