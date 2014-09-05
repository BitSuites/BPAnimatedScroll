//
//  MVSingleItemEditor.m
//
//  Created by Cory Imdieke on 2/9/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import "MVSingleItemEditor.h"
#import <objc/runtime.h>
#import "MVPhoneFormatter.h"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@interface MVSingleItemEditor () {
    UITextField *hiddenTextField;
    
    NSDateFormatter *dateFormatter;
    BOOL phoneManualEdit;
}

@end

@implementation MVSingleItemEditor
@synthesize startValue, object, key, subtitle, keyboardType, mode, listItems, listItems2, pickDate, pickTime, showSaveButton, maxCharacters, delegate, backgroundImage, keyboardAppearance, editFieldBackgroundColor, placeholderText, saveButtonTintColor;

- (id)init{
	NSString *nibName = @"MVSingleItemEditor";
	
    self = [self initWithNibName:nibName bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MVSingleItemEditorResources" ofType:@"bundle"]]];
    if (self) {
        self.title = @"Edit";
		
		keyboardType = UIKeyboardTypeDefault;
		keyboardAppearance = UIKeyboardAppearanceDefault;
		
		self.listItems = nil;
		maxCharacters = -1;
		
		pickDate = YES;
		pickTime = NO;
		
		showSaveButton = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if(backgroundImage){
		UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}
	
	[subtitleLabel setText:subtitle];
	[editField setKeyboardAppearance:keyboardAppearance];
	
	id value = [object valueForKey:key];
	if(!value)
		value = startValue;
	
	if(placeholderText){
		[editField setPlaceholder:placeholderText];
	}
	
	if([value isKindOfClass:[NSString class]]){
		if(_formatter){
			[editField setText:[_formatter formattedStringFromUnformattedString:value]];
		} else {
			[editField setText:value];
		}
	} else if([value isKindOfClass:[NSNumber class]]){
		[editField setText:[value stringValue]];
		[editField setKeyboardType:UIKeyboardTypeDecimalPad];
	} else if([value isKindOfClass:[NSDate class]]){
		mode = MVEditorModeDate;
		dateFormatter = [[NSDateFormatter alloc] init];
		if(pickDate && pickTime){
			[datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
			[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		} else if(pickDate && !pickTime){
			[datePicker setDatePickerMode:UIDatePickerModeDate];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		} else if(!pickDate && pickTime){
			[datePicker setDatePickerMode:UIDatePickerModeTime];
			[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		}
		[datePicker setDate:value];
		[editField setText:[dateFormatter stringFromDate:[datePicker date]]];
		[editField setInputView:datePicker];
	}
	
	// Override keyboard type
	if(keyboardType != UIKeyboardTypeDefault)
		[editField setKeyboardType:keyboardType];
	
	// Preselect picker item if it appears in the list
	if([listItems2 count] > 0){
		NSArray *values;
		if(_formatter){
			values = [_formatter seperatedStringsFromFromattedString:value];
		} else {
			values = [value componentsSeparatedByString:@" "];
		}
		NSInteger itemIndex = [listItems indexOfObject:[values objectAtIndex:0]];
		NSInteger itemIndex2 = [listItems2 indexOfObject:[values objectAtIndex:1]];
		if(itemIndex != NSNotFound)
			[listPicker selectRow:itemIndex inComponent:0 animated:NO];
		if(itemIndex2 != NSNotFound)
			[listPicker selectRow:itemIndex2 inComponent:1 animated:NO];
	} else {
		NSInteger itemIndex = [listItems indexOfObject:value];
		if(itemIndex != NSNotFound)
			[listPicker selectRow:itemIndex inComponent:0 animated:NO];
	}
	
	// Show save button if necessary
	if(showSaveButton){
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
		self.navigationItem.rightBarButtonItem = saveButton;
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
		self.navigationItem.leftBarButtonItem = cancelButton;
	}
}

- (void)setMode:(MVEditorMode)_mode{
	mode = _mode;
	if (mode == MVEditorModePhone) {
		keyboardType = UIKeyboardTypeNumberPad;
		_formatter = [MVPhoneFormatter class];
	}
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    if (hiddenTextField)
        [hiddenTextField becomeFirstResponder];
    else
        [editField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	if(!showSaveButton){
		[self writeValueBackToObject];
	}
}

#pragma mark Custom Actions

- (void)saveAction{
	if (delegate && [delegate respondsToSelector:@selector(mvSingleItemEditor:canSaveText:)]){
		if ([delegate mvSingleItemEditor:self canSaveText:[editField text]]){
			[self writeValueBackToObject];
			[self.navigationController popViewControllerAnimated:YES];
		}
	} else {
		[self writeValueBackToObject];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)cancelAction{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)writeValueBackToObject{
	NSString *value = [editField text];
	if(delegate){
		if([delegate respondsToSelector:@selector(mvSingleItemEditor:selectedValue:)]){
			[delegate mvSingleItemEditor:self selectedValue:value];
		}
	}
	objc_property_t property = class_getProperty([object class],[key UTF8String]);
	if(property == NULL){
		// Not a property, use straight KVC instead
		[object setValue:value forKey:key];
		return;
	}
	const char * type = property_getAttributes(property);
	NSString * typeString = [NSString stringWithUTF8String:type];
	NSArray * attributes = [typeString componentsSeparatedByString:@","];
	NSString * typeAttribute = [attributes objectAtIndex:0];
	
	if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
		NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
		Class propertyClass = NSClassFromString(typeClassName);
		if (propertyClass != nil) {
			if(propertyClass == [NSString class]){
				[object setValue:value forKey:key];
			} else if(propertyClass == [NSNumber class]){
				[object setValue:[NSNumber numberWithDouble:[value doubleValue]] forKey:key];
			} else if(propertyClass == [NSDate class]){
				[object setValue:[datePicker date] forKey:key];
			}
		}
	}
}

#pragma mark Accessors

- (void)setListItems:(NSArray *)_listItems{
	listItems = _listItems;
	
	if(listItems)
		mode = MVEditorModeList;
	else
		mode = MVEditorModeKeyboard;
	
	// Configure for list
	[self view]; // Force nib load so we can get to the picker
    [hiddenTextField removeFromSuperview];
    hiddenTextField = nil;
    if(mode == MVEditorModeList){
        [editField setUserInteractionEnabled:NO];
        hiddenTextField = [[UITextField alloc] init];
        [hiddenTextField setHidden:YES];
        [hiddenTextField setInputView:listPicker];
        [self.view addSubview:hiddenTextField];
        if ([editField isFirstResponder])
            [hiddenTextField becomeFirstResponder];
    } else {
        [editField setInputView:nil];
        [editField setUserInteractionEnabled:YES];
    }
    [listPicker reloadAllComponents];
}

#pragma mark Date Picker

- (IBAction)dateUpdated{
	[editField setText:[dateFormatter stringFromDate:[datePicker date]]];
}

- (IBAction)stringUpdated:(UITextField *)sender{
	if(maxCharacters != -1){
		if([[sender text] length] > maxCharacters){
			[sender setText:[[sender text] substringToIndex:maxCharacters]];
		}
	}
	if(!phoneManualEdit && _formatter){
		phoneManualEdit = YES;
		[editField setText:[_formatter formattedStringFromUnformattedString:editField.text]];
		phoneManualEdit = NO;
	}
}

#pragma mark Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	if([listItems2 count] > 0)
		return 2;
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if(component == 1)
		return [listItems2 count];
	return [listItems count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if(component == 1)
		return [NSString stringWithFormat:@"%@", [listItems2 objectAtIndex:row]]; // Works for NSNumbers or NSStrings
	return [NSString stringWithFormat:@"%@", [listItems objectAtIndex:row]]; // Works for NSNumbers or NSStrings
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if([listItems2 count] > 0){
		[editField setText:[NSString stringWithFormat:@"%@ %@", [listItems objectAtIndex:[pickerView selectedRowInComponent:0]], [listItems2 objectAtIndex:[pickerView selectedRowInComponent:1]]]];
	} else {
		[editField setText:[NSString stringWithFormat:@"%@", [listItems objectAtIndex:row]]];
	}
	if(!phoneManualEdit && _formatter){
		phoneManualEdit = YES;
		[editField setText:[_formatter formattedStringFromUnformattedString:editField.text]];
		phoneManualEdit = NO;
	}
}

@end
