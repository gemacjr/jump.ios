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

    if (self.department)
        [dict setObject:self.department forKey:@"department"];

    if (self.description)
        [dict setObject:self.description forKey:@"description"];

    if (self.endDate)
        [dict setObject:self.endDate forKey:@"endDate"];

    if (self.location)
        [dict setObject:[self.location dictionaryFromLocationObject] forKey:@"location"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    if (self.primary)
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if (self.startDate)
        [dict setObject:self.startDate forKey:@"startDate"];

    if (self.title)
        [dict setObject:self.title forKey:@"title"];

    if (self.type)
        [dict setObject:self.type forKey:@"type"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"department"])
        self.department = [dictionary objectForKey:@"department"];

    if ([dictionary objectForKey:@"description"])
        self.description = [dictionary objectForKey:@"description"];

    if ([dictionary objectForKey:@"endDate"])
        self.endDate = [dictionary objectForKey:@"endDate"];

    if ([dictionary objectForKey:@"location"])
        self.location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"startDate"])
        self.startDate = [dictionary objectForKey:@"startDate"];

    if ([dictionary objectForKey:@"title"])
        self.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.organizationsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.department = [dictionary objectForKey:@"department"];
    self.description = [dictionary objectForKey:@"description"];
    self.endDate = [dictionary objectForKey:@"endDate"];
    self.location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];
    self.name = [dictionary objectForKey:@"name"];
    self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    self.startDate = [dictionary objectForKey:@"startDate"];
    self.title = [dictionary objectForKey:@"title"];
    self.type = [dictionary objectForKey:@"type"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

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
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.organizationsId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

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
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.organizationsId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
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
