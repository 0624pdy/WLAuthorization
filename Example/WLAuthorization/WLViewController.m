//
//  WLViewController.m
//  WLAuthorization
//
//  Created by 0624pdy@sina.com on 12/26/2020.
//  Copyright (c) 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLViewController.h"

#import <WLAuthorization/WLAuthorization.h>

//#import <WLAuthorization/WLLocationPermission.h>
//#import <WLAuthorization/WLCameraPermission.h>
//#import <WLAuthorization/WLMicrophonePermission.h>

@interface WLViewController ()

@end

@implementation WLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
    
   
//    [[WLLocationPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
//        if (result.granted) {
//
//        }
//    } withConfig:^(WLLocationConfig *config) {
//        config.openSettings_ifNeeded = YES;
//        config.requestType = WLAuthRequestType_Always;
//    }];
    
//    [[WLCameraPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
//        if (result.granted) {
//
//        }
//    } withConfig:^(WLCameraConfig *config) {
//        config.openSettings_ifNeeded = YES;
//    }];
    
//    [[WLMicrophonePermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
//        if (result.granted) {
//            
//        }
//    } withConfig:^(WLMicrophoneConfig *config) {
//        config.openSettings_ifNeeded = YES;
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
