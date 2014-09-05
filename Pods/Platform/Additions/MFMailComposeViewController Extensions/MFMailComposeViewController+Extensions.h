//
//  MFMailComposeViewController+Extensions.h
//  Platform
//
//  Created by Cory Imdieke on 12/10/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface MFMailComposeViewController (Extensions)

// Parse the request URL and display an email mail composition interface, filled with
// the elements resulting of this parsing.
// Return NO if the device doesn't provide an email sending service.
+ (BOOL)presentModalComposeViewControllerWithURL:(NSURL *)aURL delegate:(id<MFMailComposeViewControllerDelegate>)delegate;

@end
