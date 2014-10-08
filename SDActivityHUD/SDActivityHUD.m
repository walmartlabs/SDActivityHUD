//
//  SDActivityHUD.m
//
//  Created by Sam Grover on 9/25/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

#import "SDActivityHUD.h"
#import <objc/runtime.h>
#import "SDAutoLayout.h"

void const *SDActivityHUDAssociatedObjectKey = @"SDActivityHUDViewAssociatedObjectKey";

static CGFloat SDActivityHUDStandardInset = 10.0f;
static CGFloat SDActivityHUDWideInset = 15.0f;

static CGFloat SDActivityHUDFrameMinimumDimension = 100.0f;
static CGFloat SDActivityHUDFrameMinimumInset = 40.0f;

@interface SDActivityHUD()
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UIView *framingView;
@property (nonatomic, strong) UIView *spinnerView;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation SDActivityHUD

+ (void)showInViewController:(UIViewController*)viewController
{
    [SDActivityHUD showInViewController:viewController localizedMessage:nil];
}

+ (void)showInViewController:(UIViewController*)viewController localizedMessage:(NSString*)localizedMessage
{
    [SDActivityHUD removeHUDFromViewController:viewController];
    
    SDActivityHUD *hud = [[SDActivityHUD alloc] init];
    [hud addHudOnViewController:viewController localizedMessage:localizedMessage];
}

+ (void)removeHUDFromViewController:(UIViewController*)viewController
{
    SDActivityHUD *hud = objc_getAssociatedObject(viewController, SDActivityHUDAssociatedObjectKey);
    if (hud)
        [hud removeHudOnViewController:viewController];
}

+ (void)hideInViewController:(UIViewController*)viewController
{
    [SDActivityHUD removeHUDFromViewController:viewController];
}

- (instancetype)init
{
    self = [super init];
    
    // setup default values here.
    _backgroundColor = [UIColor blackColor];
    _backgroundBlurEffect = NO;
    _activityIndicatorColor = [UIColor whiteColor];
    _messageLabelColor = [UIColor whiteColor];
    _indicatorViewClass = [UIActivityIndicatorView class];
    
    return self;
}

- (void)setIndicatorClass:(Class)indicatorClass
{
    if (![indicatorClass isSubclassOfClass:[UIView class]])
        @throw [NSException exceptionWithName:@"SDActivityHUDException" reason:@"Only subclasses of UIView are supported as indicator classes." userInfo:nil];
    else
        _indicatorViewClass = indicatorClass;
}

- (void)addHudOnViewController:(UIViewController *)viewController localizedMessage:(NSString *)localizedMessage
{
    SDActivityHUD *appearance = [SDActivityHUD appearance];
    
    // Create the main background view that covers entire root view of the view controller.
    UIView* mainContentView = nil;
    if (appearance.backgroundBlurEffect && [self systemVersionGreaterThanOrEqualToVersion:@"8"])
    {
        UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        // As per docs for UIVisualEffectView, setting up to add subviews to its contentView
        mainContentView = visualEffectView.contentView;
        self.hudView = visualEffectView;
    }
    else
    {
        self.hudView = [UIView newSDAutoLayoutView];
        mainContentView = self.hudView;
    }
    
    [viewController.view addSubview:self.hudView];
    [self.hudView sdal_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // The frame of the HUD, usually represented with a black background.
    self.framingView = [UIView newSDAutoLayoutView];
    [mainContentView addSubview:self.framingView];

    self.framingView.backgroundColor = appearance.backgroundColor;
    self.framingView.layer.cornerRadius = SDActivityHUDStandardInset;
    
    // Configure layout.
    [self.framingView sdal_setDimension:ALDimensionWidth toSize:SDActivityHUDFrameMinimumDimension relation:NSLayoutRelationGreaterThanOrEqual];
    [self.framingView sdal_setDimension:ALDimensionHeight toSize:SDActivityHUDFrameMinimumDimension relation:NSLayoutRelationGreaterThanOrEqual];
    
    [self.framingView sdal_pinEdgeToSuperviewEdge:ALEdgeLeft withInset:SDActivityHUDFrameMinimumInset relation:NSLayoutRelationGreaterThanOrEqual];
    [self.framingView sdal_pinEdgeToSuperviewEdge:ALEdgeRight withInset:SDActivityHUDFrameMinimumInset relation:NSLayoutRelationGreaterThanOrEqual];
    [self.framingView sdal_pinEdgeToSuperviewEdge:ALEdgeTop withInset:SDActivityHUDFrameMinimumInset relation:NSLayoutRelationGreaterThanOrEqual];
    [self.framingView sdal_pinEdgeToSuperviewEdge:ALEdgeBottom withInset:SDActivityHUDFrameMinimumInset relation:NSLayoutRelationGreaterThanOrEqual];
    
    [self.framingView sdal_centerInSuperview];

    // Create a standard spinner to use or to reference for size in case of user supplied custom spinner.
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (appearance.indicatorViewClass == [UIActivityIndicatorView class])
    {
        [activityIndicatorView startAnimating];
        activityIndicatorView.color = appearance.activityIndicatorColor;
        self.spinnerView = activityIndicatorView;
    }
    else
    {
        self.spinnerView = [[appearance.indicatorViewClass alloc] initWithFrame:activityIndicatorView.frame];
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.spinnerView sdal_setDimensionsToSize:activityIndicatorView.frame.size];
    }
    
    [self.framingView addSubview:self.spinnerView];

    if (localizedMessage.length == 0)
    {
        [self.spinnerView sdal_centerInSuperview];
    }
    else
    {
        [self.spinnerView sdal_pinEdgeToSuperviewEdge:ALEdgeTop withInset:SDActivityHUDWideInset];
        [self.spinnerView sdal_alignAxisToSuperviewAxis:ALAxisVertical];
        
        self.messageLabel = [[UILabel alloc] initForSDAutoLayout];
        [self.framingView addSubview:self.messageLabel];
        
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = appearance.messageLabelColor;
        [self.messageLabel sdal_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(SDActivityHUDStandardInset, SDActivityHUDStandardInset, SDActivityHUDStandardInset, SDActivityHUDStandardInset) excludingEdge:ALEdgeTop];
        [self.messageLabel sdal_pinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.spinnerView withOffset:SDActivityHUDStandardInset];
        [self.messageLabel sdal_alignAxisToSuperviewAxis:ALAxisVertical];
        self.messageLabel.text = localizedMessage;
    }
    
    objc_setAssociatedObject(viewController, SDActivityHUDAssociatedObjectKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeHudOnViewController:(UIViewController *)viewController
{
    [self.hudView removeFromSuperview];
    objc_setAssociatedObject(viewController, SDActivityHUDAssociatedObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

#pragma mark Utility

// TODO: Remove this method after integrating with ios-shared and use the original from UIDevice+machine.h
- (BOOL)systemVersionGreaterThanOrEqualToVersion:(NSString *)minVersion
{
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult result = [sysVersion compare:minVersion options:NSNumericSearch];
    if (result == NSOrderedDescending || result == NSOrderedSame)
        return YES;
    return NO;
}

@end
