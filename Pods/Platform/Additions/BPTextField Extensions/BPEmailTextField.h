//
//  BPEmailTextField.h
//
//  Created by Justin Carstens on 6/12/13.
//  Copyright (c) 2013 Bitsuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPEmailTextField : UITextField

+ (void)setupEmailDefaultsForTextField:(UITextField *)textField;
+ (BOOL)isStringValidEmailAddress:(NSString *)string;

- (BOOL)isValidEmailAddress;

@end
