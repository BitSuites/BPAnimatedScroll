//
//  UIViewController+Extensions.m
//
//  Created by Cory Imdieke on 9/26/12.
//  Copyright 2012 BitSuites, LLC. All rights reserved.
//

#import "UIViewController+Extensions.h"

@implementation UIViewController (Extensions)

- (void)viewControllerContainmentAddChildViewController:(UIViewController *)controller toContainerView:(UIView *)containerView{
	[self addChildViewController:controller];
	[controller.view setFrame:CGRectMake(0.0, 0.0, containerView.frame.size.width, containerView.frame.size.height)];
	[containerView addSubview:controller.view];
	[controller didMoveToParentViewController:self];
}

- (void)viewControllerContainmentRemoveChildViewController:(UIViewController *)controller{
	[controller willMoveToParentViewController:nil];
	[controller.view removeFromSuperview];
	[controller removeFromParentViewController];
}

@end
