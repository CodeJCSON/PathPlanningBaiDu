//
//  loadMapCell.m
//  meituan
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loadMapCell.h"
@interface loadMapCell()
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@end
@implementation loadMapCell
-(void)gavemestr:(NSString *)str
{
    self.lable.text = str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
