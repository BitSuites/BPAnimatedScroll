//
//  NSFileManager+Extensions.h
//
//  Created by Cory Imdieke on 5/16/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Provides extensions to `NSFileManager` for convenience.
@interface NSFileManager (Extensions)

///---------------------------------------------------------------------------------------
/// @name Documents Directory
///---------------------------------------------------------------------------------------

/** Returns the application's Documents directory as a path string.
 
 @return Returns full path string of Documents directory.
 */
+ (NSString *)applicationDocumentsDirectoryPath;

/** Returns the application's Documents directory as a file URL.
 
 @return Returns full file URL of Documents directory.
 */
+ (NSURL *)applicationDocumentsDirectoryPathURL;

///---------------------------------------------------------------------------------------
/// @name Library Directory
///---------------------------------------------------------------------------------------

/** Returns the application's Library directory as a path string.
 
 @return Returns full path string of Library directory.
 */
+ (NSString *)applicationLibraryDirectoryPath;

/** Returns the application's Library directory as a file URL.
 
 @return Returns full file URL of Library directory.
 */
+ (NSURL *)applicationLibraryDirectoryPathURL;

///---------------------------------------------------------------------------------------
/// @name Caches Directory
///---------------------------------------------------------------------------------------

/** Returns the application's Caches directory as a path string.
 
 @return Returns full path string of Caches directory.
 */
+ (NSString *)applicationCachesDirectoryPath;

/** Returns the application's Caches directory as a file URL.
 
 @return Returns full file URL of Caches directory.
 */
+ (NSURL *)applicationCachesDirectoryPathURL;

///---------------------------------------------------------------------------------------
/// @name Application Support Directory
///---------------------------------------------------------------------------------------

/** Returns the application's Application Support directory as a path string.
 
 Will create the Application Support directory automatically if it doesn't exist.
 
 @return Returns full path string of Application Support directory.
 */
+ (NSString *)applicationSupportDirectoryPath;

/** Returns the application's Application Support directory as a file URL.
 
 Will create the Application Support directory automatically if it doesn't exist.
 
 @return Returns full file URL of Application Support directory.
 */
+ (NSURL *)applicationSupportDirectoryPathURL;

///---------------------------------------------------------------------------------------
/// @name Convenience Additions
///---------------------------------------------------------------------------------------

/** Creates a directory at the given path if the specified directory doesn't already exist.
 
 @param directoryPath Full path to the desired directory.
 @return Returns `YES` if the directory needed to be created, `NO` if it already existed.
 */
- (BOOL)createDirectoryAtPathIfNecessary:(NSString *)directoryPath;

///---------------------------------------------------------------------------------------
/// @name Backup Flag
///---------------------------------------------------------------------------------------

/** Adds the iCloud "skip backup" flag to a file or directory at the given path.
 
 @param path Full path to add the skip backup flag to.
 @return Returns `YES` if the operation was successful, `NO` otherwise.
 */
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;

/** Adds the iCloud "skip backup" flag to a file or directory at the given file URL.
 
 @param URL Full file URL to add the skip backup flag to.
 @return Returns `YES` if the operation was successful, `NO` otherwise.
 */
+ (BOOL)addSkipBackupAttributeToItemAtPathURL:(NSURL *)URL;

@end
