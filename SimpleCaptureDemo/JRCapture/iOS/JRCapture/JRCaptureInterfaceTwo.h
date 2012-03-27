//
//  JRCaptureInterfaceTwo.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"


@protocol JRCaptureInterfaceTwoDelegate <NSObject>
@optional
- (void)getCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)getCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)createCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)createCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@interface JRCaptureInterfaceTwo : NSObject <JRConnectionManagerDelegate>
+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
                    withContext:(NSObject *)context;

+ (void)createCaptureUser:(NSDictionary *)captureUser
                withToken:(NSString *)token
              forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
              withContext:(NSObject *)context;

+ (void)updateCaptureObject:(NSDictionary *)captureObject
                     withId:(NSInteger)objectId
                     atPath:(NSString *)entityPath
                  withToken:(NSString *)token
                forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
                withContext:(NSObject *)context;


+ (void)replaceCaptureObject:(NSDictionary *)captureObject
                      withId:(NSInteger)objectId
                      atPath:(NSString *)entityPath
                   withToken:(NSString *)token
                 forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
                 withContext:(NSObject *)context;

//+ (void)updateCaptureObject:(NSDictionary *)captureObject
//                     atPath:(NSString *)entityPath
//                  withToken:(NSString *)token
//                forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
//                withContext:(NSObject *)context;

//+ (void)replaceCaptureObject:(NSDictionary *)captureObject
//                      atPath:(NSString *)entityPath
//                   withToken:(NSString *)token
//                 forDelegate:(id<JRCaptureInterfaceTwoDelegate>)delegate
//                 withContext:(NSObject *)context;

@end

