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


#import "JROrganizations.h"

@implementation JROrganizations
{
    NSInteger _organizationsId;
    NSString *_department;
    NSString *_description;
    NSString *_endDate;
    JRLocation *_location;
    NSString *_name;
    BOOL _primary;
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

- (NSInteger)organizationsId
{
    return _organizationsId;
}

- (void)setOrganizationsId:(NSInteger)newOrganizationsId
{
    [self.dirtyPropertySet addObject:@"organizationsId"];

    _organizationsId = newOrganizationsId;
}

- (NSString *)department
{
    return _department;
}

- (void)setDepartment:(NSString *)newDepartment
{
    [self.dirtyPropertySet addObject:@"department"];

    if (!newDepartment)
        _department = [NSNull null];
    else
        _department = [newDepartment copy];
}

- (NSString *)description
{
    return _description;
}

- (void)setDescription:(NSString *)newDescription
{
    [self.dirtyPropertySet addObject:@"description"];

    if (!newDescription)
        _description = [NSNull null];
    else
        _description = [newDescription copy];
}

- (NSString *)endDate
{
    return _endDate;
}

- (void)setEndDate:(NSString *)newEndDate
{
    [self.dirtyPropertySet addObject:@"endDate"];

    if (!newEndDate)
        _endDate = [NSNull null];
    else
        _endDate = [newEndDate copy];
}

- (JRLocation *)location
{
    return _location;
}

- (void)setLocation:(JRLocation *)newLocation
{
    [self.dirtyPropertySet addObject:@"location"];

    if (!newLocation)
        _location = [NSNull null];
    else
        _location = [newLocation copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    if (!newName)
        _name = [NSNull null];
    else
        _name = [newName copy];
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

- (NSString *)startDate
{
    return _startDate;
}

- (void)setStartDate:(NSString *)newStartDate
{
    [self.dirtyPropertySet addObject:@"startDate"];

    if (!newStartDate)
        _startDate = [NSNull null];
    else
        _startDate = [newStartDate copy];
}

- (NSString *)title
{
    return _title;
}

- (void)setTitle:(NSString *)newTitle
{
    [self.dirtyPropertySet addObject:@"title"];

    if (!newTitle)
        _title = [NSNull null];
    else
        _title = [newTitle copy];
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
{
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

    return organizationsCopy;
}

+ (id)organizationsObjectFromDictionary:(NSDictionary*)dictionary
{
    JROrganizations *organizations =
        [JROrganizations organizations];

    organizations.organizationsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    organizations.department = [dictionary objectForKey:@"department"];
    organizations.description = [dictionary objectForKey:@"description"];
    organizations.endDate = [dictionary objectForKey:@"endDate"];
    organizations.location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];
    organizations.name = [dictionary objectForKey:@"name"];
    organizations.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    organizations.startDate = [dictionary objectForKey:@"startDate"];
    organizations.title = [dictionary objectForKey:@"title"];
    organizations.type = [dictionary objectForKey:@"type"];

    return organizations;
}

- (NSDictionary*)dictionaryFromOrganizationsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.organizationsId)
        [dict setObject:[NSNumber numberWithInt:self.organizationsId] forKey:@"id"];

    if (self.department && self.department != [NSNull null])
        [dict setObject:self.department forKey:@"department"];
    else
        [dict setObject:[NSNull null] forKey:@"department"];

    if (self.description && self.description != [NSNull null])
        [dict setObject:self.description forKey:@"description"];
    else
        [dict setObject:[NSNull null] forKey:@"description"];

    if (self.endDate && self.endDate != [NSNull null])
        [dict setObject:self.endDate forKey:@"endDate"];
    else
        [dict setObject:[NSNull null] forKey:@"endDate"];

    if (self.location && self.location != [NSNull null])
        [dict setObject:[self.location dictionaryFromLocationObject] forKey:@"location"];
    else
        [dict setObject:[NSNull null] forKey:@"location"];

    if (self.name && self.name != [NSNull null])
        [dict setObject:self.name forKey:@"name"];
    else
        [dict setObject:[NSNull null] forKey:@"name"];

    if (self.primary)
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if (self.startDate && self.startDate != [NSNull null])
        [dict setObject:self.startDate forKey:@"startDate"];
    else
        [dict setObject:[NSNull null] forKey:@"startDate"];

    if (self.title && self.title != [NSNull null])
        [dict setObject:self.title forKey:@"title"];
    else
        [dict setObject:[NSNull null] forKey:@"title"];

    if (self.type && self.type != [NSNull null])
        [dict setObject:self.type forKey:@"type"];
    else
        [dict setObject:[NSNull null] forKey:@"type"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _organizationsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"department"])
        _department = [dictionary objectForKey:@"department"];

    if ([dictionary objectForKey:@"description"])
        _description = [dictionary objectForKey:@"description"];

    if ([dictionary objectForKey:@"endDate"])
        _endDate = [dictionary objectForKey:@"endDate"];

    if ([dictionary objectForKey:@"location"])
        _location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"primary"])
        _primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"startDate"])
        _startDate = [dictionary objectForKey:@"startDate"];

    if ([dictionary objectForKey:@"title"])
        _title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"type"])
        _type = [dictionary objectForKey:@"type"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _organizationsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _department = [dictionary objectForKey:@"department"];
    _description = [dictionary objectForKey:@"description"];
    _endDate = [dictionary objectForKey:@"endDate"];
    _location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];
    _name = [dictionary objectForKey:@"name"];
    _primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    _startDate = [dictionary objectForKey:@"startDate"];
    _title = [dictionary objectForKey:@"title"];
    _type = [dictionary objectForKey:@"type"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"organizationsId"])
        [dict setObject:[NSNumber numberWithInt:self.organizationsId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"department"])
        [dict setObject:self.department forKey:@"department"];

    if ([self.dirtyPropertySet containsObject:@"description"])
        [dict setObject:self.description forKey:@"description"];

    if ([self.dirtyPropertySet containsObject:@"endDate"])
        [dict setObject:self.endDate forKey:@"endDate"];

    if ([self.dirtyPropertySet containsObject:@"location"])
        [dict setObject:[self.location dictionaryFromLocationObject] forKey:@"location"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"startDate"])
        [dict setObject:self.startDate forKey:@"startDate"];

    if ([self.dirtyPropertySet containsObject:@"title"])
        [dict setObject:self.title forKey:@"title"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:self.type forKey:@"type"];

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

    [dict setObject:[NSNumber numberWithInt:self.organizationsId] forKey:@"id"];
    [dict setObject:self.department forKey:@"department"];
    [dict setObject:self.description forKey:@"description"];
    [dict setObject:self.endDate forKey:@"endDate"];
    [dict setObject:[self.location dictionaryFromLocationObject] forKey:@"location"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];
    [dict setObject:self.startDate forKey:@"startDate"];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.type forKey:@"type"];

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
    [_department release];
    [_description release];
    [_endDate release];
    [_location release];
    [_name release];
    [_startDate release];
    [_title release];
    [_type release];

    [super dealloc];
}
@end
