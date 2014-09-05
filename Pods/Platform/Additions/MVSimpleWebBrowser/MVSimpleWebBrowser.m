//
//  MVSimpleWebBrowser.m
//
//  Created by Cory Imdieke on 3/24/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import "MVSimpleWebBrowser.h"
#import "UIActionSheet+Blocks.h"
#import "OpenInChromeController.h"
#import "NSURL+Extensions.h"
#import "MFMailComposeViewController+Extensions.h"
#import "Platform.h"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@implementation MVSimpleWebBrowser
@synthesize URLToLoad, customJavascriptToInject, barTitle, buttonTintColor, textFieldTintColor;

- (id)initForLoadingURL:(NSURL *)url{
	NSString *nibName = nil;
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		nibName = @"MVSimpleWebBrowser";
	else
		nibName = @"MVSimpleWebBrowser-iPhone";

    self = [self initWithNibName:nibName bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MVSimpleWebBrowserResources" ofType:@"bundle"]]];
    if (self) {
		URLToLoad = [url copy];
    }
    return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.modalPresentationStyle = UIModalPresentationPageSheet;
		self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		_printingEnabled = YES;
    }
    return self;
}

- (void)dealloc {
	[webView setDelegate:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (MVPhone && MVIOS7 && ![[UIApplication sharedApplication] isStatusBarHidden]){
        [topToolbarSpace setConstant:20.0];
        [topWebViewSpace setConstant:64.0];
    } else {
        [topToolbarSpace setConstant:0.0];
        [topWebViewSpace setConstant:44.0];
    }
    if (MVIOS7) {
        if (!buttonTintColor)
            buttonTintColor = [[[UIApplication sharedApplication] keyWindow] tintColor];
        [backButton setTintColor:buttonTintColor];
        [forwardButton setTintColor:buttonTintColor];
        [stopButton setTintColor:buttonTintColor];
        [reloadButton setTintColor:buttonTintColor];
        [doneButton setTintColor:buttonTintColor];
        [actionButton setTintColor:buttonTintColor];
        if (!textFieldTintColor)
            textFieldTintColor = [[[UIApplication sharedApplication] keyWindow] tintColor];
        [URLTextField setTintColor:textFieldTintColor];
    }
    
	if([topBar respondsToSelector:@selector(setDelegate:)]){
		[topBar setDelegate:self];
		[bottomBar setDelegate:self];
	}
    
    if ([webView.scrollView respondsToSelector:@selector(setKeyboardDismissMode:)])
        [webView.scrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	NSMutableString *textFieldURL = [[NSMutableString alloc] initWithString:textField.text];
	if([textFieldURL rangeOfString:@"://"].location != NSNotFound){
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:textFieldURL]]];
	} else {
		[textFieldURL insertString:@"http://" atIndex:0];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:textFieldURL]]];
	}
	[URLTextField setText:[[NSURL URLWithString:textFieldURL] absoluteString]];
	return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[webView loadRequest:[NSURLRequest requestWithURL:URLToLoad]];
	[URLTextField setText:[URLToLoad absoluteString]];
	
	// Prefill title
	self.title = barTitle;
	
	if(self.tabBarController){
		CGRect frame = self.view.frame;
		frame.size.height = frame.size.height - self.tabBarController.tabBar.frame.size.height;
		self.view.frame = frame;
	}
	
	if(self.navigationController){
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		[topBar removeFromSuperview];
		[loadingIndicator removeFromSuperview];
        // Need to remake the indicator to remove all autolayout contstraints
        loadingIndicator = nil;
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		UIBarButtonItem *indicatorItem = [[UIBarButtonItem alloc] initWithCustomView:loadingIndicator];
		if(self.navigationItem.rightBarButtonItem)
			[self.navigationItem setLeftBarButtonItem:indicatorItem];
		else
			[self.navigationItem setRightBarButtonItem:indicatorItem];
		if(bottomBar) {
            [bottomWebViewSpace setConstant:44.0];
            [topWebViewSpace setConstant:0.0];
        } else {
            [bottomWebViewSpace setConstant:0.0];
            [topWebViewSpace setConstant:0.0];
        }
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

#pragma mark Toolbar Delegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
	if((UIToolbar *)bar == topBar)
		return UIBarPositionTopAttached;
	else if((UIToolbar *)bar == bottomBar)
		return UIBarPositionBottom;
	else
		return UIBarPositionAny;
}

