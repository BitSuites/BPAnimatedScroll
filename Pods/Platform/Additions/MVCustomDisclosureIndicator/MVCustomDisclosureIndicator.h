//
//  MVCustomDisclosureIndicator.h
//
//  Created by Cory Imdieke on 12/6/11.
//  Copyright (c) 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Duplication of the `UITableViewCell`'s Disclosure Indicator which can be colorized.
///
/// Set as the `accessoryView` on a `UITableViewCell` to match the default layout.
@interface MVCustomDisclosureIndicator : UIControl

/** Default color.
 */
@property (nonatomic, retain) UIColor *accessoryColor;

/** Highlight color.
 
 This will be the color of the chevron when the cell is highlighted.
 */
@property (nonatomic, retain) UIColor *highlightedColor;

/** Returns autoreleased instance of the class.
 
 @param color Color to use as the main color.
 */
+ (id)accessoryWithColor:(UIColor *)color;

@end
