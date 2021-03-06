//
//  ViewController.m
//  SDActivityHUD-Example
//
//  Created by Sam Grover on 10/2/14.
//  Copyright (c) 2014 Set Direction. All rights reserved.
//

#import "ViewController.h"
#import "SDActivityHUD.h"
#import "SamsLogoActivityIndicatorView.h"
#import "DiscIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up a background to show blur
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loader-00"]];
    
    [SDActivityHUD appearance].backgroundColor = [UIColor redColor];
    [SDActivityHUD appearance].activityIndicatorColor = [UIColor yellowColor];
    [SDActivityHUD appearance].messageLabelColor = [UIColor yellowColor];
    [SDActivityHUD appearance].backgroundBlurEffect = YES;
    
    // Uncomment the following line to see the exception thrown for a non-compliant indicatorViewClass
    //[SDActivityHUD appearance].indicatorViewClass = [UIViewController class];
    
    // Cycle through various customizations to show capabilities
    NSUInteger timeInSeconds = 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD showInViewController:self];
    });
    
    timeInSeconds += 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD showInViewController:self localizedMessage:@"A short message."];
    });
    
    timeInSeconds += 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD appearance].indicatorViewClass = [DiscIndicatorView class];
        [SDActivityHUD showInViewController:self localizedMessage:@"A long message. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus bibendum nisl eget eros mollis vestibulum. Etiam pulvinar, leo sed cursus aliquam, odio leo ullamcorper augue, et dictum elit nibh non nulla. Sed quis eleifend sapien. Curabitur dignissim suscipit sapien eu varius. Donec rhoncus sodales ultricies. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse laoreet ullamcorper dolor, vitae congue augue tempor eget. Nunc tempor, quam a volutpat bibendum, justo ex aliquam est, ac accumsan ligula nisl et eros. Maecenas sed vehicula tortor. Praesent id erat turpis. Nullam imperdiet neque at tristique lobortis. Integer tristique enim non lectus fringilla, eu maximus lacus elementum. Nulla lobortis eros mauris, eget interdum leo imperdiet sit amet. Nulla quis urna id lorem egestas congue nec ac eros. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean eu eros nec quam ornare pharetra at in dui."];
    });
    
    timeInSeconds += 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD showInViewController:self localizedMessage:@"This is a sample message which is probably about as long as a message in a HUD should be."];
    });
    
    timeInSeconds += 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD appearance].indicatorViewClass = [SamsLogoActivityIndicatorView class];
        [SDActivityHUD appearance].backgroundColor = [UIColor lightGrayColor];
        [SDActivityHUD showInViewController:self];
    });
    
    timeInSeconds += 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SDActivityHUD hideInViewController:self];
    });
}

@end
