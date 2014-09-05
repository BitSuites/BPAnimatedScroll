//
//  MVBarTender.h
//
//  Created by Cory Imdieke on 10/10/12.
//  Copyright (c) 2012 Bitsuites, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVBarTender : NSObject

+ (void)customizeNavBarWithDefaults:(UINavigationBar *)navBar;
+ (void)customizeNavBar:(UINavigationBar *)navBar withTintColor:(UIColor *)tintColor;

+ (void)customizeToolBarWithDefaults:(UIToolbar *)toolBar;
+ (void)customizeToolBar:(UIToolbar *)toolBar withTintColor:(UIColor *)tintColor;

+ (void)customizeTabBarWithDefaults:(UITabBar *)tabBar forNumberOfTabs:(NSUInteger)numTabs;
+ (void)customizeTabBar:(UITabBar *)tabBar withTintColor:(UIColor *)tintColor forNumberOfTabs:(NSUInteger)numTabs;

@end
