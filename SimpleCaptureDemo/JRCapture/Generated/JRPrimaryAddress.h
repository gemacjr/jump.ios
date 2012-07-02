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

/**
 * @brief A JRPrimaryAddress object
 **/
@interface JRPrimaryAddress : JRCaptureObject
@property (nonatomic, copy)     NSString *address1; /**< The object's \e address1 property */ 
@property (nonatomic, copy)     NSString *address2; /**< The object's \e address2 property */ 
@property (nonatomic, copy)     NSString *city; /**< The object's \e city property */ 
@property (nonatomic, copy)     NSString *company; /**< The object's \e company property */ 
@property (nonatomic, copy)     NSString *country; /**< The object's \e country property */ 
@property (nonatomic, copy)     NSString *mobile; /**< The object's \e mobile property */ 
@property (nonatomic, copy)     NSString *phone; /**< The object's \e phone property */ 
@property (nonatomic, copy)     NSString *stateAbbreviation; /**< The object's \e stateAbbreviation property */ 
@property (nonatomic, copy)     NSString *zip; /**< The object's \e zip property */ 
@property (nonatomic, copy)     NSString *zipPlus4; /**< The object's \e zipPlus4 property */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRPrimaryAddress object
 *
 * @return
 *   A JRPrimaryAddress object
 **/
- (id)init;

/**
 * Returns an empty JRPrimaryAddress object
 *
 * @return
 *   A JRPrimaryAddress object
 **/
+ (id)primaryAddress;

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
