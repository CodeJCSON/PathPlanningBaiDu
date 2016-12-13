//
//  loadCell.m
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loadCell.h"
@interface loadCell()

@property (weak, nonatomic) IBOutlet UILabel *loadLable;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end
@implementation loadCell

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
    st = @"暂无路径";
    }else
    {
        AMapStep *at = stap.steps[0];

        st= [NSString stringWithFormat:@"途经%@",at.road ];
    }
    self.loadLable.text = st;
    
    self.timelabel.text = [NSString stringWithFormat:@"%@  .  %@",[Unit gavewmemiao:stap.duration],[Unit gavemeMetter:stap.distance]];
    

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
    
    
    NSString *ral =str;
    NSRange range =  [str rangeOfString:@"→" options:NSBackwardsSearch];
    ral =  [str substringToIndex:range.location];

    self.loadLable.text = ral;
    
    
    
    self.timelabel.text  =[NSString stringWithFormat:@"时间%@  .  步行距离%@",[Unit gavewmemiao:transit.duration],[Unit gavemeMetter:transit.walkingDistance]];
}


//- (NSRange)rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange
//{
//
//}
//
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
