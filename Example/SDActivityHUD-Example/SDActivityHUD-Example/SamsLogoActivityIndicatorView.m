//
//  SamsLogoActivityIndicatorView.m
//  SDActivityHUD-Example
//
//  Created by Sam Grover on 10/7/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

#import "SamsLogoActivityIndicatorView.h"
#import "SDAutoLayout.h"

@interface SamsLogoActivityIndicatorView ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation SamsLogoActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:aRect];
        self.imageView.animationImages = [self imageFramesWithPrefix:@"loader-"];
        [self addSubview:self.imageView];
        [self.imageView sdal_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.imageView startAnimating];
    }
    return self;
}

-(NSArray*)imageFramesWithPrefix:(NSString*)prefix
{
    NSMutableArray* imageFrames = [NSMutableArray array];
    NSUInteger imageCounter = 0;
    
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02zi", prefix, imageCounter++]];
    
    while(image)
    {
        [imageFrames addObject:image];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02zi", prefix, imageCounter++]];
    }
    
    return [imageFrames copy];
}

@end
