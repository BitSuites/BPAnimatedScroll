//
//  NSURL+Extensions.h
//  Platform
//
//  Created by Cory Imdieke on 12/10/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extensions)

// Is the given request a mailto URL.
- (BOOL)isMailtoRequest;

@end
