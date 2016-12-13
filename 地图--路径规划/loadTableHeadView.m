//
//  loadTableHeadView.m
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loadTableHeadView.h"
@interface loadTableHeadView()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *lable1;

@end
@implementation loadTableHeadView
-(void)awakeFromNib
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchbtnClic:)];
    self.image1.userInteractionEnabled = YES;
    [self.image1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchbtnClic:)];
    self.image2.userInteractionEnabled = YES;
    [self.image2 addGestureRecognizer:tap2];

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchbtnClic:)];
    self.image3.userInteractionEnabled = YES;
    [self.image3 addGestureRecognizer:tap3];

    [AutoLayoutCommon autolayoutWithArray:self.subviews];

}
-(void)setimagewitharray:(NSArray *)array
{
    self.image1.image = [UIImage imageNamed:array[0]];
    self.image2.image = [UIImage imageNamed:array[1]];
    self.image3.image = [UIImage imageNamed:array[2]];


}
-(void)setTableviewType:(loadTableViewType)tableviewType
{
    if (tableviewType==loadTableViewTypeWalk) {
        [self setimagewitharray:@[@"bus01.png",@"car01.png",@"man02.png"]];
    }else if (tableviewType==loadTableViewTypeCar)
    {
        [self setimagewitharray:@[@"bus01.png",@"car02.png",@"man01.png"]];
        
    }else if (tableviewType==loadTableViewTypeBus)
    {
        [self setimagewitharray:@[@"bus02.png",@"car01.png",@"man01.png"]];
        
    }


}
-(void)witchbtnClic:(UITapGestureRecognizer *)tap
{
    UIImageView *imageview = (UIImageView *)tap.view;
    
    [self.deleget witchbtnclic:imageview.tag];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
