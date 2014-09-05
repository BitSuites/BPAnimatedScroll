//
//  MVSimpleWebBrowser.h
//
//  Created by Cory Imdieke on 3/24/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

/// Web Browser Implementation with all the basic elements like an address bar, navigation buttons, etc. Works automatically on iPhone or iPad.
///
/// This class requires UIActionSheet+Blocks which is available here: https://github.com/jivadevoe/UIAlertView-Blocks

typedef BOOL(^URLHandlerBlock)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType);

@interface MVSimpleWebBrowser : UIViewController <UIWebViewDelegate, UITextFieldDelegate, UIToolbarDelegate, MFMailComposeViewControllerDelegate>{
	IBOutlet UIWebView *webView;
	IBOutlet UIActivityIndicatorView *loadingIndicator;
	IBOutlet UITextField *URLTextField;
	
	IBOutlet UIToolbar *topBar;
	IBOutlet UIToolbar *bottomBar;
	
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIBarButtonItem *forwardButton;
	IBOutlet UIBarButtonItem *stopButton;
    IBOutlet UIBarButtonItem *reloadButton;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIBarButtonItem *actionButton;
    
    IBOutlet NSLayoutConstraint *topToolbarSpace;
    IBOutlet NSLayoutConstraint *topWebViewSpace;
    IBOutlet NSLayoutConstraint *bottomWebViewSpace;
}

/** Whether or not the AirPrint option is enabled in the Action menu.
 
 Default: `YES`
 */
@property (nonatomic) BOOL printingEnabled;

/** Default URL to load on first display.
 */
@property (nonatomic, retain) NSURL *URLToLoad;

/** Custom Javascript string which should be loaded into the DOM after each page loads.
 
 This continues to work even if the user navigates to another page.
 */
@property (nonatomic, retain) NSString *customJavascriptToInject;

/** Custom URL handler which will get called for each loaded item.
 
 Return YES if the link is handled by the block, NO if it isn't.
 */
@property (nonatomic, copy) URLHandlerBlock customURLHandler;

/** Default title text.
 
 If this is nil, the title will be the title of the currently displayed web page.
 */
@property (nonatomic, retain) NSString *barTitle;

/** Button Tint Color for iOS7
 
 If this is nil, will use key window tint color
 */
@property (nonatomic, retain) UIColor *buttonTintColor;

/** Text Field Tint Color for iOS7
 
 If this is nil, will use key window tint color
 */
@property (nonatomic, retain) UIColor *textFieldTintColor;

/** Staus Bar Style
 
 If this is nil, the stlye will bu UIStatusBarStyleDefault
 */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/** Designated initilizier.
 
 Automatically selects the correct NIB to load depending on the current device.
 @param url Sets the default URL to load on first display.
 */
- (id)initForLoadingURL:(NSURL *)url;

- (IBAction)doneAction;
- (IBAction)actionAction:(UIBarButtonItem *)sender;

/** Sets the tint color of the top and bottom toolbars to match the rest of the app's appearance.
 
 @param tColor The color to tint the bars to.
 */
- (void)setTintColor:(UIColor *)tColor;

/** Hides the bottom toolbar on display. Used where a toolbar on the bottom of the screen is innapropriate.
 */
- (void)disableBottomToolbar;

@end
