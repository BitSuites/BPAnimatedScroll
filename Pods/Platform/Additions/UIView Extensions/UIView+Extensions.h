//
//  UIView+Extensions.h
//
//  Created by Cory Imdieke on 1/22/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/// Additions to `UIView` for convenience.
@interface UIView (Extensions)

///---------------------------------------------------------------------------------------
/// @name Hierarchy Introspection
///---------------------------------------------------------------------------------------

/** Finds the first descendant view (including this view) that is a member of a particular class.
 
 @param cls Class type to search for.
 @return Returns an object of _cls_ type that is a descendant of the current view, or `nil` if not found.
 @see ancestorOrSelfWithClass:
 */
- (id)descendantOrSelfWithClass:(Class)cls;

/** Finds the first ancestor view (including this view) that is a member of a particular class.
 
 @param cls Class type to search for.
 @return Returns an object of _cls_ type that is an ancestor of the current view, or `nil` if not found.
 @see descendantOrSelfWithClass:
 */
- (id)ancestorOrSelfWithClass:(Class)cls;

/** Finds the first responder in the view hierarchy starting with this view.
 
 @return Returns the first responder, or `nil` if not found.
 */
- (id)findFirstResponder;

///---------------------------------------------------------------------------------------
/// @name Positioning
///---------------------------------------------------------------------------------------

/** Returns the view's current X position.
 
 @return Returns the view's current X position.
 @see setX:
 @see y
 @see origin
 */
- (CGFloat)x;

/** Returns the view's current Y position.
 
 @return Returns the view's current Y position.
 @see setY:
 @see x
 @see origin
 */
- (CGFloat)y;

/** Returns the view's current origin.
 
 @return Returns the view's current origin.
 @see setOrigin:
 @see x
 @see y
 */
- (CGPoint)origin;

/** Returns the view's current width.
 
 @return Returns the view's current width.
 @see setWidth:
 @see height
 @see size
 */
- (CGFloat)width;

/** Returns the view's current height.
 
 @return Returns the view's current height.
 @see setHeight:
 @see width
 @see size
 */
- (CGFloat)height;

/** Returns the view's current size.
 
 @return Returns the view's current size.
 @see setSize:
 @see width
 @see height
 */
- (CGSize)size;

/** Sets the view's X position while keeping the other frame values the same.
 
 @param newX X value to set the view's position to.
 @see x
 @see setY:
 @see setOrigin:
 */
- (void)setX:(CGFloat)newX;

/** Sets the view's Y position while keeping the other frame values the same.
 
 @param newY Y value to set the view's position to.
 @see y
 @see setX:
 @see setOrigin:
 */
- (void)setY:(CGFloat)newY;

/** Sets the view's origin while keeping the other frame values the same.
 
 @param newOrigin Origin value to set the view's position to.
 @see origin
 @see setY:
 @see setX:
 */
- (void)setOrigin:(CGPoint)newOrigin;

/** Sets the view's width while keeping the other frame values the same.
 
 @param newWidth Width to set the view's size to.
 @see width
 @see setHeight:
 @see setSize:
 */
- (void)setWidth:(CGFloat)newWidth;

/** Sets the view's height while keeping the other frame values the same.
 
 @param newHeight Height to set the view's size to.
 @see height
 @see setWidth:
 @see setSize:
 */
- (void)setHeight:(CGFloat)newHeight;

/** Sets the view's size while keeping the other frame values the same.
 
 @param newSize Size to set the view's size to.
 @see size
 @see setWidth:
 @see setHeight:
 */
- (void)setSize:(CGSize)newSize;

///---------------------------------------------------------------------------------------
/// @name Special Effects
///---------------------------------------------------------------------------------------

/** Adds a shadow to the view with nice looking default values.
 
 @param offset Shadow offset for positioning.
 */
- (void)setViewShadowWithOffset:(CGSize)offset;

/** Adds rounded corners to the view.
 
 @param rad Corner Radius to use, App Icons are `9.0`.
 */
- (void)setRoundedCornersWithRadius:(CGFloat)rad;

/** Property used as a shortcut to the setRoundedCornersWithRadius method. Primary use is for key-path access in Interface Builder
 */
@property (nonatomic, assign) CGFloat roundedCorners;

/** Adds a border to the view.
 
 @param color Color of the view border.
 @param width Width of the view border in points.
 */
- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width;

///---------------------------------------------------------------------------------------
/// @name Drawing
///---------------------------------------------------------------------------------------

/** Draws the view into a PDF format which can be saved to .pdf or printed.
 
 @return Returns `NSData` containing a PDF file.
 */
- (NSData *)renderInPDFData;

/** Draws the view at a given size to an image.
 
 Resizes the view's frame temporarily during the drawing process. This isn't visible on the screen, but the view's contents may layout differently depending on the view's settings.
 
 @param renderSize Size to draw the view at.
 @return Returns a `UIImage` containing the view's rendered image data.
 @see renderVisibleToImage
 */
- (UIImage *)renderSizeToImage:(CGSize)renderSize;

/** Draws the view to an image.
 
 Uses the view's current frame to draw, so if some of the view's content is outside the frame of the view it will be cut off.
 
 @return Returns a `UIImage` containing the view's rendered image data.
 @see renderSizeToImage:
 */
- (UIImage *)renderVisibleToImage;

///---------------------------------------------------------------------------------------
/// @name UIViewController
///---------------------------------------------------------------------------------------
/** Method that finds the first view controller in the chain
 
 @return Returns `UIViewController` containing a the first view controller that is found or nil if none is found
 */
- (UIViewController *)firstAvailableUIViewController;

/** Method that finds the first view controller in the chain this is the recursive function firstAvailableUIViewController calls
 
 @return Returns `UIViewController` containing a the first view controller that is found or nil if none is found
 */
- (id)traverseResponderChainForUIViewController;
@end
