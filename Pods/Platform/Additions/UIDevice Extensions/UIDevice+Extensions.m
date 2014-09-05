/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+Extensions.h"

@implementation UIDevice (Extensions)

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (float) cpuFrequencyMHZ
{
    return [self getSysInfo:HW_CPU_FREQ] * 0.000001;
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (float) busFrequencyMHZ
{
    return [self getSysInfo:HW_BUS_FREQ] * 0.000001;
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSNumber *) totalMemoryMB
{
	NSUInteger totalMemory = [self totalMemory];
    return @(totalMemory * 0.000000953674);
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSNumber *) userMemoryMB
{
    NSUInteger userMemory = [self userMemory];
    return @(userMemory * 0.000000953674);
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) totalDiskSpaceMB
{
    NSNumber *totalDiskSpace = [self totalDiskSpace];
	return @([totalDiskSpace doubleValue] * 0.000000953674);
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (NSNumber *) freeDiskSpaceMB
{
	NSNumber *freeDiskSpace = [self freeDiskSpace];
	return @([freeDiskSpace doubleValue] * 0.000000953674);
}

#pragma mark platform type and name utils
- (UIDevicePlatform) platformType
{
    NSString *platform = [self platform];
	
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
	
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceiPhone1;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceiPhone3G;
    if ([platform hasPrefix:@"iPhone2"])            return UIDeviceiPhone3GS;
    if ([platform hasPrefix:@"iPhone3"])            return UIDeviceiPhone4;
    if ([platform hasPrefix:@"iPhone4"])            return UIDeviceiPhone4S;
    if ([platform hasPrefix:@"iPhone5"])            return UIDeviceiPhone5;
	if ([platform hasPrefix:@"iPhone5,3"]
		|| [platform hasPrefix:@"iPhone5,4"])       return UIDeviceiPhone5C;
	if ([platform hasPrefix:@"iPhone6"])            return UIDeviceiPhone5S;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDeviceiPod1G;
    if ([platform hasPrefix:@"iPod2"])              return UIDeviceiPod2G;
    if ([platform hasPrefix:@"iPod3"])              return UIDeviceiPod3G;
    if ([platform hasPrefix:@"iPod4"])              return UIDeviceiPod4G;
	if ([platform hasPrefix:@"iPod5"])              return UIDeviceiPod5G;
	
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDeviceiPad1;
    if ([platform hasPrefix:@"iPad2"])              return UIDeviceiPad2;
    if ([platform hasPrefix:@"iPad3"])              return UIDeviceiPad3;
    if ([platform hasPrefix:@"iPad3,4"]
		|| [platform hasPrefix:@"iPad3,5"]
		|| [platform hasPrefix:@"iPad3,6"])         return UIDeviceiPad4;
	if ([platform hasPrefix:@"iPad2,5"]
		|| [platform hasPrefix:@"iPad2,6"]
		|| [platform hasPrefix:@"iPad2,7"])         return UIDeviceiPadMini;
	if ([platform hasPrefix:@"iPad4,1"]
		|| [platform hasPrefix:@"iPad4,2"])         return UIDeviceiPadAir;
	if ([platform hasPrefix:@"iPad4,4"]
		|| [platform hasPrefix:@"iPad4,5"])         return UIDeviceiPadMiniRetina;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
	
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
	
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDeviceiPhone1: return IPHONE_1G_NAMESTRING;
        case UIDeviceiPhone3G: return IPHONE_3G_NAMESTRING;
        case UIDeviceiPhone3GS: return IPHONE_3GS_NAMESTRING;
        case UIDeviceiPhone4: return IPHONE_4_NAMESTRING;
        case UIDeviceiPhone4S: return IPHONE_4S_NAMESTRING;
        case UIDeviceiPhone5: return IPHONE_5_NAMESTRING;
		case UIDeviceiPhone5C: return IPHONE_5C_NAMESTRING;
		case UIDeviceiPhone5S: return IPHONE_5S_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
			
        case UIDeviceiPod1G: return IPOD_1G_NAMESTRING;
        case UIDeviceiPod2G: return IPOD_2G_NAMESTRING;
        case UIDeviceiPod3G: return IPOD_3G_NAMESTRING;
        case UIDeviceiPod4G: return IPOD_4G_NAMESTRING;
		case UIDeviceiPod5G: return IPOD_5G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDeviceiPad1 : return IPAD_1G_NAMESTRING;
        case UIDeviceiPad2 : return IPAD_2G_NAMESTRING;
        case UIDeviceiPad3 : return IPAD_3G_NAMESTRING;
        case UIDeviceiPad4 : return IPAD_4G_NAMESTRING;
		case UIDeviceiPadMini : return IPAD_MINI_NAMESTRING;
		case UIDeviceiPadAir : return IPAD_MINI_NAMESTRING;
		case UIDeviceiPadMiniRetina : return IPAD_MINI_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
		default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

@end