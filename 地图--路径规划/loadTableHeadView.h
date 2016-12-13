//
//  loadTableHeadView.h
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseView.h"
typedef NS_ENUM(NSInteger ,loadTableViewType)
{
    loadTableViewTypeWalk,
    loadTableViewTypeCar,
    loadTableViewTypeBus

};
@protocol loadTableHeadViewDeleget <NSObject>

-(void)witchbtnclic:(NSInteger)inter;

@end
@interface loadTableHeadView : BaseView
@property(nonatomic,assign)loadTableViewType tableviewType;
@property (weak, nonatomic) IBOutlet UILabel *labe2;
@property(nonatomic,assign)id<loadTableHeadViewDeleget>deleget;

@end
