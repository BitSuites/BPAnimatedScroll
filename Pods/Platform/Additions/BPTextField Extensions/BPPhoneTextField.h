//
//  BPPhoneTextField.h
//
//  Created by Justin Carstens on 7/3/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPPhoneTextField : UITextField

+ (void)setupPhoneDefaultsForTextField:(UITextField *)textField;
+ (NSString *)formattedPhoneNumberFromString:(NSString *)string;
+ (void)phoneNumberChanged:(id)sender;
+ (BOOL)isStringValidPhoneNumber:(NSString *)string;

- (void)setTextFormatted:(NSString *)text;

@end
