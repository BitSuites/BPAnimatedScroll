//
//  BPEmailTextField.m
//
//  Created by Justin Carstens on 6/12/13.
//  Copyright (c) 2013 Bitsuites, LLC. All rights reserved.
//

#import "BPEmailTextField.h"
#import "Platform.h"

@implementation BPEmailTextField

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
    [BPEmailTextField setupEmailDefaultsForTextField:self];
}

- (BOOL)isValidEmailAddress{
	return [BPEmailTextField isStringValidEmailAddress:[self text]];
}

+ (void)setupEmailDefaultsForTextField:(UITextField *)textField{
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[textField setKeyboardType:UIKeyboardTypeEmailAddress];
}

+ (BOOL)isStringValidEmailAddress:(NSString *)string{
    return [MVTextValidator validateText:string forType:MVTextValidationTypeEmail];
}

@end
