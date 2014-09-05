//
//  NSArray+Extensions.h
//
//  Created by Cory Imdieke on 12/20/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Additions to `NSArray` for convenience.
@interface NSArray (Additions)

///---------------------------------------------------------------------------------------
/// @name Getting Objects
///---------------------------------------------------------------------------------------

/** Returns an object from the array that has a matching tag value.
 
 Works with objects that have a tag property, silently skips objects in the collection that do not.
 
 @param tag The tag value to look for.
 */
- (id)objectWithTag:(NSUInteger)tag;

/** Returns the object at the specified index or `nil` if that object is out of the array's bounds.
 
 Functionally similar to `NSArray`'s `objectAtIndex:` but doesn't crash if the index is out of bounds.
 
 @param index The index of the object to return.
 */
- (id)objectAtIndexOrNil:(NSInteger)index;

/** Returns the first object in the array, or nil if there are zero objects.
 
 Functionally similar to `NSArray`'s `lastObject:`.
 
 @param index The index of the object to return.
 */
- (id)firstObject;

///---------------------------------------------------------------------------------------
/// @name Random
///---------------------------------------------------------------------------------------

/** Returns a random object in the array.
 */
- (id)randomObject;

///---------------------------------------------------------------------------------------
/// @name Compound Arrays
///---------------------------------------------------------------------------------------

/** Generates a compound array from an array of data and a key to use as the section header key.
 
 Generated is an `NSArray` containing an `NSArray` for each section. The second level `NSArray` contains the objects for that section.
 
 @param rawArray Flat array of values, must be key-value compliant for the provided _sectionKey_.
 @param sectionKey Key to use when grouping the objects into sections.
 */
+ (NSArray *)compoundArrayWithFlatArray:(NSArray *)rawArray sectionKey:(NSString *)sectionKey;

/** Generates a compound array from an array of data and a key to use as the section header key. This one is designed to take an NSDate as the key value to sort by and a formatter to format the section string.
 
 Generated is an `NSArray` containing an `NSArray` for each section. The second level `NSArray` contains the objects for that section.
 
 @param rawArray Flat array of values, must be key-value compliant for the provided _sectionKey_.
 @param sectionKey Key to use when grouping the objects into sections. Value for the key should be an NSDate object.
 @param formatter Formatter to create the section string from the dates
 */
+ (NSArray *)compoundArrayWithFlatArray:(NSArray *)rawArray sectionKey:(NSString *)sectionKey dateFormatter:(NSDateFormatter *)formatter;

/** Returns an object from a compound array at the given index path.
 
 @param path `NSIndexPath` of the requested object.
 @see objectAtSection:atRow:
 */
- (id)objectAtIndexPath:(NSIndexPath *)path;

/** Returns an object from a compound array at the given section and row.
 
 @param section Section of the requested object.
 @param row Row of the requested object.
 @see objectAtIndexPath:
 */
- (id)objectAtSection:(NSUInteger)section atRow:(NSUInteger)row;

/** Returns the number of sections in a compound array.
 */
- (NSUInteger)numberOfSections;

/** Returns the number of rows in a given section in a compound array.
 
 @param section The section to return number of rows of.
 */
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;

/** Returns the section title in a given section, as defined by the sectionKey originally used to create the array.
 
 @param section The section to return the title for.
 */
- (NSString *)titleForSection:(NSUInteger)section;

@end


/// Additions to `NSMutableArray` for convenience.
@interface NSMutableArray (Additions)

/** Generates an empty compound array which is ready to be filled with data for each section.
 
 Generated is an `NSMutableArray` containing a dummy `NSArray` for each section. The second level `NSArray` will contain the objects for that section.
 
 @param numSections Number of sections compound array will have.
 */
+ (NSMutableArray *)compoundArrayWithNumberOfSections:(NSUInteger)numSections;

/** Sets the data for a specific section of a compound array. Creates the section if one doesn't already exist for it.
 
 @param sectionData Array of data to be used for that section's data.
 @param section Section to set the data on.
 */
- (void)setData:(NSArray *)sectionData forSection:(NSUInteger)section;

/** Moves an object from one index to another. Useful for moving rows in the `UITableView` delegate method.
 
 @param from Index of the object to move.
 @param to Index to move the object to.
 */
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

/** Adds an object to the array, does nothing if anObject is `nil`.
 
 Functionally similar to `NSMutableArray`'s `addObject:` but doesn't crash if the object is `nil`.
 
 @param anObject Object to add to the array.
 */
- (void)addObjectOrNil:(id)anObject;

@end
