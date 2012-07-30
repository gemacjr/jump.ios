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
 * @brief A list of the tournaments in which the player has competed
 **/
@interface JRTournamentsPlayedElement : JRCaptureObject
@property (nonatomic, readonly) JRObjectId *tournamentsPlayedElementId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy)     JRDecimal *moneyWon; /**< The amount of money won, if any */ 
@property (nonatomic, copy)     JRInteger *placed; /**< Where the player placed in the tournament @note This is a property of type \ref types "integer", which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     JRDateTime *tournamentDate; /**< The date and time that the tournament started @note This is a property of type \ref types "dateTime", which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRBoolean *wonMoney; /**< Whether or not the player won any money @note This is a property of type \ref types "boolean", which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRTournamentsPlayedElement object
 *
 * @return
 *   A JRTournamentsPlayedElement object
 **/
- (id)init;

/**
 * Returns an empty JRTournamentsPlayedElement object
 *
 * @return
 *   A JRTournamentsPlayedElement object
 **/
+ (id)tournamentsPlayedElement;

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
- (BOOL)getWonMoneyBoolValue;

/**
 * TODO
 **/
- (void)setWonMoneyWithBool:(BOOL)boolVal;

/**
 * TODO
 **/
- (NSInteger)getPlacedIntegerValue;

/**
 * TODO
 **/
- (void)setPlacedWithInteger:(NSInteger)integerVal;
/*@}*/

@end
