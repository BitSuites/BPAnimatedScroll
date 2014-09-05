//
//  NSString+Extensions.h
//
//  Created by Cory Imdieke on 10/1/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Convenience methods for `NSString`.
@interface NSString (Additions)

///---------------------------------------------------------------------------------------
/// @name Searching
///---------------------------------------------------------------------------------------

/** Search for a substring within the current string.
 
 @param substring String to search for.
 @param caseSen Whether or not the search should be case sensitive.
 @return Returns `YES` if a match was found, `NO` otherwise.
 */
- (BOOL)containsSubstring:(NSString *)substring caseSensitive:(BOOL)caseSen;

///---------------------------------------------------------------------------------------
/// @name GUID String
///---------------------------------------------------------------------------------------

/** Generates a new GUID String.
 */
+ (id)guidString;

///---------------------------------------------------------------------------------------
/// @name Hashing
///---------------------------------------------------------------------------------------

/** Generates an SHA1 hash of the current string.
 
 @return SHA1 Hash
 */
- (NSString *)sha1;

/** Generates an MD5 hash of the current string.
 
 @return MD5 Hash
 */
- (NSString *)md5;

///---------------------------------------------------------------------------------------
/// @name Breaking Apart Strings
///---------------------------------------------------------------------------------------

/** Breaks a string up into an array of individual words.
 
 @return Returns an array of each word in the string.
 */
- (NSArray *)brokenUpStringByWords;

/** Breaks a string up into an array of individual lines.
 
 @return Returns an array of each line in the string.
 */
- (NSArray *)brokenUpStringByLines;

/** Breaks a string up into an array of individual sentences.
 
 @return Returns an array of each sentence in the string.
 */
- (NSArray *)brokenUpStringBySentences;

///---------------------------------------------------------------------------------------
/// @name Removing Whitespace From Stings
///---------------------------------------------------------------------------------------

/** Removes the whitespace from the beginning of the stiring only.
 
 @return string with leading whitespace trimmed off.
 */
- (NSString *)stringByTrimmingLeadingWhitespace;

/** Removes the whitespace from the end of the stiring only.
 
 @return string with trailing whitespace trimmed off.
 */
- (NSString *)stringByTrimmingTrailingWhitespace;

/** Removes the whitespace from the beginning and end of the stiring only.
 
 @return string with leading and trailing whitespace trimmed off.
 */
- (NSString *)stringByTrimmingLeadingAndTrailingWhitespace;

///---------------------------------------------------------------------------------------
/// @name Checking Empty Strings
///---------------------------------------------------------------------------------------

/** Checks to see if there are numbers or letters in the string
 
 @return Returns yes if there are numbers or letters and NO if it is an empty string
 */
- (BOOL)isNotEmptyString;

@end

@interface NSMutableString (Additions)

- (void)appendStringOrNot:(NSString *)aString;
- (void)appendFormatOrNot:(NSString *)format, ...;

@end
