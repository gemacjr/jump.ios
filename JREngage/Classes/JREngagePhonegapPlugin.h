/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   JREngagePhonegapPlugin.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, January 4th, 2012
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef PHONEGAP_FRAMEWORK
#define PHONEGAP_OR_CORDOVA

#import <PhoneGap/PGPlugin.h>
#import <PhoneGap/JSONKit.h>

#define PCPlugin PGPlugin
#define PCPluginResult PluginResult
#define PCCommandStatus_OK PGCommandStatus_OK
#define PCCommandStatus_ERROR PGCommandStatus_ERROR

#else
#ifdef CORDOVA_FRAMEWORK
#define PHONEGAP_OR_CORDOVA

#import <Cordova/CDVPlugin.h>
#import <Cordova/JSONKit.h>

#define PCPlugin CDVPlugin
#define PCPluginResult CDVPluginResult
#define PCCommandStatus_OK CDVCommandStatus_OK
#define PCCommandStatus_ERROR CDVCommandStatus_ERROR

#endif
#endif

#ifdef PHONEGAP_OR_CORDOVA
#import <Foundation/Foundation.h>
#import "JREngage.h"

@interface JREngagePhonegapPlugin : PCPlugin <JREngageDelegate>
{
    JREngage *jrEngage;
    NSString *callbackID;

    NSMutableDictionary *fullAuthenticationResponse;
    NSMutableDictionary *fullSharingResponse;
    NSMutableArray      *authenticationBlobs;
    NSMutableArray      *shareBlobs;

    BOOL weAreSharing;
}

@property (nonatomic, copy) NSString* callbackID;
@end

#endif
