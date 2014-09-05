//
//  MVTextValidator.m
//
//  Created by Cory Imdieke on 6/13/12.
//  Copyright (c) 2012 BitSuites, LLC. All rights reserved.
//

#import "MVTextValidator.h"

@interface MVTextValidator ()

+ (BOOL)validateEmailText:(NSString *)email;
+ (BOOL)validatePhoneText:(NSString *)phone;

@end

@implementation MVTextValidator

#pragma mark Public facing method

+ (BOOL)validateText:(NSString *)text forType:(MVTextValidationType)type{
	switch (type) {
		case MVTextValidationTypeEmail:
			return [self validateEmailText:text];
			break;
			
		case MVTextValidationTypePhone:
			return [self validatePhoneText:text];
			break;
			
		default:
			return NO;
			break;
	}
}

#pragma mark - Private implementation methods

+ (BOOL)validateEmailText:(NSString *)email{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePhoneText:(NSString *)phone{
    NSMutableString *rawNumber = [NSMutableString stringWithCapacity:phone.length];
	// Remove all Characters except numbers
	NSScanner *scanner = [NSScanner scannerWithString:phone];
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
	while ([scanner isAtEnd] == NO) {
		NSString *buffer;
		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
			[rawNumber appendString:buffer];
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	
	// Should just be left with numbers
	return [rawNumber length] >= 10;
}

@end
