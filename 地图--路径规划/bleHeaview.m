//
//  tableHeaview.m
//  meituan
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "bleHeaview.h"
@interface bleHeaview()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;


@end
@implementation bleHeaview
-(void)awakeFromNib
{
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uptableview)];
    self.image.userInteractionEnabled = YES;
    [self.image addGestureRecognizer:tap];
    
}
-(void)upimage
{
//    self.image.transform = CGAffineTransformRotate(self.image.transform, M_PI);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.image.transform = CGAffineTransformMakeRotation(M_PI);

    }];
}
-(void)downimage
{
//    self.image.transform = CGAffineTransformRotate(self.image.transform, -M_PI);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.image.transform = CGAffineTransformMakeRotation(0);

    }];

}

-(void)uptableview
{
    if ([self.deleget respondsToSelector:@selector(uptableviewwithtime:)]) {
        [self.deleget uptableviewwithtime:self];
    }
}

-(void)gaveme:(AMapPath*)stap
{
    NSString *st ;
    
    if (stap.steps.count>=2) {
        
        AMapStep *at = stap.steps[0];
        AMapStep *bt;
        for (AMapStep*ct in stap.steps) {
            if (![ct.road isEqualToString:at.road]) {
                bt = ct;
                break;
            }
        }
        
        //        AMapStep *bt = stap.steps[1];
        
        NSString *str1;
        NSString *str2;
        
        if (at.road) {
            str1 = at.road;
        }else
        {
            str1 = @"无名路";
        }
        
        if (bt.road) {
            str2 = bt.road;
        }else
        {
            str2 = @"无名路";
        }
        
        st= [NSString stringWithFormat:@"途经%@,%@",at.road,bt.road ];
    }else if (stap.steps.count==0)
    {
        st = @"路径规划中";
    }else
    {
        AMapStep *at = stap.steps[0];
        
        st= [NSString stringWithFormat:@"途经%@",at.road ];
    }
    self.lable1.text = st;
    
    if (stap.duration>0&&stap.distance>0  ) {
            self.lable2.text = [NSString stringWithFormat:@"%@  .  %@",[Unit gavewmemiao:stap.duration],[Unit gavemeMetter:stap.distance]];
    }

    
    
}
-(void)gaveBusMe:(AMapTransit *)transit
{
    //    NSLog(@"→");
    
    NSMutableString *str = [NSMutableString string];
    
    
    for (AMapSegment *seg in transit.segments) {
        
        for (AMapBusLine *busline in seg.buslines) {
            NSString *ss = busline.name;
            NSRange range =  [ss rangeOfString:@"(" options:NSBackwardsSearch];
            ss =  [ss substringToIndex:range.location];
            [str appendFormat:@"%@→",ss ];
        }
        
    }
    if (str.length>0) {
        NSString *ral =str;
        NSRange range =  [str rangeOfString:@"→" options:NSBackwardsSearch];
        ral =  [str substringToIndex:range.location];
        self.lable1.text = ral;


    }else
    {
        return;
    }
    
    
    
    
    
    self.lable2.text  =[NSString stringWithFormat:@"时间%@  .  步行距离%@",[Unit gavewmemiao:transit.duration],[Unit gavemeMetter:transit.walkingDistance]];
}
-(void)setIschange:(BOOL)ischange
{
    if (ischange) {
        self.image.transform=CGAffineTransformMakeRotation(M_PI);
    }else
    {
        self.image.transform=CGAffineTransformMakeRotation(0);

    }

}
-(void)didMoveToSuperview
{


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
