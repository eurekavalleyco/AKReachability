//
//  AKReachability.h
//  AKReachability
//
//  Created by Ken M. Haggerty on 9/6/13.
//  Copyright (c) 2013 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <Foundation/Foundation.h>

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (Public) //

#define NOTIFICATION_AKREACHABILITY_CURRENTSTATUS_DID_CHANGE @"kAKReachabilityCurrentStatusDidChange"

typedef enum {
    AKDisconnected = 0,
    AKConnectedViaWWAN,
    AKConnectedViaWiFi
} AKInternetStatus;

@interface AKReachability : NSObject
+ (AKInternetStatus)currentStatus;
+ (BOOL)isReachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;
@end