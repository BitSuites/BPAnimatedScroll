//
//  NSString+Extensions.m
//
//  Created by Cory Imdieke on 10/1/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extensions.h"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@implementation NSString (Additions)

#pragma mark Searching

- (BOOL)containsSubstring:(NSString *)substring caseSensitive:(BOOL)caseSen{
	if([self length] == 0 || [substring length] == 0)
		return NO;
	NSRange textRange;
	if(caseSen)
		textRange = [self rangeOfString:substring];
	else
		textRange = [[self uppercaseString] rangeOfString:[substring uppercaseString]];
	return (textRange.location != NSNotFound);
}

#pragma mark GUID

+ (id)guidString{
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString *retString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
	CFRelease(uuid);
	
	return retString;
}

#pragma mark Hashing

- (NSString *)sha1{
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

- (NSString *)md5{
	const char *cStr = [self UTF8String];
	unsigned char digest[16];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return  output;
}

#pragma mark - Breaking up strings

- (NSArray *)brokenUpStringByWords{
	NSMutableArray *words = [NSMutableArray array];
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[words addObject:substring];
	}];
	
	return [NSArray arrayWithArray:words];
}

- (NSArray *)brokenUpStringByLines{
	NSMutableArray *lines = [NSMutableArray array];
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[lines addObject:substring];
	}];
	
	return [NSArray arrayWithArray:lines];
}

- (NSArray *)brokenUpStringBySentences{
	NSMutableArray *sentences = [NSMutableArray array];
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationBySentences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[sentences addObject:substring];
	}];
	
	return [NSArray arrayWithArray:sentences];
}

#pragma mark - Removing Whitespace From Stings

- (NSString *)stringByTrimmingLeadingWhitespace{
    NSInteger i = 0;
    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

- (NSString *)stringByTrimmingTrailingWhitespace{
    NSInteger i = [self length] - 1;
    while ((i >= 0)
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i--;
    }
    return [self substringToIndex:i+1];
}

- (NSString *)stringByTrimmingLeadingAndTrailingWhitespace{
    return [[self stringByTrimmingLeadingWhitespace] stringByTrimmingTrailingWhitespace];
}

#pragma mark - Check for empty string

- (BOOL)isNotEmptyString{
	return ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

@end

#pragma mark -

@implementation NSMutableString (Additions)

#pragma mark Appending Strings

- (void)appendStringOrNot:(NSString *)aString{
	if(aString && ![aString isKindOfClass:[NSNull class]]){
		[self appendString:aString];
	}
}

- (void)appendFormatOrNot:(NSString *)format, ...{
	va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
	
	// Check the formatted string for null
	if(![formattedString containsSubstring:@"null" caseSensitive:NO]){
		// No null, we're in good shape
		[self appendString:formattedString];
	}
}

@end
