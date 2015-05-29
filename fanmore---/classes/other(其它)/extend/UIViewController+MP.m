//
//  UIViewController+MP.m
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UIViewController+MP.h"
#import <objc/runtime.h>

@implementation UIViewController (MP)

NSString const *FMVCFMNSNBO = @"FMVCFMNSNBO";

-(void)showNavigationBar{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)hideNavigationBar{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showNoshadowNavigationBar{
    objc_setAssociatedObject(self, &FMVCFMNSNBO, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavigationBarHidden:NO];
    //    if (!self.tempImage) {
    //        self.tempImage = self.navigationController.navigationBar.shadowImage;
    //    }
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:fmMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)greetingBack{
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    
    __weak UIViewController* wself = self;
    [self.view addGestureRecognizer:[UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)sender;
        if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
            [wself doBack];
        }
    }]];
}

-(void)invokeAfterViewLoaded:(void (^)(id obj))block{
    if ([self isViewLoaded]) {
        block(self);
    }else{
        [self bk_performBlock:^(id obj) {
            [obj invokeAfterViewLoaded:block];
        } afterDelay:0.2];
    }
}

-(UIViewController*)navigationTo:(NSString*)idid{
    
    if ($eql(self.restorationIdentifier,idid)) {
        return self;
    }
    
    UINavigationController* theNavC = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]]) {
        theNavC = (UINavigationController*)self;
    }
    
    UIViewController* targetVC = nil;
    for (UIViewController* vc in theNavC.viewControllers) {
        if ($eql(vc.restorationIdentifier,idid)) {
            targetVC = vc;
            break;
        }
    }
    
    if (targetVC) {
        [theNavC popToViewController:targetVC animated:YES];
    }else{
        targetVC = [self.storyboard instantiateViewControllerWithIdentifier:idid];
        [theNavC pushViewController:targetVC animated:YES];
    }
    
    return targetVC;
}

-(BOOL)isNavigationBy:(NSString*)idid{
    UINavigationController* uic;
    if ([self isKindOfClass:[UINavigationController class]]) {
        uic = (UINavigationController*)self;
    }else{
        uic = self.navigationController;
    }
    
    NSUInteger count = uic.viewControllers.count;
    UIViewController* p = uic.viewControllers[count-2];
    return $eql(p.restorationIdentifier,idid);
}


@end
