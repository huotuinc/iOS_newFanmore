//
//  UIView+MP.m
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UIView+MP.h"

@implementation UIView (MP)

-(void)makeMaxWidth{
    [self constraintFor:NSLayoutAttributeWidth].constant = CGRectGetWidth([UIScreen mainScreen].bounds);
}

-(void)backgroundAsMainColor{
    self.backgroundColor = fmMainColor;
}

-(void)shake:(CGFloat)range duration:(CFTimeInterval)duration count:(float)count{
    CALayer *lbl = [self layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-range, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+range, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:duration];
    [animation setRepeatCount:count];
    [lbl addAnimation:animation forKey:nil];
}

-(void)shake{
    [self shake:10.0 duration:0.1 count:3];
}


-(MBProgressHUD*)alertMessage:(NSString*)msg{
    return [self alertMessage:msg block:Nil];
}

-(MBProgressHUD*)alertMessage:(NSString*)msg block:(void (^)())block{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    //    HUD.labelText = msg;
    HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeText;
    HUD.mode = MBProgressHUDModeCustomView;
    //boundingRectWithSize:options:attributes:context:
//    CGSize size = [msg boundingRectWithSize:CGSizeMake(256, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{} context:nil].size;
    //NSFontAttributeName
//    CGSize size = [msg sizeWithFont:HUD.labelFont constrainedToSize:CGSizeMake(256, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //    NSLog(@"%f %f",size.width,size.height);
    UILabel* label = [[UILabel alloc]init];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor = [UIColor whiteColor];
    label.font = HUD.labelFont;
    //	label.text = HUD.labelText;
    label.text = msg;
    
    CGSize size = [label sizeThatFits:CGSizeMake(256, MAXFLOAT)];
    [label setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    HUD.customView = label;
    
    __weak UIScrollView* scrollable = nil;
    BOOL scrollEnable = YES;
    if ([self isKindOfClass:[UIScrollView class]]) {
        scrollable = (UIScrollView*)self;
        scrollEnable = [scrollable isScrollEnabled];
        [scrollable setScrollEnabled:NO];
    }
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        if ($safe(scrollable)) {
            [scrollable setScrollEnabled:scrollEnable];
        }
        [HUD removeFromSuperview];
        if (block) {
            block();
        }
    }];
    return HUD;
}

-(CGRect)underView:(UIView*)view{
    CGFloat y = view.frame.origin.y;
    CGFloat height = view.frame.size.height;
    
    CGFloat ny = y+height-self.frame.origin.y;
    return CGRectMake(0, ny, self.frame.size.width, self.frame.size.height-ny);
}

-(NSLayoutConstraint*)constraintFor:(id)item attribute:(NSLayoutAttribute)attribute{
    for (NSLayoutConstraint* nc in self.constraints) {
        if (nc.firstItem==item && nc.firstAttribute==attribute) {
            return nc;
        }
        if (nc.secondItem==item && nc.secondAttribute==attribute) {
            return nc;
        }
    }
    return nil;
}

-(NSLayoutConstraint*)constraintFor:(NSLayoutAttribute)attribute{
    for (NSLayoutConstraint* nc in self.constraints) {
        if (nc.firstAttribute==attribute) {
            return nc;
        }
        if (nc.secondAttribute==attribute) {
            return nc;
        }
    }
    return nil;
}

-(void)stopMask{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(void)beMask:(void(^)())block{
    __weak UIView* wself = self;
    self.userInteractionEnabled = YES;
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithHexString:@"000" alpha:0.7];
    [self bk_whenTapped:^{
        if (wself && block==NULL) {
            [wself stopMask];
        }
        if (block) {
            block();
        }
    }];
    [self.superview bringSubviewToFront:self];
}

@end
