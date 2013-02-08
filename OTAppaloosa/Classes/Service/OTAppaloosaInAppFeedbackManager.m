//
//  OTAppaloosaInAppFeedbackManager.m
//  OTFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaInAppFeedbackManager.h"


// Controllers :
#import "OTAppaloosaInAppFeedbackViewController.h"

// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "NSObject+performBlockAfterDelay.h"
#import "UIViewController+CurrentPresentedController.h"


// Constants :
static const CGFloat kFeedbackButtonTopMargin = 70;

static const CGFloat kFeedbackButtonWidth = 34;
static const CGFloat kFeedbackButtonHeight = 41;

static const CGFloat kAnimationDuration = 0.9;

@interface OTAppaloosaInAppFeedbackManager ()

- (void)onFeedbackButtonTap;

+ (UIImage *)getScreenshotImageFromCurrentScreen;
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton;

@end


@implementation OTAppaloosaInAppFeedbackManager


/**************************************************************************************************/
#pragma mark - Singleton

static OTAppaloosaInAppFeedbackManager *manager;

+ (OTAppaloosaInAppFeedbackManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)init
{
    self = [super init];
    if (self)
    {      
        [self initializeDefaultFeedbackButton];        
    }
    return self;
}


/**************************************************************************************************/
#pragma mark - UI

- (void)showDefaultFeedbackButton:(BOOL)shouldShow
{
    [self.feedbackButton setHidden:!shouldShow];
}


/**************************************************************************************************/
#pragma mark - IBActions

- (void)onFeedbackButtonTap
{
    [self triggerFeedbackWithRecipientsEmailArray:self.recipientsEmailArray
                                andFeedbackButton:self.feedbackButton];
}


/**************************************************************************************************/
#pragma mark - Feedback 

/**
 * @brief Create and display default feedback button
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)initializeDefaultFeedbackButtonForRecipientsEmailArray:(NSArray *)emailsArray
{
    self.recipientsEmailArray = emailsArray;
    [self showDefaultFeedbackButton:YES];
}


/**
 * @brief Trigger screenshot + feedback viewController launch
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray
{
    [self triggerFeedbackWithRecipientsEmailArray:emailsArray andFeedbackButton:self.feedbackButton];
}


- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton
{
    // take screenshot :
    UIImage *screenshotImage = [OTAppaloosaInAppFeedbackManager getScreenshotImageFromCurrentScreen];
    
    // display white blink screen (to copy iOS screenshot effect) before opening feedback controller :
    UIView *whiteView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    [applicationWindow addSubview:whiteView];
    [UIView animateWithDuration:kAnimationDuration animations:^
     {
         [whiteView setAlpha:0];
     }
                     completion:^(BOOL finished)
     {
         [whiteView removeFromSuperview];
         
         // open feedback controller :
         OTAppaloosaInAppFeedbackViewController *feedbackViewController =
            [[OTAppaloosaInAppFeedbackViewController alloc] initWithFeedbackButton:feedbackButton
                                                              recipientsEmailArray:emailsArray
                                                                andScreenshotImage:screenshotImage];
         
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             [feedbackViewController setModalPresentationStyle:UIModalPresentationFormSheet];
         }
         
         [[UIViewController currentPresentedController] presentModalViewController:feedbackViewController animated:YES];
     }];
}

/**************************************************************************************************/
#pragma mark - Private


/**
 * @brief Create the default feedback button and add it as subview on application window
 */
- (void)initializeDefaultFeedbackButton
{
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect feedbackButtonFrame = CGRectMake(applicationWindow.frame.size.width - kFeedbackButtonWidth,
                                            kFeedbackButtonTopMargin,
                                            kFeedbackButtonWidth,
                                            kFeedbackButtonHeight);
    self.feedbackButton = [[UIButton alloc] initWithFrame:feedbackButtonFrame];
    [self.feedbackButton setImage:[UIImage imageNamed:@"btn_feedback"] forState:UIControlStateNormal];
    [self.feedbackButton addTarget:self action:@selector(onFeedbackButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.feedbackButton setHidden:YES]; // button is hidden by default
    
    [applicationWindow addSubview:self.feedbackButton];
}


+ (UIImage *)getScreenshotImageFromCurrentScreen
{
    UIView *viewToCopy = [[UIViewController currentPresentedController] view];
    CGRect rect = [viewToCopy bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [[viewToCopy layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenImage;
}


@end