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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JROrganizations.h"

@implementation JROrganizations
{
    JRObjectId *_organizationsId;
    NSString *_department;
    NSString *_description;
    NSString *_endDate;
    JRLocation *_location;
    NSString *_name;
    JRBoolean *_primary;
    NSString *_startDate;
    NSString *_title;
    NSString *_type;
}
@dynamic organizationsId;
@dynamic department;
@dynamic description;
@dynamic endDate;
@dynamic location;
@dynamic name;
@dynamic primary;
@dynamic startDate;
@dynamic title;
@dynamic type;

- (JRObjectId *)organizationsId
{
    return _organizationsId;
}

- (void)setOrganizationsId:(JRObjectId *)newOrganizationsId
{
    [self.dirtyPropertySet addObject:@"organizationsId"];
    _organizationsId = [newOrganizationsId copy];
}

- (NSString *)department
{
    return _department;
}

- (void)setDepartment:(NSString *)newDepartment
{
    [self.dirtyPropertySet addObject:@"department"];
    _department = [newDepartment copy];
}

- (NSString *)description
{
    return _description;
}

- (void)setDescription:(NSString *)newDescription
{
    [self.dirtyPropertySet addObject:@"description"];
    _description = [newDescription copy];
}

- (NSString *)endDate
{
    return _endDate;
}

- (void)setEndDate:(NSString *)newEndDate
{
    [self.dirtyPropertySet addObject:@"endDate"];
    _endDate = [newEndDate copy];
}

- (JRLocation *)location
{
    return _location;
}

- (void)setLocation:(JRLocation *)newLocation
{
    [self.dirtyPropertySet addObject:@"location"];
    _location = [newLocation copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];
    _name = [newName copy];
}

- (JRBoolean *)primary
{
    return _primary;
}

- (void)setPrimary:(JRBoolean *)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];
    _primary = [newPrimary copy];
}

- (BOOL)getPrimaryBoolValue
{
    return [_primary boolValue];
}

- (void)setPrimaryWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"primary"];
    _primary = [NSNumber numberWithBool:boolVal];
}

- (NSString *)startDate
{
    return _startDate;
}

- (void)setStartDate:(NSString *)newStartDate
{
    [self.dirtyPropertySet addObject:@"startDate"];
    _startDate = [newStartDate copy];
}

- (NSString *)title
{
    return _title;
}

- (void)setTitle:(NSString *)newTitle
{
    [self.dirtyPropertySet addObject:@"title"];
    _title = [newTitle copy];
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/organizations";
    }
    return self;
}

