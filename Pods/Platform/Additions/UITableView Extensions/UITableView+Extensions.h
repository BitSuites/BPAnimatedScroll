//
//  UITableView+Extensions.h
//
//  Created by Cory Imdieke on 12/9/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableView (Utilities)

- (void)reloadDataAnimated:(BOOL)animated;

- (void)reloadDataWithRowAnimation:(UITableViewRowAnimation)animation;

- (void)scrollToTop:(BOOL)animated;

- (void)scrollToBottom:(BOOL)animated;

- (void)scrollToFirstRow:(BOOL)animated;

- (void)scrollToLastRow:(BOOL)animated;

- (void)scrollFirstResponderIntoView;

- (void)touchRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated;

@end
