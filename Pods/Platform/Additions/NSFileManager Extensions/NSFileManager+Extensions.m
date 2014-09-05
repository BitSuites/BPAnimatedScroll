//
//  NSFileManager+Extensions.m
//
//  Created by Cory Imdieke on 5/16/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "NSFileManager+Extensions.h"
#include <sys/xattr.h>


@implementation NSFileManager (Extensions)

+ (NSString *)applicationDocumentsDirectoryPath{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)applicationDocumentsDirectoryPathURL{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)applicationLibraryDirectoryPath{
	return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)applicationLibraryDirectoryPathURL{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)applicationCachesDirectoryPath{
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)applicationCachesDirectoryPathURL{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)applicationSupportDirectoryPath{
	// Support Directory may not exist
	NSString *dir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
	if(![[NSFileManager defaultManager] fileExistsAtPath:dir])
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	
	return dir;
}

+ (NSURL *)applicationSupportDirectoryPathURL{
	// Support Directory may not exist
	NSString *dir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
	if(![[NSFileManager defaultManager] fileExistsAtPath:dir])
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	
	return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)createDirectoryAtPathIfNecessary:(NSString *)directoryPath{
	if(![self fileExistsAtPath:directoryPath]){
		[self createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
		return YES;
	}
	return NO;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path{
	const char* filePath = [path fileSystemRepresentation];
	
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
	
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return (result == 0);
}

+ (BOOL)addSkipBackupAttributeToItemAtPathURL:(NSURL *)URL{
	return [self addSkipBackupAttributeToItemAtPath:[URL path]];
}

@end
