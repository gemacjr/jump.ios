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


#import "JRUrls.h"

@implementation JRUrls
{
    NSInteger _urlsId;
    BOOL _primary;
    NSString *_type;
    NSString *_value;
}
@dynamic urlsId;
@dynamic primary;
@dynamic type;
@dynamic value;

- (NSInteger)urlsId
{
    return _urlsId;
}

- (void)setUrlsId:(NSInteger)newUrlsId
{
    [self.dirtyPropertySet addObject:@"urlsId"];
    _urlsId = newUrlsId;
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
    _type = [newType copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];
    _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/urls";
    }
    return self;
}

+ (id)urls
{
    return [[[JRUrls alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRUrls *urlsCopy =
                [[JRUrls allocWithZone:zone] init];

    urlsCopy.urlsId = self.urlsId;
    urlsCopy.primary = self.primary;
    urlsCopy.type = self.type;
    urlsCopy.value = self.value;

    [urlsCopy.dirtyPropertySet removeAllObjects];
    [urlsCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return urlsCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.urlsId]
             forKey:@"id"];
    [dict setObject:[NSNumber numberWithBool:self.primary]
             forKey:@"primary"];
    [dict setObject:(self.type ? self.type : [NSNull null])
             forKey:@"type"];
    [dict setObject:(self.value ? self.value : [NSNull null])
             forKey:@"value"];

    return dict;
}

+ (id)urlsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRUrls *urls = [JRUrls urls];

    urls.urlsId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    urls.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue] : 0;

    urls.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    urls.value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;

    [urls.dirtyPropertySet removeAllObjects];
    
    return urls;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _urlsId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    if ([dictionary objectForKey:@"primary"])
        _primary = [dictionary objectForKey:@"primary"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue] : 0;

    if ([dictionary objectForKey:@"type"])
        _type = [dictionary objectForKey:@"type"] != [NSNull null] ? 
            [dictionary objectForKey:@"type"] : nil;

    if ([dictionary objectForKey:@"value"])
        _value = [dictionary objectForKey:@"value"] != [NSNull null] ? 
            [dictionary objectForKey:@"value"] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary
{
    _urlsId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    _primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue] : 0;

    _type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    _value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:(self.primary ? [NSNumber numberWithBool:self.primary] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:_urlsId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.primary ? [NSNumber numberWithBool:self.primary] : [NSNull null]) forKey:@"primary"];
    [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];
    [dict setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:_urlsId
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
