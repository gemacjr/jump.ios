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


#import "JREmails.h"

@implementation JREmails
{
    NSInteger _emailsId;
    BOOL _primary;
    NSString *_type;
    NSString *_value;
}
@dynamic emailsId;
@dynamic primary;
@dynamic type;
@dynamic value;

- (NSInteger)emailsId
{
    return _emailsId;
}

- (void)setEmailsId:(NSInteger)newEmailsId
{
    [self.dirtyPropertySet addObject:@"emailsId"];

    _emailsId = newEmailsId;
}

- (BOOL)primary
{
    return _primary;
}

- (void)setPrimary:(BOOL)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];

    _primary = newPrimary;
}

- (NSString *)type
{
    return _type;
}

- (void)setType:(NSString *)newType
{
    [self.dirtyPropertySet addObject:@"type"];

    if (!newType)
        _type = [NSNull null];
    else
        _type = [newType copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];

    if (!newValue)
        _value = [NSNull null];
    else
        _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/emails";
    }
    return self;
}

+ (id)emails
{
    return [[[JREmails alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JREmails *emailsCopy =
                [[JREmails allocWithZone:zone] init];

    emailsCopy.emailsId = self.emailsId;
    emailsCopy.primary = self.primary;
    emailsCopy.type = self.type;
    emailsCopy.value = self.value;

    return emailsCopy;
}

+ (id)emailsObjectFromDictionary:(NSDictionary*)dictionary
{
    JREmails *emails =
        [JREmails emails];

    emails.emailsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    emails.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    emails.type = [dictionary objectForKey:@"type"];
    emails.value = [dictionary objectForKey:@"value"];

    return emails;
}

- (NSDictionary*)dictionaryFromEmailsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.emailsId)
        [dict setObject:[NSNumber numberWithInt:self.emailsId] forKey:@"id"];

    if (self.primary)
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if (self.type && self.type != [NSNull null])
        [dict setObject:self.type forKey:@"type"];
    else
        [dict setObject:[NSNull null] forKey:@"type"];

    if (self.value && self.value != [NSNull null])
        [dict setObject:self.value forKey:@"value"];
    else
        [dict setObject:[NSNull null] forKey:@"value"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _emailsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"primary"])
        _primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"type"])
        _type = [dictionary objectForKey:@"type"];

    if ([dictionary objectForKey:@"value"])
        _value = [dictionary objectForKey:@"value"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _emailsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    _type = [dictionary objectForKey:@"type"];
    _value = [dictionary objectForKey:@"value"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"emailsId"])
        [dict setObject:[NSNumber numberWithInt:self.emailsId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:self.type forKey:@"type"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:self.value forKey:@"value"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.emailsId] forKey:@"id"];
    [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:self.value forKey:@"value"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:0
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_type release];
    [_value release];

    [super dealloc];
}
@end
