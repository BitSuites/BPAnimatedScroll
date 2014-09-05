//
//  NSMutableSet+Extensions.h
//
//  Created by Cory Imdieke on 2/16/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableSet (Extensions)

// Doesn't crash if passed a nil object
- (void)safeAddObject:(id)object;

@end
