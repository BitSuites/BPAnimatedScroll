//
//  UIViewController+Extensions.h
//
//  Created by Cory Imdieke on 9/26/12.
//  Copyright 2012 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extensions)

- (void)viewControllerContainmentAddChildViewController:(UIViewController *)controller toContainerView:(UIView *)containerView;
- (void)viewControllerContainmentRemoveChildViewController:(UIViewController *)controller;

@end
