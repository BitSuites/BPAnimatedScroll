//
//  BPPhoneTextField.m
//
//  Created by Justin Carstens on 7/3/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import "BPPhoneTextField.h"
#import "MVPhoneFormatter.h"
#import "Platform.h"

@implementation BPPhoneTextField

- (id)init{
	self = [super init];
    if (self) {
		[self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
    if (self) {
		[self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupDefaults];
    }
    return self;
}

- (void)setupDefaults{
	[BPPhoneTextField setupPhoneDefaultsForTextField:self];
}

- (void)setTextFormatted:(NSString *)text{
    [self setText:[BPPhoneTextField formattedPhoneNumberFromString:text]];
}

+ (void)setupPhoneDefaultsForTextField:(UITextField *)textField{
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
	if (MVPad)
		[textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	else
		[textField setKeyboardType:UIKeyboardTypeNumberPad];
	[textField addTarget:self action:@selector(phoneNumberChanged:) forControlEvents:UIControlEventEditingChanged];
}

+ (NSString *)formattedPhoneNumberFromString:(NSString *)string{
    return [MVPhoneFormatter formattedStringFromUnformattedString:string];
}

+ (void)phoneNumberChanged:(UITextField *)sender{
    [sender setText:[BPPhoneTextField formattedPhoneNumberFromString:sender.text]];
}

+ (BOOL)isStringValidPhoneNumber:(NSString *)string{
    return [MVTextValidator validateText:string forType:MVTextValidationTypePhone];
}

@end
