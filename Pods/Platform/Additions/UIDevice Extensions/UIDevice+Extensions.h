/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

/*
 Site With Device Model Names http://theiphonewiki.com/wiki/Models
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING            @"iPhone 5c"
#define IPHONE_5S_NAMESTRING            @"iPhone 5s"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1"
#define IPAD_2G_NAMESTRING              @"iPad 2"
#define IPAD_3G_NAMESTRING              @"iPad 3"
#define IPAD_4G_NAMESTRING              @"iPad 4"
#define IPAD_MINI_NAMESTRING            @"iPad Mini"
#define IPAD_AIR_NAMESTRING				@"iPad Air"
#define IPAD_MINI_RETINA_NAMESTRING		@"iPad Mini Retina"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum : NSInteger{
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDeviceiPhone1,
    UIDeviceiPhone3G,
    UIDeviceiPhone3GS,
    UIDeviceiPhone4,
    UIDeviceiPhone4S,
    UIDeviceiPhone5,
	UIDeviceiPhone5C,
	UIDeviceiPhone5S,
    
    UIDeviceiPod1G,
    UIDeviceiPod2G,
    UIDeviceiPod3G,
    UIDeviceiPod4G,
	UIDeviceiPod5G,
    
    UIDeviceiPad1,
    UIDeviceiPad2,
    UIDeviceiPad3,
    UIDeviceiPad4,
	UIDeviceiPadMini,
	UIDeviceiPadAir,
	UIDeviceiPadMiniRetina,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA
} UIDevicePlatform;

typedef enum : NSInteger{
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown
} UIDeviceFamily;

@interface UIDevice (Extensions)
- (NSString *) platform;
- (NSString *) hwmodel;
- (UIDevicePlatform) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (float) cpuFrequencyMHZ;
- (NSUInteger) busFrequency;
- (float) busFrequencyMHZ;
- (NSUInteger) cpuCount;
- (NSUInteger) totalMemory;
- (NSNumber *) totalMemoryMB;
- (NSUInteger) userMemory;
- (NSNumber *) userMemoryMB;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) totalDiskSpaceMB;
- (NSNumber *) freeDiskSpace;
- (NSNumber *) freeDiskSpaceMB;

- (BOOL) hasRetinaDisplay;
- (UIDeviceFamily) deviceFamily;
@end