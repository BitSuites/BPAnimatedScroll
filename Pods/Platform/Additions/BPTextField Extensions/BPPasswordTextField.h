//
//  BPPasswordTextField.h
//
//  Created by Justin Carstens on 1/30/14.
//  Copyright (c) 2014 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Shows passwords in clear text until user clicks off field
@interface BPPasswordTextField : UITextField

+ (void)setupPasswordDefaultsForTextField:(UITextField *)textField;

@end
