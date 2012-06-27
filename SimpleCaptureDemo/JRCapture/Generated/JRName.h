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
#import "NSDate+ISO8601_CaptureDateTimeString.h"

/**
 * @brief A JRName object
 **/
@interface JRName : JRCaptureObject
@property (nonatomic, copy)   NSString *familyName; /**< The family name of this Contact, or 'Last Name' in most Western languages */ 
@property (nonatomic, copy)   NSString *formatted; /**< The full name, including all middle names, titles, and suffixes as appropriate, formatted for display */ 
@property (nonatomic, copy)   NSString *givenName; /**< The given name of this Contact, or 'First Name' in most Western languages */ 
@property (nonatomic, copy)   NSString *honorificPrefix; /**< The honorific prefix(es) of this Contact, or 'Title' in most Western languages */ 
@property (nonatomic, copy)   NSString *honorificSuffix; /**< The honorifix suffix(es) of this Contact, or 'Suffix' in most Western languages */ 
@property (nonatomic, copy)   NSString *middleName; /**< The middle name(s) of this Contact */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRName object
 *
 * @return
 *   A JRName object
 **/
- (id)init;

/**
 * Returns an empty JRName object
 *
 * @return
 *   A JRName object
 **/
+ (id)name;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: Doxygen doc
 **/
- (BOOL)needsUpdate;
/*@}*/

@end
