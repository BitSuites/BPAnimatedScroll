//
//  NSArray+Extensions.m
//
//  Created by Cory Imdieke on 12/20/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import "NSArray+Extensions.h"


#define kSectionTitleKey @"sectionKeyValue"
#define kSectionObjectsKey @"sectionObjects"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@implementation NSArray (Additions)

- (id)objectWithTag:(NSUInteger)tag{
	for(id obj in self){
		if([obj respondsToSelector:@selector(tag)]){
			if((int)[obj tag] == tag)
				return obj;
		}
	}

	// Not found
	return nil;
}

- (id)objectAtIndexOrNil:(NSInteger)index{
	if(index < 0 || index >= [self count])
		return nil;
	else
		return [self objectAtIndex:index];
}

- (id)firstObject{
	return [self objectAtIndexOrNil:0];
}

- (id)randomObject{
	NSUInteger randomIndex = arc4random() % [self count];
	return [self objectAtIndex:randomIndex];
}

#pragma mark Compound Arrays

+ (NSArray *)compoundArrayWithFlatArray:(NSArray *)rawArray sectionKey:(NSString *)sectionKey{
	return [self compoundArrayWithFlatArray:rawArray sectionKey:sectionKey dateFormatter:nil];
}

+ (NSArray *)compoundArrayWithFlatArray:(NSArray *)rawArray sectionKey:(NSString *)sectionKey dateFormatter:(NSDateFormatter *)formatter{
	// Keys array helps us keep track of what keys we already have, the compound array is the actual array we're building
	NSMutableArray *uniqueSectionKeys = [NSMutableArray array];
	NSMutableArray *compoundArray = [NSMutableArray array];
	
	for(id eachObject in rawArray){
		id keyValue = [eachObject valueForKey:sectionKey];
		if(keyValue && [keyValue isKindOfClass:[NSDate class]] && formatter){
			// Convert date to string using formatter
			keyValue = [formatter stringFromDate:keyValue];
		}
		
		if(keyValue && ![uniqueSectionKeys containsObject:keyValue]){
			// New section, add it to the unique keys and create a section for it
			[uniqueSectionKeys addObject:keyValue];
			NSMutableDictionary *sectionDict = [NSMutableDictionary dictionary];
			[sectionDict setObject:keyValue forKey:kSectionTitleKey];
			[sectionDict setObject:[NSMutableArray array] forKey:kSectionObjectsKey];
			[compoundArray addObject:sectionDict];
		}
		
		// Grab the section and add the object to it
		if (keyValue) {
			NSUInteger sectionIndex = [uniqueSectionKeys indexOfObject:keyValue];
			[[[compoundArray objectAtIndex:sectionIndex] objectForKey:kSectionObjectsKey] addObject:eachObject];
		}
	}
	
	return [NSArray arrayWithArray:compoundArray];
}

- (id)objectAtIndexPath:(NSIndexPath *)path{
	return [self objectAtSection:path.section atRow:path.row];
}

- (id)objectAtSection:(NSUInteger)section atRow:(NSUInteger)row{
	id childArray = [self objectAtIndexOrNil:section];
	if([childArray isKindOfClass:[NSArray class]]){
		// Simple compound array
		return [(NSArray *)childArray objectAtIndexOrNil:row];
	} else if([childArray isKindOfClass:[NSDictionary class]]){
		// Complex compount array (with metadata)
		return [[(NSDictionary *)childArray objectForKey:kSectionObjectsKey] objectAtIndexOrNil:row];
	} else {
		return nil;
	}
}

- (NSUInteger)numberOfSections{
	return [self count];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section{
	id childArray = [self objectAtIndexOrNil:section];
	if([childArray isKindOfClass:[NSArray class]]){
		// Simple compound array
		return [(NSArray *)childArray count];
	} else if([childArray isKindOfClass:[NSDictionary class]]){
		// Complex compount array (with metadata)
		return [[(NSDictionary *)childArray objectForKey:kSectionObjectsKey] count];
	} else {
		return 0;
	}
}

- (NSString *)titleForSection:(NSUInteger)section{
	id childArray = [self objectAtIndexOrNil:section];
	if([childArray isKindOfClass:[NSArray class]]){
		// Simple compound array, we don't have a title
		return nil;
	} else if([childArray isKindOfClass:[NSDictionary class]]){
		// Complex compount array (with metadata)
		return [(NSDictionary *)childArray objectForKey:kSectionTitleKey];
	} else {
		return nil;
	}
}

@end


@implementation NSMutableArray (Additions)

+ (NSMutableArray *)compoundArrayWithNumberOfSections:(NSUInteger)numSections{
	// Create empty arrays
	NSMutableArray *compoundArray = [NSMutableArray arrayWithCapacity:numSections];
	
	for (int i = 0; i < numSections; i++) {
		[compoundArray addObject:[NSArray array]];
	}
	
	return compoundArray;
}

- (void)setData:(NSArray *)sectionData forSection:(NSUInteger)section{
	NSArray *existingData = [self objectAtIndexOrNil:section];
	if(existingData){
		// Overwrite
		[self replaceObjectAtIndex:section withObject:sectionData];
	} else {
		// New
		[self addObject:sectionData];
	}
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
	if(to != from){
		id obj = [self objectAtIndex:from];
		[self removeObjectAtIndex:from];
		if(to >= [self count]){
			[self addObject:obj];
		} else {
			[self insertObject:obj atIndex:to];
		}
	}
}

- (void)addObjectOrNil:(id)anObject{
	if(anObject)
		[self addObject:anObject];
}

@end
