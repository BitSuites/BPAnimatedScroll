//
//  BPAnimatedScroll.m
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import "BPAnimatedScroll.h"
#import "BPAnimatedPage.h"
#import "Platform.h"

@interface BPAnimatedScroll ()<UIScrollViewDelegate>{
    UIScrollView *animatedScrollView;
}

@end

@implementation BPAnimatedScroll
@synthesize pages, numPages, currentPage, delegate;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setup{
    currentPage = 0;
    animatedScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [animatedScrollView setDelegate:self];
    [animatedScrollView setBackgroundColor:[UIColor clearColor]];
    [animatedScrollView setPagingEnabled:YES];
    [animatedScrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:animatedScrollView];
    [self scrollViewDidScroll:animatedScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged)  name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)updateConstraints{
    [super updateConstraints];
    if ([[self subviews] containsObject:animatedScrollView]){
        [animatedScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[animatedScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(animatedScrollView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[animatedScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(animatedScrollView)]];
        [NSObject performOnMainThreadWithBlock:^{
            [self updatePages];
        }];
    }
}

- (void)orientationChanged{
    // Give fraction of sec for value to change
    [self performSelector:@selector(updatePages) withObject:nil afterDelay:0.1];
}

- (void)setPages:(NSMutableArray *)newPages{
    pages = newPages;
    [self updatePages];
}

- (void)addPage:(BPAnimatedPage *)page{
    [self addPage:page atIndex:[pages count]];
}

- (void)addPage:(BPAnimatedPage *)page atIndex:(NSUInteger)index{
    if (!pages)
        pages = [[NSMutableArray alloc] init];
    [pages insertObject:page atIndex:index];
    [self updatePages];
}

- (void)removePage:(BPAnimatedPage *)page{
    if (!pages || !page)
        return;
    [page removeFromSuperview];
    [pages removeObject:page];
    [self updatePages];
}

- (void)removePageAtIndex:(NSUInteger)index{
    [self removePage:[pages objectAtIndexOrNil:index]];
}

- (void)updatePages{
    numPages = [pages count];
    [animatedScrollView setContentSize:CGSizeMake(self.width * [pages count], self.height)];
    for (BPAnimatedPage *nextPage in pages){
        [nextPage addToSuperview:self];
    }
    [self sendSubviewToBack:animatedScrollView];
    [self scrollViewDidScroll:animatedScrollView];
    [self scrollToPage:currentPage animated:NO];
    [self sendUpdatedPages];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated{
    currentPage = page;
    [animatedScrollView scrollRectToVisible:CGRectMake(self.width * page, 0, self.width, self.height) animated:animated];
    for (BPAnimatedPage *nextPage in pages){
        [nextPage animateToPercent:0.0 leftSide:YES];
    }
    [self scrollViewDidScroll:animatedScrollView];
}

- (void)sendUpdatedPages{
    if (delegate){
        [delegate bpAnimatedScroll:self selectedNewPage:currentPage numberOfPages:numPages];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger leftmostPage = floor(scrollView.contentOffset.x / scrollView.width);
    NSInteger rightSidePage = leftmostPage + 1;
    NSInteger previousPage = leftmostPage - 1;
    float percentRightShowing = (scrollView.contentOffset.x / scrollView.width) - leftmostPage;
    float percentLeftShowing = 1.0 - percentRightShowing;
    [self animatePage:leftmostPage toPercent:percentLeftShowing leftSide:YES];
    [self animatePage:rightSidePage toPercent:percentRightShowing leftSide:NO];
    // This makes sure the page isn't showing anything on the screen
    [self animatePage:previousPage toPercent:0.0 leftSide:YES];
    
    NSInteger checkPage = roundf(scrollView.contentOffset.x / scrollView.width);
    if (checkPage != currentPage){
        currentPage = checkPage;
        [self sendUpdatedPages];
    }
}

- (void)animatePage:(NSInteger)page toPercent:(CGFloat)percent leftSide:(BOOL)leftSide{
    BPAnimatedPage *pageToAnimate = [pages objectAtIndexOrNil:page];
    if (!pageToAnimate)
        return;
    [pageToAnimate animateToPercent:percent leftSide:leftSide];
}

@end
