//
//  MVPhoneFormatter.m
//
//  Created by Cory Imdieke on 3/5/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import "MVPhoneFormatter.h"


@implementation MVPhoneFormatter

+ (NSString *)formattedStringFromUnformattedString:(NSString *)number{
	NSMutableString *rawNumber = [NSMutableString stringWithCapacity:number.length];
	// Remove all Characters except numbers
	NSScanner *scanner = [NSScanner scannerWithString:number];
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
	while ([scanner isAtEnd] == NO) {
		NSString *buffer;
		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
			[rawNumber appendString:buffer];
			
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	
	NSString *areaCode = nil;
	NSString *exchange = nil;
	NSString *circuit = nil;
	
	if([rawNumber length] > 0){
		areaCode = [rawNumber substringWithRange:NSMakeRange(0, MIN([rawNumber length], 3))];
	}
	if([rawNumber length] >= 4){
		exchange = [rawNumber substringWithRange:NSMakeRange(3, MIN([rawNumber length] - 3, 3))];
	}
	if([rawNumber length] >= 7){
		circuit = [rawNumber substringWithRange:NSMakeRange(6, MIN([rawNumber length] - 6, 4))];
	}
	
	NSMutableString *formattedString = [NSMutableString string];
	
	if(areaCode){
		[formattedString appendFormat:@"(%@", areaCode];
	}
	if(exchange){
		[formattedString appendFormat:@") %@", exchange];
	}
	if(circuit){
		[formattedString appendFormat:@"-%@", circuit];
	}
	
	return [NSString stringWithString:formattedString];
}

@end
