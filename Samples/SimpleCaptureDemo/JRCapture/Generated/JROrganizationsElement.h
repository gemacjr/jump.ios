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
#import "JRLocation.h"

/**
 * @brief Describes a current or past organizational affiliation of this contact.
 **/
@interface JROrganizationsElement : JRCaptureObject
@property (nonatomic, readonly) JRObjectId *organizationsElementId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy)     NSString *department; /**< The department within this organization. */ 
@property (nonatomic, copy)     NSString *description; /**< A textual description of the role this Contact played in this organization. */ 
@property (nonatomic, copy)     NSString *endDate; /**< The date this Contact left this organization or the role specified by title within this organization. */ 
@property (nonatomic, retain)   JRLocation *location; /**< The object's \e location property */ 
@property (nonatomic, copy)     NSString *name; /**< The name of the organization. */ 
@property (nonatomic, copy)     JRBoolean *primary; /**< The object's \e primary property @note This is a property of type \ref types "boolean", which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *startDate; /**< The date this Contact joined this organization. */ 
@property (nonatomic, copy)     NSString *title; /**< The job title or role within this organization. */ 
@property (nonatomic, copy)     NSString *type; /**< The type of organization, with Canonical Values 'job' and 'school'. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JROrganizationsElement object
 *
 * @return
 *   A JROrganizationsElement object
 **/
- (id)init;

/**
 * Returns an empty JROrganizationsElement object
 *
 * @return
 *   A JROrganizationsElement object
 **/
+ (id)organizationsElement;

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

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * TODO
 **/
- (BOOL)getPrimaryBoolValue;

/**
 * TODO
 **/
- (void)setPrimaryWithBool:(BOOL)boolVal;
/*@}*/

@end
