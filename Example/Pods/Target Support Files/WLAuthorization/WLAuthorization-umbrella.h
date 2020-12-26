#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WLAuthorizationProtocol.h"
#import "WLAuthorizationResult.h"
#import "WLAuthorizationTypes.h"
#import "WLBasePermission.h"
#import "WLLocationPermission.h"
#import "MGAuthManager.h"
#import "WLAuthorization.h"
#import "WLAuthorizationProtocol.h"
#import "WLAuthorizationResult.h"
#import "WLAuthorizationTypes.h"
#import "WLBasePermission.h"
#import "WLLocationPermission.h"

FOUNDATION_EXPORT double WLAuthorizationVersionNumber;
FOUNDATION_EXPORT const unsigned char WLAuthorizationVersionString[];