#pragma mark Custom Actions

- (void)setTintColor:(UIColor *)tColor{
	[self view];
	[topBar setTintColor:tColor];
	[bottomBar setTintColor:tColor];
}

- (IBAction)doneAction{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionAction:(UIBarButtonItem *)sender{
	RIButtonItem *safariButton = [RIButtonItem itemWithLabel:@"Open in Safari"];
	[safariButton setAction:^{
		[[UIApplication sharedApplication] openURL:webView.request.URL];
	}];

	RIButtonItem *chromeButton = [RIButtonItem itemWithLabel:@"Open in Chrome"];
	[chromeButton setAction:^{
		NSString *bundleScheme = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] stringByAppendingString:@"://"];
		
		if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bundleScheme]]){
			[[OpenInChromeController sharedInstance] openInChrome:webView.request.URL withCallbackURL:[NSURL URLWithString:bundleScheme] createNewTab:YES];
		} else {
			[[OpenInChromeController sharedInstance] openInChrome:webView.request.URL withCallbackURL:nil createNewTab:YES];
		}
	}];

	RIButtonItem *copyButton = [RIButtonItem itemWithLabel:@"Copy URL"];
	[copyButton setAction:^{
		[[UIPasteboard generalPasteboard] setURL:webView.request.URL];
	}];

	RIButtonItem *printButton = [RIButtonItem itemWithLabel:@"Print..."];
	[printButton setAction:^{
		UIPrintInteractionController *printer = [UIPrintInteractionController sharedPrintController];
		[printer setPrintFormatter:[webView viewPrintFormatter]];
		[printer setShowsPageRange:YES];
		[printer presentAnimated:YES completionHandler:nil];
	}];

	BOOL hasChrome = [[OpenInChromeController sharedInstance] isChromeInstalled];
	BOOL canPrint = ([UIPrintInteractionController isPrintingAvailable] && self.printingEnabled);

	// Create an empty sheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil];

	// Add each button
	[actionSheet addButtonItem:safariButton];

	if(hasChrome)
		[actionSheet addButtonItem:chromeButton];

	[actionSheet addButtonItem:copyButton];

	if(canPrint)
		[actionSheet addButtonItem:printButton];

	// Add the cancel button
	[actionSheet setCancelButtonIndex:[actionSheet addButtonItem:[RIButtonItem itemWithLabel:@"Cancel"]]];

	// Show
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)disableBottomToolbar{
    [bottomWebViewSpace setConstant:0.0];
	[bottomBar removeFromSuperview];
	bottomBar = nil;
}

#pragma mark Web Delegate

- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // First check the custom block
    if(self.customURLHandler){
        // Block returns YES if it handled the interaction
        BOOL blockReturn = self.customURLHandler(_webView, request, navigationType);
        if(blockReturn)
            return NO;
    }
    
	if(navigationType != UIWebViewNavigationTypeOther)
		[URLTextField setText:[[request URL] absoluteString]];
	
    if([[request URL] isMailtoRequest]){
        BOOL shownInApp = [MFMailComposeViewController presentModalComposeViewControllerWithURL:[request URL] delegate:self];
        if(!shownInApp){
            [[UIApplication sharedApplication] openURL:[request URL]];
        }
        return NO;
    }
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)_webView{
	[loadingIndicator startAnimating];
	
	[backButton setEnabled:[webView canGoBack]];
	[forwardButton setEnabled:[webView canGoForward]];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView{
	[loadingIndicator stopAnimating];
	
	[backButton setEnabled:[webView canGoBack]];
	[forwardButton setEnabled:[webView canGoForward]];
	[stopButton setEnabled:YES];
	
	[URLTextField setText:[[[webView request] URL] absoluteString]];
	
	if(barTitle)
		self.title = barTitle;
	else
		self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(customJavascriptToInject)
		[webView stringByEvaluatingJavaScriptFromString:customJavascriptToInject];
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error{
	[loadingIndicator stopAnimating];
	
	[backButton setEnabled:[webView canGoBack]];
	[forwardButton setEnabled:[webView canGoForward]];
	[stopButton setEnabled:NO];
}

@end
