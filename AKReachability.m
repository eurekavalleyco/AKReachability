//
//  AKReachability.m
//  AKReachability
//
//  Created by Ken M. Haggerty on 9/6/13.
//  Copyright (c) 2013 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "AKReachability.h"
#import "AKDebugger.h"
#import "AKGenerics.h"
#import "AKPrivateInfo.h"
#import "Reachability.h"

#pragma mark - // DEFINITIONS (Private) //

@interface AKReachability ()
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic) AKInternetStatus currentStatus;
+ (AKReachability *)sharedManager;
- (void)setup;
- (void)teardown;
- (void)internetStatusDidChange:(NSNotification *)notification;
@end

@implementation AKReachability

#pragma mark - // SETTERS AND GETTERS //

@synthesize reachability = _reachability;
@synthesize currentStatus = _currentStatus;

- (Reachability *)reachability
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    if (!_reachability)
    {
        _reachability = [Reachability reachabilityWithHostname:[AKPrivateInfo reachabilityDomain]];
    }
    return _reachability;
}

#pragma mark - // INITS AND LOADS //

- (id)init
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:nil message:nil];
    
    self = [super init];
    if (self)
    {
        [self setup];
    }
    else [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeWarning methodType:AKMethodTypeSetup customCategories:nil message:[NSString stringWithFormat:@"Could not initialize %@", stringFromVariable(self)]];
    return self;
}

- (void)dealloc
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:nil message:nil];
    
    [self teardown];
}

#pragma mark - // PUBLIC METHODS //

+ (AKInternetStatus)currentStatus
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    return [[AKReachability sharedManager] currentStatus];
}

+ (BOOL)isReachable
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    return [[[AKReachability sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    return [[[AKReachability sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    return [[[AKReachability sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

+ (AKReachability *)sharedManager
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter customCategories:nil message:nil];
    
    static AKReachability *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:nil message:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetStatusDidChange:) name:kReachabilityChangedNotification object:nil];
    [self.reachability startNotifier];
    
}

- (void)teardown
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:nil message:nil];
    
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)internetStatusDidChange:(NSNotification *)notification
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified customCategories:@[AKD_NOTIFICATION_CENTER] message:nil];
    
    if ([AKReachability isReachableViaWiFi]) [self setCurrentStatus:AKConnectedViaWiFi];
    else if ([AKReachability isReachableViaWWAN]) [self setCurrentStatus:AKConnectedViaWWAN];
    else [self setCurrentStatus:AKDisconnected];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AKREACHABILITY_CURRENTSTATUS_DID_CHANGE object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.currentStatus] forKey:NOTIFICATION_OBJECT_KEY]];
}

@end