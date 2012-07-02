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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureTypes.h"
#import "JRNSDate+ISO8601_CaptureDateTimeString.h"
#import "JRProfile.h"

/**
 * @brief A JRProfilesElement object
 **/
@interface JRProfilesElement : JRCaptureObject
@property (nonatomic, readonly) JRObjectId *profilesElementId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy)     JRJsonObject *accessCredentials; /**< User's authorization credentials for this provider @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *domain; /**< The object's \e domain property */ 
@property (nonatomic, copy)     JRStringArray *followers; /**< User's followers @note This is an array of \c NSStrings representing a list of \c identifier objects TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings */ 
@property (nonatomic, copy)     JRStringArray *following; /**< Who the user is following @note This is an array of \c NSStrings representing a list of \c identifier objects TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings */ 
@property (nonatomic, copy)     JRStringArray *friends; /**< User's friends @note This is an array of \c NSStrings representing a list of \c identifier objects TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings */ 
@property (nonatomic, copy)     NSString *identifier; /**< Profile provider unique identifier */ 
@property (nonatomic, retain)   JRProfile *profile; /**< The object's \e profile property */ 
@property (nonatomic, copy)     JRJsonObject *provider; /**< Provider for this profile @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *remote_key; /**< PrimaryKey field from Engage */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 * 
 * @note
 * Method creates a JRProfilesElement object without the required properties TODO: MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
- (id)init;

/**
 * Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 * 
 * @note
 * Method creates a JRProfilesElement object without the required properties TODO: MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
+ (id)profilesElement;

/**
 * Returns a JRProfilesElement object initialized with the given
 * *
 * @return
 *   A JRProfilesElement object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;

/**
 * Returns a JRProfilesElement object initialized with the given
 * *
 * @return
 *   A JRProfilesElement object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil,
 **/
+ (id)profilesElementWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFollowersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFollowingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: Doxygen doc
 **/
- (BOOL)needsUpdate;
/*@}*/

@end
