//
//  MVSingleItemEditor.h
//
//  Created by Cory Imdieke on 2/9/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

// At the moment, this class supports number and string values

#import <UIKit/UIKit.h>
#import "MVFormatter.h"


@protocol MVSingleItemEditorDelegate;

typedef enum{
	MVEditorModeKeyboard,
	MVEditorModeList,
	MVEditorModeDate,
	MVEditorModePhone
} MVEditorMode;

/** Simple `UIViewController` subclass which is designed to easily edit a single key/value on a given object. Uses KVC to access the value, so it will work on any KVC compliant object.
 
 Has a vew modes of operation:
 - `MVEditorModeKeyboard`
 
 Standard keyboard to edit an NSString value.
 
 - `MVEditorModeList`
 
 Picker View with a list of strings provided to choose from. Selected string is set as the value.
 
 - `MVEditorModeDate`
 
 Date Picker View is displayed and a selected NSDate object is set as the value.
 
 - `MVEditorModePhone`
 
 Phone keyboard is used along with the `MVPhoneFormatter` to format the phone number as the user types. Only supports US-style phone formatting.
 
 @note Requires the `MVPhoneFormatter` class to be included in the project as well.
 */
@interface MVSingleItemEditor : UIViewController {
	IBOutlet UITextField *editField;
	IBOutlet UIPickerView *listPicker;
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UILabel *subtitleLabel;
}

/** The object is nil inital value of editor.
 */
@property (nonatomic, strong) id startValue;
/** The object to edit the value of.
 */
@property (nonatomic, strong) id object;
/** The formatter is an external class that responds to the function of the format of a string
 */
@property (nonatomic, strong) id formatter;

/** The key to modify on the object.
 */
@property (nonatomic, strong) NSString *key;

/** The Placeholder text of the text field.
 */
@property (nonatomic, strong) NSString *placeholderText;

/** Some descriptive text to display along with the editing box.
 */
@property (nonatomic, strong) NSString *subtitle;

/** Mode to run in. See the enum values at the top of the documentation.
 */
@property (nonatomic) MVEditorMode mode;

/** Used to customize the keyboard style for `MVEditorModeKeyboard`.
 */
@property (nonatomic) UIKeyboardType keyboardType;

/** Used to customize the keyboard Appearance for `MVEditorModeKeyboard`.
 */
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;

/** List items to present in a Picker View for `MVEditorModeList`.
 */
@property (nonatomic, strong) NSArray *listItems;

/** Second List items to present in a Picker View for `MVEditorModeList`.
 */
@property (nonatomic, strong) NSArray *listItems2;

/** Boolean to enable picking of a date for `MVEditorModeDate`.
 */
@property (nonatomic) BOOL pickDate;

/** Boolean to enable picking of a time for `MVEditorModeDate`.
 */
@property (nonatomic) BOOL pickTime;

/** Boolean to enable a save button in the top right corner.
 
 If `YES`, pressing 'Save' will save the value and dismiss the controller whereas pressing the back button will cancel the change and will not write the data. If `NO`, pressing the back button will write the new value before dismissing.
 */
@property (nonatomic) BOOL showSaveButton;

/** Limits the number of characters that can be entered.
 */
@property (nonatomic) int maxCharacters;

/** Delegate to send back the info of the user selection
 */
@property (nonatomic, weak) id<MVSingleItemEditorDelegate> delegate;

/** Set the background Image of the view.
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/** Set the background color of the editField.
 */
@property (nonatomic, strong) UIColor *editFieldBackgroundColor;

/** Set the background color of the editField.
 */
@property (nonatomic, strong) UIColor *saveButtonTintColor;

- (IBAction)dateUpdated;
- (IBAction)stringUpdated:(UITextField *)sender;

- (void)saveAction;

@end


@protocol MVSingleItemEditorDelegate<NSObject>

@optional
- (void)mvSingleItemEditor:(MVSingleItemEditor *)controller selectedValue:(id)selectedValue;
- (BOOL)mvSingleItemEditor:(MVSingleItemEditor *)controller canSaveText:(NSString *)text;

@end
