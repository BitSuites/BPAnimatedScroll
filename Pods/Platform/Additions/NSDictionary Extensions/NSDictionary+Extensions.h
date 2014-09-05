//
//  NSDictionary+Extensions.h
//
//  Created by Cory Imdieke on 8/20/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLHelperExtensions)

- (NSString *)stringByEscapingForURLQuery;
- (NSString *)stringByUnescapingFromURLQuery;

@end

/// Convenience methods on `NSDictionary`.
@interface NSDictionary (Extensions)

/** Generates an `NSDictionary` object given a URL Form Encoded String.
 
 @param encodedString URL Form Encoded String.
 */
+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString;

/** Generates a URL Form Encoded string with the contents of a dictionary.
 */
- (NSString *)stringWithFormEncodedComponents;

@end
