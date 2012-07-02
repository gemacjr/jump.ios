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
 * @brief A JRLocation object
 **/
@interface JRLocation : JRCaptureObject
@property (nonatomic, copy)     NSString *country; /**< The object's \e country property */ 
@property (nonatomic, copy)     NSString *extendedAddress; /**< The object's \e extendedAddress property */ 
@property (nonatomic, copy)     NSString *formatted; /**< The object's \e formatted property */ 
@property (nonatomic, copy)     NSNumber *latitude; /**< The object's \e latitude property */ 
@property (nonatomic, copy)     NSString *locality; /**< The object's \e locality property */ 
@property (nonatomic, copy)     NSNumber *longitude; /**< The object's \e longitude property */ 
@property (nonatomic, copy)     NSString *poBox; /**< The object's \e poBox property */ 
@property (nonatomic, copy)     NSString *postalCode; /**< The object's \e postalCode property */ 
@property (nonatomic, copy)     NSString *region; /**< The object's \e region property */ 
@property (nonatomic, copy)     NSString *streetAddress; /**< The object's \e streetAddress property */ 
@property (nonatomic, copy)     NSString *type; /**< The object's \e type property */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRLocation object
 *
 * @return
 *   A JRLocation object
 **/
- (id)init;

/**
 * Returns an empty JRLocation object
 *
 * @return
 *   A JRLocation object
 **/
+ (id)location;

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
