//
//  MVTextValidator.h
//
//  Created by Cory Imdieke on 6/13/12.
//  Copyright (c) 2012 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	MVTextValidationTypeEmail,
	MVTextValidationTypePhone
} MVTextValidationType;

/** Class which validates a string given a specific type.
 
 - `MVTextValidationTypeEmail`
 
   Ensures the string follows a standard email pattern.
 
 - `MVTextValidationTypePhone`
 
   Ensures the string follows a standard phone pattern.
 
 @warning The `MVTextValidationTypePhone` type is only compatible with US formatted phone strings.
 */
@interface MVTextValidator : NSObject

/** Validates the given text and returns a Boolean representing its validity.
 
 @param text The string to validate.
 @param type The validation type to use.
 @return Returns `YES` if the text is valid for the given type, `NO` otherwise.
 */
+ (BOOL)validateText:(NSString *)text forType:(MVTextValidationType)type;

@end
