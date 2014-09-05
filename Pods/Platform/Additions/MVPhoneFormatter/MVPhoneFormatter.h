//
//  MVPhoneFormatter.h
//
//  Created by Cory Imdieke on 3/5/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVFormatter.h"

/// Formats a string of numbers to the US-based phone number style.
/// @warning This does not work with phone number formats of other countries.
@interface MVPhoneFormatter : NSObject<MVFormatter>

@end
