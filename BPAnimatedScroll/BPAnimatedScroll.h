//
//  BPAnimatedScroll.h
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAnimatedPage.h"

@protocol BPAnimatedScrollDelegate;

@interface BPAnimatedScroll : UIView

@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, readonly) NSInteger numPages;
@property (nonatomic, readonly) NSMutableArray *pages;
@property (nonatomic, unsafe_unretained) id <BPAnimatedScrollDelegate> delegate;

- (void)setPages:(NSMutableArray *)pages;
- (void)addPage:(BPAnimatedPage *)page;
- (void)addPage:(BPAnimatedPage *)page atIndex:(NSUInteger)index;
- (void)removePage:(BPAnimatedPage *)page;
- (void)removePageAtIndex:(NSUInteger)index;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end

@protocol BPAnimatedScrollDelegate <NSObject>

- (void)bpAnimatedScroll:(UIView *)scroll selectedNewPage:(NSInteger)page numberOfPages:(NSInteger)numPages;

@end
