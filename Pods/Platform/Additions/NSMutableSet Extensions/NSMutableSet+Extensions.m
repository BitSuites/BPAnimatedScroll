//
//  NSMutableSet+Extensions.m
//
//  Created by Cory Imdieke on 2/16/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import "NSMutableSet+Extensions.h"


@implementation NSMutableSet (Extensions)

- (void)safeAddObject:(id)object{
	if(object)
		[self addObject:object];
}

@end
