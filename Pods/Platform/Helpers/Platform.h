//
//  Platform.h
//  Platform
//
//  Created by Cory Imdieke on 1/29/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

// Import Categories
#import "MKMapView+Extensions.h"
#import "NSArray+Extensions.h"
#import "NSDate+Extensions.h"
#import "NSDateFormatter+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "NSFileManager+Extensions.h"
#import "NSMutableSet+Extensions.h"
#import "NSObject+Extensions.h"
#import "NSString+Extensions.h"
#import "NSString+HTML.h"
#import "UIColor+Extensions.h"
#import "UIImage+Extensions.h"
#import "UITableView+Extensions.h"
#import "UIView+Extensions.h"
#import "UIViewController+Extensions.h"
#import "UIDevice+Extensions.h"
#import "NSURL+Extensions.h"
#import "MFMailComposeViewController+Extensions.h"

// Import Classes
#import "MVCustomDisclosureIndicator.h"
#import "MVLocationManager.h"
#import "MVPhoneFormatter.h"
#import "MVRandom.h"
#import "MVShaker.h"
#import "MVSingleItemEditor.h"
#import "MVTextValidator.h"
#import "MVTimeFormatter.h"
#import "MVSimpleWebBrowser.h"
#import "MVGradientView.h"
#import "MVBarTender.h"
#import "MVFormatter.h"
#import "BPEmailTextField.h"
#import "BPPhoneTextField.h"
#import "BPPasswordTextField.h"

// Import 3rd party frameworks
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

#import "KGNoise.h"

#import "OpenInChromeController.h"

// iPad Helper
#define MVPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MVPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MVPhone4Inch (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 568)
#define MVPhone35Inch (MVPhone && !MVPhone4Inch)

#define MVIOS7 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
