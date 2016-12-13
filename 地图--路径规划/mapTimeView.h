//
//  mapTimeView.h
//  meituan
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseView.h"
#define mapTimeViewH 44*Kscr

@protocol mapTimeViewDeleget <NSObject>

-(void)witchImageBtnClic:(NSInteger)btnclic;

@end

@interface mapTimeView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *busLable;
@property (weak, nonatomic) IBOutlet UILabel *carlable;
@property (weak, nonatomic) IBOutlet UILabel *personlable;

@property(nonatomic,assign)id<mapTimeViewDeleget>deleget;

@end
