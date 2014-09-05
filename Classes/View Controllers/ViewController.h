//
//  ViewController.h
//  BPAnimatedScroll
//
//  Created by Justin Carstens on 9/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPAnimatedScroll.h"

@interface ViewController : UIViewController {
    IBOutlet BPAnimatedScroll *tutorialScroll;
    IBOutlet UIPageControl *welcomePageControl;
}

- (IBAction)pageChanged:(id)sender;

@end
