//
//  DiscIndicatorView.m
//  SDActivityHUD-Example
//
//  Created by Sam Grover on 10/14/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

#import "DiscIndicatorView.h"

@interface DiscIndicatorView ()

@property (nonatomic, strong) UIView* discView;

@end


@implementation DiscIndicatorView

- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self) {
        self.color = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - SDActivityHUDCustomIndicatorViewProtocol

@synthesize color;

- (void)startAnimating
{
    CGFloat discViewDimension = 36.0f;
    self.discView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, discViewDimension, discViewDimension)];
    
    CAShapeLayer* spinCircle = [CAShapeLayer layer];
    spinCircle.strokeColor = self.color.CGColor;
    spinCircle.fillColor = [UIColor clearColor].CGColor;
    spinCircle.lineWidth = 4;
    spinCircle.lineDashPattern = @[ @4, @4 ];
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:self.discView.frame];
    spinCircle.path = path.CGPath;
    
    [self.discView.layer addSublayer:spinCircle];
    [self addSubview:self.discView];
    self.discView.frame = CGRectIntegral(CGRectMake(self.bounds.size.width / 2.0f - (discViewDimension / 2.0f),
                                                    self.bounds.size.height / 2.0f - (discViewDimension / 2.0f),
                                                    discViewDimension,
                                                    discViewDimension));
    CABasicAnimation* rotationAnimation = [CABasicAnimation animation];
    rotationAnimation.keyPath = @"transform.rotation";
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 1.5f;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.discView.layer addAnimation:rotationAnimation forKey:@"spinner"];
}

- (void)stopAnimating
{
    [self.discView removeFromSuperview];
    self.discView = nil;
}

@end
