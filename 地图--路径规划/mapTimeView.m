//
//  mapTimeView.m
//  meituan
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "mapTimeView.h"
@interface mapTimeView()
@property (weak, nonatomic) IBOutlet UIImageView *busimage;
@property (weak, nonatomic) IBOutlet UIImageView *carimage;
@property (weak, nonatomic) IBOutlet UIImageView *personimage;


@end
@implementation mapTimeView
-(void)awakeFromNib
{
    
    self.busimage.userInteractionEnabled = YES;
    self.carimage.userInteractionEnabled = YES;
    self.personimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *pertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchBtnCil:)];
    UITapGestureRecognizer *cartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchBtnCil:)];

    UITapGestureRecognizer *bustap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(witchBtnCil:)];
    self.busimage.tag=0;
    self.carimage.tag=1;
    self.personimage.tag=2;
    
    [self.busimage addGestureRecognizer:bustap];
    [self.carimage addGestureRecognizer:cartap];
    [self.personimage addGestureRecognizer:pertap];
    
    [AutoLayoutCommon autolayoutWithArray:self.subviews];
}
-(void)witchBtnCil:(UITapGestureRecognizer *)tap
{
    UIImageView *imageview =(UIImageView *) tap.view;
    if ([self.deleget respondsToSelector:@selector(witchImageBtnClic:)]) {
        [self.deleget witchImageBtnClic:imageview.tag];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
