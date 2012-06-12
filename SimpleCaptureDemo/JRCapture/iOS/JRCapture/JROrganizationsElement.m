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


#import "JROrganizationsElement.h"

@interface JROrganizationsElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROrganizationsElement
{
    JRObjectId *_organizationsElementId;
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
@dynamic organizationsElementId;
@dynamic department;
@dynamic description;
@dynamic endDate;
@dynamic location;
@dynamic name;
@dynamic primary;
@dynamic startDate;
@dynamic title;
@dynamic type;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)organizationsElementId
{
    return _organizationsElementId;
}

- (void)setOrganizationsElementId:(JRObjectId *)newOrganizationsElementId
{
    [self.dirtyPropertySet addObject:@"organizationsElementId"];
    _organizationsElementId = [newOrganizationsElementId copy];
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
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)organizationsElement
{
    return [[[JROrganizationsElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROrganizationsElement *organizationsElementCopy =
                [[JROrganizationsElement allocWithZone:zone] init];

    organizationsElementCopy.captureObjectPath = self.captureObjectPath;

    organizationsElementCopy.organizationsElementId = self.organizationsElementId;
    organizationsElementCopy.department = self.department;
    organizationsElementCopy.description = self.description;
    organizationsElementCopy.endDate = self.endDate;
    organizationsElementCopy.location = self.location;
    organizationsElementCopy.name = self.name;
    organizationsElementCopy.primary = self.primary;
    organizationsElementCopy.startDate = self.startDate;
    organizationsElementCopy.title = self.title;
    organizationsElementCopy.type = self.type;
    // TODO: Necessary??
    organizationsElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [organizationsElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [organizationsElementCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return organizationsElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.organizationsElementId ? [NSNumber numberWithInteger:[self.organizationsElementId integerValue]] : [NSNull null])
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

+ (id)organizationsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROrganizationsElement *organizationsElement = [JROrganizationsElement organizationsElement];

    organizationsElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    organizationsElement.canBeUpdatedOrReplaced = YES;

    organizationsElement.organizationsElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    organizationsElement.department =
        [dictionary objectForKey:@"department"] != [NSNull null] ? 
        [dictionary objectForKey:@"department"] : nil;

    organizationsElement.description =
        [dictionary objectForKey:@"description"] != [NSNull null] ? 
        [dictionary objectForKey:@"description"] : nil;

    organizationsElement.endDate =
        [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"endDate"] : nil;

    organizationsElement.location =
        [dictionary objectForKey:@"location"] != [NSNull null] ? 
        [JRLocation locationObjectFromDictionary:[dictionary objectForKey:@"location"] withPath:organizationsElement.captureObjectPath] : nil;

    organizationsElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    organizationsElement.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    organizationsElement.startDate =
        [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"startDate"] : nil;

    organizationsElement.title =
        [dictionary objectForKey:@"title"] != [NSNull null] ? 
        [dictionary objectForKey:@"title"] : nil;

    organizationsElement.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [organizationsElement.dirtyPropertySet removeAllObjects];
    [organizationsElement.dirtyArraySet removeAllObjects];
    
    return organizationsElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.organizationsElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
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

    if ([dictionary objectForKey:@"location"] == [NSNull null])
        self.location = nil;
    else if ([dictionary objectForKey:@"location"] && !self.location)
        self.location = [JRLocation locationObjectFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"location"])
        [self.location updateFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath];

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

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"organizations", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.organizationsElementId =
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

    if (![dictionary objectForKey:@"location"] || [dictionary objectForKey:@"location"] == [NSNull null])
        self.location = nil;
    else if (!self.location)
        self.location = [JRLocation locationObjectFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath];
    else
        [self.location replaceFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath];

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

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
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

    if ([self.dirtyPropertySet containsObject:@"location"] || [self.location needsUpdate])
        [dict setObject:(self.location ?
                              [self.location toUpdateDictionary] :
                              [[JRLocation location] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"location"];

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

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.department ? self.department : [NSNull null]) forKey:@"department"];
    [dict setObject:(self.description ? self.description : [NSNull null]) forKey:@"description"];
    [dict setObject:(self.endDate ? self.endDate : [NSNull null]) forKey:@"endDate"];
    [dict setObject:(self.location ?
                          [self.location toReplaceDictionary] :
                          [[JRLocation location] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"location"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dict setObject:(self.startDate ? self.startDate : [NSNull null]) forKey:@"startDate"];
    [dict setObject:(self.title ? self.title : [NSNull null]) forKey:@"title"];
    [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.location needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOrganizationsElement:(JROrganizationsElement *)otherOrganizationsElement
{
    if ((self.department == nil) ^ (otherOrganizationsElement.department == nil)) // xor
        return NO;

    if (![self.department isEqualToString:otherOrganizationsElement.department])
        return NO;

    if ((self.description == nil) ^ (otherOrganizationsElement.description == nil)) // xor
        return NO;

    if (![self.description isEqualToString:otherOrganizationsElement.description])
        return NO;

    if ((self.endDate == nil) ^ (otherOrganizationsElement.endDate == nil)) // xor
        return NO;

    if (![self.endDate isEqualToString:otherOrganizationsElement.endDate])
        return NO;

    if (!self.location && !otherOrganizationsElement.location) /* Keep going... */;
    else if (!self.location && [otherOrganizationsElement.location isEqualToLocation:[JRLocation location]]) /* Keep going... */;
    else if (!otherOrganizationsElement.location && [self.location isEqualToLocation:[JRLocation location]]) /* Keep going... */;
    else if (![self.location isEqualToLocation:otherOrganizationsElement.location]) return NO;

    if ((self.name == nil) ^ (otherOrganizationsElement.name == nil)) // xor
        return NO;

    if (![self.name isEqualToString:otherOrganizationsElement.name])
        return NO;

    if ((self.primary == nil) ^ (otherOrganizationsElement.primary == nil)) // xor
        return NO;

    if (![self.primary isEqualToNumber:otherOrganizationsElement.primary])
        return NO;

    if ((self.startDate == nil) ^ (otherOrganizationsElement.startDate == nil)) // xor
        return NO;

    if (![self.startDate isEqualToString:otherOrganizationsElement.startDate])
        return NO;

    if ((self.title == nil) ^ (otherOrganizationsElement.title == nil)) // xor
        return NO;

    if (![self.title isEqualToString:otherOrganizationsElement.title])
        return NO;

    if ((self.type == nil) ^ (otherOrganizationsElement.type == nil)) // xor
        return NO;

    if (![self.type isEqualToString:otherOrganizationsElement.type])
        return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"organizationsElementId"];
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
    [_organizationsElementId release];
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
