//
//  SDActivityHUD.h
//
//  Created by Sam Grover on 9/25/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

@import UIKit;

/*
 This class manages showing or hiding a HUD in the center of a view controller.
 Properties of the HUD:
 - It covers the entire view of the view controller with a transparent view, so all underneath interactions are disabled.
 - In its center it has a black rectangle. Inside that is a centered view consisting of a non determinate spinner and an optional message underneath it.
 */

@interface SDActivityHUD : NSObject<UIAppearance>

/**
 Sets the background color of the HUD view.  The default value is blackColor.
 */
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 Sets the class to use for the spinner.  This should be a subclass of UIView.
 The default value is [UIActivityIndicatorView class].
 */
@property (nonatomic, strong) Class indicatorClass UI_APPEARANCE_SELECTOR;

/**
 Shows the HUD inside a view controller.
 If a HUD is already being displayed inside that view controller, it is simply updated. So if it had a localized message, that message is removed.
 @param viewController The view controller inside who's view the HUD is shown.
 */
+ (void)showInViewController:(UIViewController*)viewController;

/**
 Shows the HUD inside a view controller with the specified localized message.
 If a HUD is already being displayed inside that view controller, it is simply updated.
 So if it had a localized message, that message is updated, and if it didn't, then it is added.
 @param viewController The view controller inside who's view the HUD is shown.
 @param localizedMessage The localized message to display on the HUD.
 */
+ (void)showInViewController:(UIViewController*)viewController localizedMessage:(NSString*)localizedMessage;

/**
 Hides the HUD.
 @param viewController The view controller inside who's view the HUD is hidden.
 */
+ (void)hideInViewController:(UIViewController*)viewController;

@end
