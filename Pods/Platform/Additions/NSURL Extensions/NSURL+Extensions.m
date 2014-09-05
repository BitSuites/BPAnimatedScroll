//
//  NSURL+Extensions.m
//  Platform
//
//  Created by Cory Imdieke on 12/10/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import "NSURL+Extensions.h"

@implementation NSURL (Extensions)

// Is the given request a mailto URL.
- (BOOL)isMailtoRequest{
	return [[self scheme] isEqualToString:@"mailto"];
}

@end
