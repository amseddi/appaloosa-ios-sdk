// Copyright 2013 OCTO Technology
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
//  OTViewController.m
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTViewController.h"

// Controllers :
#import "OTSecondViewController.h"


// Fmk :
#import "OTAppaloosa.h"


@implementation OTViewController

/**************************************************************************************************/
#pragma mark - IBActions

- (IBAction)onOpenModalButtonTap:(id)sender
{
    OTSecondViewController *controller = [[OTSecondViewController alloc] initAsAModal:YES];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onPushButtonTap:(id)sender
{
    OTSecondViewController *controller = [[OTSecondViewController alloc] initAsAModal:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onTriggerFeedbackButtonTap:(id)sender
{
    [[OTAppaloosaAgent sharedAgent] openFeedbackControllerWithRecipientsEmailArray:nil];
}

- (IBAction)onTriggerDevPanelButtonTap:(id)sender
{
    [[OTAppaloosaAgent sharedAgent] openDevPanelController];
}

- (IBAction)onDefaultFeedbackButtonSwitchChange:(UISwitch *)sender
{
    [[OTAppaloosaAgent sharedAgent] showDefaultFeedbackButton:sender.on];
}

- (IBAction)onDefaultDevPanelButtonSwitchChange:(UISwitch *)sender
{
    [[OTAppaloosaAgent sharedAgent] showDefaultDevPanelButton:sender.on];
}

@end
