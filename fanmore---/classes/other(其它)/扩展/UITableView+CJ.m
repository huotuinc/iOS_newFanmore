//
//  UITableView+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 2/9/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UITableView+CJ.h"

@implementation UITableView (CJ)

-(void)removeSpaces{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)cleanSelection{
    [self selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)setClearBackground {
    if (ScreenWidth == 375) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg750x1334"]];
    }
    if (ScreenWidth == 414) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg1242x2208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x960"]];
        }else {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x1136"]];
        }
    }
}

- (void)setWiteBackground {
    self.backgroundColor = [UIColor whiteColor];
}

@end
