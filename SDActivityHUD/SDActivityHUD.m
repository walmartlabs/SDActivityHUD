//
//  SDActivityHUD.m
//
//  Created by Sam Grover on 9/25/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

#import "SDActivityHUD.h"
#import <objc/runtime.h>
#import "SDAutoLayout.h"

void const *SDActivityHUDViewAssociatedObjectKey = @"SDActivityHUDViewAssociatedObjectKey";

static NSUInteger SDActivityHUDFramingViewTag = 1;
static NSUInteger SDActivityHUDSpinnerViewTag = 2;
static NSUInteger SDActivityHUDMessageLabelTag = 3;

static CGFloat SDActivityHUDStandardInset = 10.0f;
static CGFloat SDActivityHUDWideInset = 15.0f;

@implementation SDActivityHUD

+ (void)showInViewController:(UIViewController*)viewController
{
    [SDActivityHUD showInViewController:viewController localizedMessage:nil];
}

+ (void)showInViewController:(UIViewController*)viewController localizedMessage:(NSString*)localizedMessage
{
    [SDActivityHUD removeHUDFromViewController:viewController];
    
    // The main background view that covers entire root view of the view controller.
    UIView* hudView = [UIView newSDAutoLayoutView];
    [viewController.view addSubview:hudView];
    [hudView sdal_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // The frame of the HUD, usually represented with a black background.
    UIView* framingView = [UIView newSDAutoLayoutView];
    framingView.tag = SDActivityHUDFramingViewTag;
    [hudView addSubview:framingView];
    framingView.backgroundColor = [SDActivityHUD appearance].backgroundColor;
    framingView.layer.cornerRadius = SDActivityHUDStandardInset;
    [framingView sdal_setDimension:ALDimensionWidth toSize:100.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_setDimension:ALDimensionHeight toSize:100.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_pinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_pinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_pinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_pinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [framingView sdal_centerInSuperview];
    
    UIActivityIndicatorView* spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinnerView.tag = SDActivityHUDSpinnerViewTag;
    [framingView addSubview:spinnerView];
    [spinnerView startAnimating];
    
    if (localizedMessage.length == 0)
    {
        [spinnerView sdal_centerInSuperview];
    }
    else
    {
        [spinnerView sdal_pinEdgeToSuperviewEdge:ALEdgeTop withInset:SDActivityHUDWideInset];
        [spinnerView sdal_alignAxisToSuperviewAxis:ALAxisVertical];
        
        UILabel* messageLabel = [[UILabel alloc] initForSDAutoLayout];
        messageLabel.tag = SDActivityHUDMessageLabelTag;
        [framingView addSubview:messageLabel];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor whiteColor];
        [messageLabel sdal_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(SDActivityHUDStandardInset, SDActivityHUDStandardInset, SDActivityHUDStandardInset, SDActivityHUDStandardInset) excludingEdge:ALEdgeTop];
        [messageLabel sdal_pinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:spinnerView withOffset:SDActivityHUDStandardInset];
        [messageLabel sdal_alignAxisToSuperviewAxis:ALAxisVertical];
        messageLabel.text = localizedMessage;
    }
    
    objc_setAssociatedObject(viewController, SDActivityHUDViewAssociatedObjectKey, hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)removeHUDFromViewController:(UIViewController*)viewController
{
    UIView* hudView = objc_getAssociatedObject(viewController, SDActivityHUDViewAssociatedObjectKey);
    if (hudView)
    {
        [hudView removeFromSuperview];
        objc_setAssociatedObject(viewController, SDActivityHUDViewAssociatedObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)hideInViewController:(UIViewController*)viewController
{
    [SDActivityHUD removeHUDFromViewController:viewController];
}

#pragma mark - Implement UIAppearance protocol

// used to store instances on a per-class-name basis.
static NSMutableDictionary *__sdah_classes = nil;

+ (instancetype)appearance
{
    return [SDActivityHUD appearanceForClass:[self class]];
}

+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION
{
    // we don't want to support this.
    @throw [NSException exceptionWithName:@"SDActivityHUD" reason:@"appearanceWhenContainedIn: is not supported." userInfo:nil];
    return nil;
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait NS_AVAILABLE_IOS(8_0)
{
    // we don't want to support this.
    @throw [NSException exceptionWithName:@"SDActivityHUD" reason:@"appearanceForTraitCollection: is not supported." userInfo:nil];
    return nil;
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE_IOS(8_0)
{
    // we don't want to support this.
    @throw [NSException exceptionWithName:@"SDActivityHUD" reason:@"appearanceForTraitCollection:whenContainedIn: is not supported." userInfo:nil];
    return nil;
}

+ (instancetype)appearanceForClass:(Class)aClass
{
    // we need storage for the instance where someone subclasses.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!__sdah_classes)
            __sdah_classes = [NSMutableDictionary dictionary];
    });
    
    NSString *className = NSStringFromClass(aClass);
    id appearanceProxy = [__sdah_classes objectForKey:className];
    if (!appearanceProxy)
    {
        appearanceProxy = [[SDActivityHUD alloc] init];
        [__sdah_classes setObject:appearanceProxy forKey:className];
    }
    
    return appearanceProxy;
}

@end