+ (id)organizations
{
    return [[[JROrganizations alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROrganizations *organizationsCopy =
                [[JROrganizations allocWithZone:zone] init];

    organizationsCopy.organizationsId = self.organizationsId;
    organizationsCopy.department = self.department;
    organizationsCopy.description = self.description;
    organizationsCopy.endDate = self.endDate;
    organizationsCopy.location = self.location;
    organizationsCopy.name = self.name;
    organizationsCopy.primary = self.primary;
    organizationsCopy.startDate = self.startDate;
    organizationsCopy.title = self.title;
    organizationsCopy.type = self.type;

    [organizationsCopy.dirtyPropertySet removeAllObjects];
    [organizationsCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return organizationsCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.organizationsId ? [NSNumber numberWithInteger:[self.organizationsId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.department ? self.department : [NSNull null])
             forKey:@"department"];
    [dict setObject:(self.description ? self.description : [NSNull null])
             forKey:@"description"];
    [dict setObject:(self.endDate ? self.endDate : [NSNull null])
             forKey:@"endDate"];
    [dict setObject:(self.location ? [self.location toDictionary] : [NSNull null])
             forKey:@"location"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
             forKey:@"primary"];
    [dict setObject:(self.startDate ? self.startDate : [NSNull null])
             forKey:@"startDate"];
    [dict setObject:(self.title ? self.title : [NSNull null])
             forKey:@"title"];
    [dict setObject:(self.type ? self.type : [NSNull null])
             forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)organizationsObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROrganizations *organizations = [JROrganizations organizations];
    organizations.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    organizations.organizationsId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    organizations.department =
        [dictionary objectForKey:@"department"] != [NSNull null] ? 
        [dictionary objectForKey:@"department"] : nil;

    organizations.description =
        [dictionary objectForKey:@"description"] != [NSNull null] ? 
        [dictionary objectForKey:@"description"] : nil;

    organizations.endDate =
        [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"endDate"] : nil;

    organizations.location =
        [dictionary objectForKey:@"location"] != [NSNull null] ? 
        [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"] withPath:organizations.captureObjectPath] : nil;

    organizations.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    organizations.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    organizations.startDate =
        [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"startDate"] : nil;

    organizations.title =
        [dictionary objectForKey:@"title"] != [NSNull null] ? 
        [dictionary objectForKey:@"title"] : nil;

    organizations.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [organizations.dirtyPropertySet removeAllObjects];
    
    return organizations;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.organizationsId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"department"])
        self.department = [dictionary objectForKey:@"department"] != [NSNull null] ? 
            [dictionary objectForKey:@"department"] : nil;

    if ([dictionary objectForKey:@"description"])
        self.description = [dictionary objectForKey:@"description"] != [NSNull null] ? 
            [dictionary objectForKey:@"description"] : nil;

    if ([dictionary objectForKey:@"endDate"])
        self.endDate = [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
            [dictionary objectForKey:@"endDate"] : nil;

    if ([dictionary objectForKey:@"location"])
        self.location = [dictionary objectForKey:@"location"] != [NSNull null] ? 
            [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"] withPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"primary"])
        self.primary = [dictionary objectForKey:@"primary"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    if ([dictionary objectForKey:@"startDate"])
        self.startDate = [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
            [dictionary objectForKey:@"startDate"] : nil;

    if ([dictionary objectForKey:@"title"])
        self.title = [dictionary objectForKey:@"title"] != [NSNull null] ? 
            [dictionary objectForKey:@"title"] : nil;

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"] != [NSNull null] ? 
            [dictionary objectForKey:@"type"] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.organizationsId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.department =
        [dictionary objectForKey:@"department"] != [NSNull null] ? 
        [dictionary objectForKey:@"department"] : nil;

    self.description =
        [dictionary objectForKey:@"description"] != [NSNull null] ? 
        [dictionary objectForKey:@"description"] : nil;

    self.endDate =
        [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"endDate"] : nil;

    self.location =
        [dictionary objectForKey:@"location"] != [NSNull null] ? 
        [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"] withPath:self.captureObjectPath] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.startDate =
        [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"startDate"] : nil;

    self.title =
        [dictionary objectForKey:@"title"] != [NSNull null] ? 
        [dictionary objectForKey:@"title"] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"department"])
        [dict setObject:(self.department ? self.department : [NSNull null]) forKey:@"department"];

    if ([self.dirtyPropertySet containsObject:@"description"])
        [dict setObject:(self.description ? self.description : [NSNull null]) forKey:@"description"];

    if ([self.dirtyPropertySet containsObject:@"endDate"])
        [dict setObject:(self.endDate ? self.endDate : [NSNull null]) forKey:@"endDate"];

    if ([self.dirtyPropertySet containsObject:@"location"])
        [dict setObject:(self.location ? [self.location toUpdateDictionary] : [NSNull null]) forKey:@"location"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"startDate"])
        [dict setObject:(self.startDate ? self.startDate : [NSNull null]) forKey:@"startDate"];

    if ([self.dirtyPropertySet containsObject:@"title"])
        [dict setObject:(self.title ? self.title : [NSNull null]) forKey:@"title"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:[self.organizationsId integerValue]
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.department ? self.department : [NSNull null]) forKey:@"department"];
    [dict setObject:(self.description ? self.description : [NSNull null]) forKey:@"description"];
    [dict setObject:(self.endDate ? self.endDate : [NSNull null]) forKey:@"endDate"];
    [dict setObject:(self.location ? [self.location toReplaceDictionary] : [NSNull null]) forKey:@"location"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dict setObject:(self.startDate ? self.startDate : [NSNull null]) forKey:@"startDate"];
    [dict setObject:(self.title ? self.title : [NSNull null]) forKey:@"title"];
    [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:[self.organizationsId integerValue]
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"organizationsId"];
    [dict setObject:@"NSString" forKey:@"department"];
    [dict setObject:@"NSString" forKey:@"description"];
    [dict setObject:@"NSString" forKey:@"endDate"];
    [dict setObject:@"JRLocation" forKey:@"location"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JRBoolean" forKey:@"primary"];
    [dict setObject:@"NSString" forKey:@"startDate"];
    [dict setObject:@"NSString" forKey:@"title"];
    [dict setObject:@"NSString" forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_organizationsId release];
    [_department release];
    [_description release];
    [_endDate release];
    [_location release];
    [_name release];
    [_primary release];
    [_startDate release];
    [_title release];
    [_type release];

    [super dealloc];
}
@end
