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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/**
 * @mainpage Janrain Capture for iOS
 *
 * @brief TODO: write the brief
 *
 * TODO: write the doc
 **/

typedef NSNumber JRString;  /**< TODO */
typedef NSNumber JRBoolean; /**< TODO */
typedef NSNumber JRInteger; /**< TODO */
typedef NSNumber JRNumber; /**< TODO */
typedef NSDate   JRDate; /**< TODO */
typedef NSDate   JRDateTime; /**< TODO */
typedef NSString JRIpAddress; /**< TODO */
typedef NSObject JRPassword; /**< TODO */
typedef NSObject JRJsonObject; /**< TODO */
typedef NSArray  JRArray; /**< TODO */
typedef NSArray  JRStringArray; /**< TODO */
typedef NSString JRUuid; /**< TODO */
typedef NSNumber JRObjectId; /**< TODO */



/**
 * @page Types
 * Capture and Objective-C Types
 *
@anchor types
@htmlonly
<table border="1px solid black">
<tr><b><td>Schema Type  </td><td>Json Type         </td><td>Obj-C Type   </td><td>JRCapture Type            </td><td>Recursive  </td><td>Typedeffed  </td><td>Can Change  </td><td>Notes  </td></b></tr>
<tr><td>string          </td><td>String            </td><td>NSString     </td><td>NSString                  </td><td>           </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>boolean         </td><td>Boolean           </td><td>NSNumber     </td><td>JRBoolean                 </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>integer         </td><td>Number            </td><td>NSNumber     </td><td>JRInteger                 </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>decimal         </td><td>Number            </td><td>NSNumber     </td><td>NSNumber                  </td><td>           </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>date            </td><td>String            </td><td>NSDate       </td><td>JRDate                    </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>dateTime        </td><td>String            </td><td>NSDate       </td><td>JRDateTime                </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>ipAddress       </td><td>String            </td><td>NSString     </td><td>JRIpAddress               </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>password        </td><td>String or Object  </td><td>NSObject     </td><td>JRPassword                </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>JSON            </td><td>(any type)        </td><td>NSObject     </td><td>JRJsonObject              </td><td>           </td><td>Yes         </td><td>            </td><td>The JSON type is unstructured data; it only has to be valid parseable JSON.</td></tr>
<tr><td>plural          </td><td>Array             </td><td>NSArray      </td><td>NSArray or JRSimpleArray  </td><td>Yes        </td><td>No/Yes      </td><td>            </td><td>Primitive child attributes of plurals may have the constraint locally-unique.</td></tr>
<tr><td>object          </td><td>Object            </td><td>NSObject     </td><td>JR<PropertyName           </td><td>Yes        </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>uuid            </td><td>String            </td><td>NSString     </td><td>JRUuid                    </td><td>           </td><td>Yes         </td><td>            </td><td>Not an externally usable type.</td></tr>
<tr><td>id              </td><td>Number            </td><td>NSNumber     </td><td>JRObjectId                </td><td>           </td><td>Yes         </td><td>            </td><td>Not an externally usable type.</td></tr>
</table>
@endhtmlonly
 *
 **/

#import <Foundation/Foundation.h>
#import "JRCaptureInternal.h"
#import "JRCaptureObject.h"
#import "JRActivityObject.h"
#import "JRCaptureUser.h"
#import "JREngageWrapper.h"

//@interface JRDate : NSDate
//+ (JRDate *)dateFromISO8601DateString:(NSString *)dateString;
//- (NSString *)stringFromISO8601Date;
//@end
//
//@interface JRDateTime : NSDate
//+ (JRDateTime *)dateFromISO8601DateTimeString:(NSString *)dateTimeString;
//- (NSString *)stringFromISO8601DateTime;
//@end

@interface NSDate (CaptureDateTime)
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString;
+ (NSDate *)dateFromISO8601DateTimeString:(NSString *)dateTimeString;
- (NSString *)stringFromISO8601Date;
- (NSString *)stringFromISO8601DateTime;
@end

typedef enum
{
    JRCaptureApidError_foo = 400,
} JRCaptureApidError;

typedef enum
{
    JRCaptureWrappedEngageError_foo = 500,
} JRCaptureWrappedEngageError;

typedef enum
{
    JRCaptureWebviewError_foo = 500,
} JRCaptureWebviewError;

//typedef enum
//{
//    JRNativeSigninNone = 0,
//    JRNativeSigninUsernamePassword,
//    JRNativeSigninEmailPassword,
//} JRNativeSigninState;

@protocol JRCaptureAuthenticationDelegate;
@protocol JRCaptureSocialSharingDelegate;
@interface JRCapture : NSObject

+ (void)setCaptureApiDomain:(NSString *)newCaptureApidDomain captureUIDomain:(NSString *)newCaptureUIDomain
                   clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName;
+ (void)setEngageAppId:(NSString *)appId;

+ (void)setEngageAppId:(NSString *)appId captureApiDomain:(NSString *)newCaptureApidDomain
       captureUIDomain:(NSString *)newCaptureUIDomain clientId:(NSString *)newClientId
     andEntityTypeName:(NSString *)newEntityTypeName;

+ (NSString *)captureMobileEndpointUrl;
+ (void)setAccessToken:(NSString *)newAccessToken;
+ (void)setCreationToken:(NSString *)newCreationToken;


/**
 * @name Show the JREngage Dialogs
 * Methods that display JREngage's dialogs to initiate authentication and social publishing
 **/
/*@{*/

/**
 * Use this function to begin authentication.  The JREngage library will
 * pop up a modal dialog and take the user through the sign-in process.
 **/
+ (void)startAuthenticationForDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

+ (void)startAuthenticationWithNativeSignin:(JRNativeSigninState)nativeSigninState
                                forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

/**
 * Use this function to begin authentication for one specific provider.  The JREngage library will
 * pop up a modal dialog, skipping the list of providers, and take the user straight to the sign-in
 * flow of the passed provider.  The user will not be able to return to the list of providers.
 *
 * @param provider
 *   The name of the provider on which the user will authenticate.  For a list of possible strings,
 *   please see the \ref basicProviders "List of Providers"
 **/
+ (void)startAuthenticationDialogOnProvider:(NSString*)provider
                                forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

/**
 * Use this function to begin authentication.  The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, and take the user through the sign-in process.
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)startAuthenticationDialogWithNativeSignin:(JRNativeSigninState)nativeSigninState
                      andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                      forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

/**
* Use this function to begin authentication.  The JREngage library will pop up a modal dialog, configured
* with the given custom interface and skipping the list of providers, and take the user straight to the sign-in
* flow of the passed provider.  The user will not be able to return to the list of providers.
*
* @param provider
*   The name of the provider on which the user will authenticate.  For a list of possible strings,
*   please see the \ref basicProviders "List of Providers"
*
* @param customInterfaceOverrides
*   A dictionary of objects and properties, indexed by the set of
*   \link customInterface pre-defined custom interface keys\endlink,
*   to be used by the library to customize the look and feel of the user
*   interface and/or add a native login experience
*
* @note
* Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
* values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
**/
+ (void)startAuthenticationDialogOnProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

/**
 * Use this function to begin social publishing. The JREngage library will pop up a modal dialog and
 * take the user through the sign-in process, if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 **/
+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject*)activity
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;

/**
 * Use this function to begin social publishing.  The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, take the user through the sign-in process,
 * if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject*)activity
                   withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;

@end
