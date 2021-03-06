Appaloosa SDK
=============

Overview
--------

Appaloosa SDK library is a simple library that helps you to:
 
* Auto-update your application stored on [Appaloosa Store](http://www.appaloosa-store.com/) server
* Receive feedback from your users directly from the app (iPhone and iPad)
* Launch a dev-panel giving information about the device and the application
* Manage authorizations for your application
* Prevent your application to run on a jailbroken device

Requirements
------------

Appaloosa SDK library uses ARC and is compatible with iOS 5+.

/!\ In order to complete the setup for the features "Auto-update" and "Blacklist", the device must make at least one successful login on the native store to register its ADID to the server. 
/!\ Your App ID must be explicit (as opposed to wildcard)
/!\ Testing on the simulator won't work


Integrate Appaloosa SDK with CocoaPods
----------------------------------------

Simply add the following line to your Podfile :
       
`pod 'OTAppaloosa'`

Refer to [CocoaPods](https://github.com/CocoaPods/CocoaPods) for more information about it.

Integrate Appaloosa SDK the old fashioned way
-----------------------------------------------

- Download and import OTAppaloosa sources and its dependencies : 
    - [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding).
    - [UIDeviceAddition](https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5/tree/master/UIDeviceAddition).
    - [Reachability](https://github.com/tonymillion/Reachability).
    - [Base64](https://github.com/ekscrypto/Base64).
    - [SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone/tree/master/security).
- Add OTAppaloosa sources to your project.


Configure Appaloosa Agent
--------------------------

Once the Appaloosa SDK is integrated to your project, you need to configure the agent with the storeId and the storeToken.

- Register the Appaloosa Agent with your storeId and storeToken (you can find the storeId and storeToken on this page : http://www.appaloosa-store.com/settings).

```objective-c
[[OTAppaloosaAgent sharedAgent] registerWithStoreId:APPALOOSA_STORE_ID
                                         storeToken:APPALOOSA_STORE_TOKEN
                                        andDelegate:self];
```

Check for application update - simple version
----------------------------------------------

1. In your AppDelegate.m file, launch the autoupdate when your application starts :
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Register the Appaloosa Agent with StoreId and StoreToken
    3. In method `- (void)applicationDidBecomeActive:(UIApplication *)application`, add the following code line:

```objective-c
[[OTAppaloosaAgent sharedAgent] checkUpdates];
```
    
Check for application update - clever version
----------------------------------------------

1. Into your AppDelegate.h file
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Add the OTAppaloosaAgentDelegate into your interface:

```objective-c
@interface AppDelegate : UIResponder <UIApplicationDelegate, OTAppaloosaAgentDelegate>
```
            
2. Into your AppDelegate.m file, launch the autoupdate when your application starts :
    1. Register the Appaloosa Agent (storeId + storeToken)
    2. In method `- (void)applicationDidBecomeActive:(UIApplication *)application`, add the following code line:

```objective-c
[[OTAppaloosaAgent sharedAgent] checkUpdates];
```
        
3. Implement delegate methods if you want your own behaviour :
    1. The method `- (void)applicationUpdateRequestSuccessWithApplicationUpdateStatus:(OTAppaloosaUpdateStatus)appUpdateStatus`to inform the application needs to be updated. You need to analyze the 'appUpdateStatus' to know if an update is available and download the new version.
        By default, 
            - if the application is up to date, nothing occures.
            - if an update is available, an alert view asks the user to download it.
        If you want to launch the download : `[[OTAppaloosaAgent sharedAgent] downloadNewVersion];`
    2. The method `- (void)applicationUpdateRequestFailureWithError:(NSError *)error to be inform if something wrong occured during the update request.


Add in-app-feedback to your app
---------------------------------

This SDK provides a fully integrated solution to send feedback to your dev team. In your appDelegate file, add the following line: 

```objective-c
[[OTAppaloosaAgent sharedAgent] feedbackControllerWithDefaultButtonAtPosition:kAppaloosaButtonPositionRightBottom forRecipientsEmailArray:@[@"e.mail@address.com"]];
```
	
You have 2 possible positions for the default feedback button :
* kAppaloosaButtonPositionRightBottom
* kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger feedback, you can use the following line: 

```objective-c
[[OTAppaloosaAgent sharedAgent] openFeedbackControllerWithRecipientsEmailArray:@[@"e.mail@address.com"]];
```

To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Add the dev panel to your app
---------------------------------

This SDK also provides a dev panel which gives information about the device and the application. In your appDelegate file, add the following line:

```objective-c
[[OTAppaloosaAgent sharedAgent] devPanelWithDefaultButtonAtPosition:kAppaloosaButtonPositionRightBottom];
```

You have 2 possible positions for the default dev-panel button :
* kAppaloosaButtonPositionRightBottom
* kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger the dev panel, you can use the following line:

```objective-c
[[OTAppaloosaAgent sharedAgent] openDevPanelController];
```

To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Check authorizations for application
-------------------------------------

This SDK provides a kill switch mecanism. From the web interface (http://www.appaloosa-store.com/), you are able to authorize or not a device to access the application. The mecanism works offline by reading the blacklisted status from the keychain.

In your appDelegate file, add the following line to check authorizations when the application becomes active `- (void)applicationDidBecomeActive:(UIApplication *)application`:

```objective-c
[[OTAppaloosaAgent sharedAgent] checkAuthorizations];
```
    
By default :
- if the user is authorized, nothing occurs.
- if the user is not authorized, an alert view is displayed with the appropriated message and the application is killed.

If you prefer to develop your own behaviour, you should implement the `OTAppaloosaAgentDelegate` :
- to know if the user is authorized : `- (void)applicationAuthorizationsAllowed;`
- to know if the user is not authorized : `- (void)applicationAuthorizationsNotAllowedWithStatus:(OTAppaloosaAutorizationsStatus)status andMessage:(NSString *)message`

Check if the device is jailbroken
-------------------------------------

You can prevent your app from running on a jailbroken device.

In your appDelegate file, add the following line to check authorizations when the application becomes active `- (void)applicationDidBecomeActive:(UIApplication *)application`:

```objective-c
[[OTAppaloosaAgent sharedAgent] blockJailbrokenDevice];
```


Want some documentation?
------------------------

Appaloosa SDK for iOS use [AppleDoc](https://github.com/tomaz/appledoc) to generate its API's documentation.

License
-------

  Copyright (C) 2012 Octo Technology (http://www.octo.com)
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
       
       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
