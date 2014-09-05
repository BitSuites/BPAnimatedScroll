//
//  BPPasswordTextField.m
//
//  Created by Justin Carstens on 1/30/14.
//  Copyright (c) 2014 BitSuites, LLC. All rights reserved.
//

#import "BPPasswordTextField.h"

@implementation BPPasswordTextField

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
	[BPPasswordTextField setupPasswordDefaultsForTextField:self];
}

+ (void)setupPasswordDefaultsForTextField:(UITextField *)textField{
    [textField setSecureTextEntry:YES];
    [textField addTarget:self action:@selector(passwordBeganEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(passwordEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [textField addTarget:self action:@selector(passwordEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(passwordTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

+ (void)passwordBeganEditing:(UITextField *)textField{
    if ([[textField text] length] <= 0){
        [textField setSecureTextEntry:NO];
    }
}

+ (void)passwordTextChanged:(UITextField *)textField{
    [textField setSecureTextEntry:NO];
}

+ (void)passwordEndEditing:(UITextField *)textField{
    [textField setSecureTextEntry:YES];
}

@end
