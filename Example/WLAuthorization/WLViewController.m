//
//  WLViewController.m
//  WLAuthorization
//
//  Created by 0624pdy@sina.com on 12/26/2020.
//  Copyright (c) 2020 0624pdy@sina.com. All rights reserved.
//

#import "WLViewController.h"

#import <WLAuthorization/WLAuthorization.h>

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import <CoreTelephony/CTCellularData.h>

//#import <WLAuthorization/WLLocationPermission.h>
//#import <WLAuthorization/WLCameraPermission.h>
//#import <WLAuthorization/WLMicrophonePermission.h>

@interface WLViewController () < PHPickerViewControllerDelegate >

@end

@implementation WLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"请求" style:UIBarButtonItemStylePlain target:self action:@selector(action_request:)];
    UIBarButtonItem *test = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(action_test:)];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(action_settings:)];
    self.navigationItem.rightBarButtonItems = @[ settings, test ];
    
    NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -

- (void)action_request:(id)sender {
    
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
        
//        [[WLPhotoLibraryPermission sharedPermission] requestAuthorization:^(WLAuthorizationResult *result) {
//            if (result) {
//
//            }
//        } withConfig:^(WLPhotoLibraryConfig *config) {
//            config.openSettings_ifNeeded = YES;
//            config.accessLevel = WLAuthorizationAccessLevel_WriteOnly;
//        }];
    
    CTCellularData *data = [[CTCellularData alloc] init];
    data.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state) {
        BOOL granted = (state == kCTCellularDataNotRestricted);
        NSLog(@"相机授权%@", (granted ? @"成功" : @"失败"));
    };
}
- (void)action_test:(id)sender {
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//    if (@available(iOS 14, *)) {
//        [library presentLimitedLibraryPickerFromViewController:self];
//    } else {
//        // Fallback on earlier versions
//    }
    
    
    if (@available(iOS 14, *)) {
        
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeAutomatic;
        config.selectionLimit = 1;
        
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        // Fallback on earlier versions
    }
    
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
}
- (void)action_settings:(id)sender {
    [WLBasePermission openSettings];
}





#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    if (results) {
        PHPickerResult *item = results.firstObject;
        NSItemProvider *itemProvider = item.itemProvider;
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
            [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                if ([object isKindOfClass:UIImage.class]) {
                    UIImage *image = (UIImage *)object;
                    if(image) {
                        
                    }
                }
            }];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
