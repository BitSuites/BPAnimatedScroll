//
//  ViewController.m
//  BPAnimatedScroll
//
//  Created by Justin Carstens on 9/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BPAnimatedScrollDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tutorialScroll setDelegate:self];
    [tutorialScroll setPages:[@[[self iPhonePage1], [self iPhonePage2], [self iPhonePage3]] mutableCopy]];
}

#pragma mark - Custom Actions

- (IBAction)pageChanged:(id)sender {
    [welcomePageControl setCurrentPage:[welcomePageControl currentPage]];
}

- (void)doneAction {
//    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - iPhonePages

- (BPAnimatedPage *)iPhonePage1{
    BPAnimatedPage *page = [[BPAnimatedPage alloc] init];
    
    CGFloat borderSize = 10.0;
    CGFloat bounceAmount = 50.0;
    
    BPAnimatedObject *object1 = [[BPAnimatedObject alloc] init];
    [object1 setAnimatedObject:[self labelWithText:@"Welcome to BPAnimatedScroll\nThis will be the walkthrough\nof how this app works"]];
    [object1 setStartAlpha:1.0];
    [object1 setCenterAlpha:1.0];
    [object1 setEndAlpha:0.0];
    [object1 setStartConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintTopToTopLayout) : @(borderSize), @(BPLayoutConstraintCenterHorizontal) : @(bounceAmount)}];
    [object1 setCenterConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintTopToTopLayout) : @(borderSize), @(BPLayoutConstraintCenterHorizontal) : @(0)}];
    [object1 setEndConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintTopToTopLayout) : @(borderSize), @(BPLayoutConstraintRightToLeading) : @(borderSize)}];
    
    BPAnimatedObject *object2 = [[BPAnimatedObject alloc] init];
    [object2 setAnimatedObject:[self imageViewWithImage:nil]];
    [object2 setStartAlpha:1.0];
    [object2 setCenterAlpha:1.0];
    [object2 setEndAlpha:0.0];
    [object2 setStartConstraints:@{@(BPLayoutConstraintHeight) : @(30), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintBottomToBottomLayout) : @(borderSize), @(BPLayoutConstraintCenterHorizontal) : @(bounceAmount)}];
    [object2 setCenterConstraints:@{@(BPLayoutConstraintHeight) : @(30), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintBottomToBottomLayout) : @(borderSize), @(BPLayoutConstraintCenterHorizontal) : @(0)}];
    [object2 setEndConstraints:@{@(BPLayoutConstraintHeight) : @(30), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintBottomToBottomLayout) : @(borderSize), @(BPLayoutConstraintRightToLeading) : @(borderSize)}];
    
    [page setObjects:[@[object1, object2] mutableCopy]];
    
    return page;
}

- (BPAnimatedPage *)iPhonePage2{
    BPAnimatedPage *page = [[BPAnimatedPage alloc] init];
    
    CGFloat borderSize = 10.0;
    
    BPAnimatedObject *object1 = [[BPAnimatedObject alloc] init];
    [object1 setAnimatedObject:[self labelWithText:@"This is another page showing\nhow the animation goes between pages"]];
    [object1 setStartAlpha:0.0];
    [object1 setCenterAlpha:1.0];
    [object1 setEndAlpha:0.0];
    [object1 setStartConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintLeftToTrailing) : @(borderSize)}];
    [object1 setCenterConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintCenterHorizontal) : @(0)}];
    [object1 setEndConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintRightToLeading) : @(borderSize)}];
    
    [page setObjects:[@[object1] mutableCopy]];
    
    return page;
}

- (BPAnimatedPage *)iPhonePage3{
    BPAnimatedPage *page = [[BPAnimatedPage alloc] init];
    
    CGFloat borderSize = 10.0;
    CGFloat bounceAmount = 50.0;
    
    BPAnimatedObject *object1 = [[BPAnimatedObject alloc] init];
    [object1 setAnimatedObject:[self labelWithText:@"This is the final page\nwith one of the items\nbeing a button a user can click"]];
    [object1 setStartAlpha:0.0];
    [object1 setCenterAlpha:1.0];
    [object1 setEndAlpha:1.0];
    [object1 setStartConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintLeftToTrailing) : @(borderSize)}];
    [object1 setCenterConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintCenterHorizontal) : @(0)}];
    [object1 setEndConstraints:@{@(BPLayoutConstraintHeight) : @(-(borderSize * 2)), @(BPLayoutConstraintWidth) : @(-(borderSize * 2)), @(BPLayoutConstraintCenterVertical) : @(0), @(BPLayoutConstraintCenterHorizontal) : @(-bounceAmount)}];
    
    
    BPAnimatedObject *object2 = [[BPAnimatedObject alloc] init];
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundColor:[UIColor redColor]];
    [object2 setAnimatedObject:doneButton];
    [object2 setStartAlpha:0.0];
    [object2 setCenterAlpha:1.0];
    [object2 setEndAlpha:1.0];
    [object2 setStartConstraints:@{@(BPLayoutConstraintWidth) : @(-(borderSize * 4)), @(BPLayoutConstraintCenterHorizontal) : @(0), @(BPLayoutConstraintTopToBottomLayout) : @(borderSize)}];
    [object2 setCenterConstraints:@{@(BPLayoutConstraintWidth) : @(-(borderSize * 4)), @(BPLayoutConstraintCenterHorizontal) : @(0), @(BPLayoutConstraintBottomToBottomLayout) : @(borderSize)}];
    [object2 setEndConstraints:@{@(BPLayoutConstraintWidth) : @(-(borderSize * 4)), @(BPLayoutConstraintBottomToBottomLayout) : @(borderSize), @(BPLayoutConstraintCenterHorizontal) : @(-bounceAmount)}];
    
    [page setObjects:[@[object1, object2] mutableCopy]];
    
    return page;
}

#pragma mark - Helpers

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setMinimumScaleFactor:0.5];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor whiteColor]];
    return label;
}

- (UIImageView *)imageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor redColor]];
    return imageView;
}

#pragma mark - BPAnimatedScrollDelegate

- (void)bpAnimatedScroll:(UIView *)scroll selectedNewPage:(NSInteger)page numberOfPages:(NSInteger)numPages {
    [welcomePageControl setNumberOfPages:numPages];
    [welcomePageControl setCurrentPage:page];
}

@end
