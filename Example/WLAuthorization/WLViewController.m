//
//  WLViewController.m
//  WLAuthorization
//
//  Created by 0624pdy@sina.com on 12/26/2020.
//  Copyright (c) 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLViewController.h"

#import <WLAuthorization/WLAuthorization.h>

@interface WLViewController ()

@end

@implementation WLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
    
    WLLocationConfig *config = [WLLocationConfig defaultConfig];
    config.requestType = 1;
    
    [WLLocationPermission sharedPermission].config = config;
    [[WLLocationPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
        if (result.granted) {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
