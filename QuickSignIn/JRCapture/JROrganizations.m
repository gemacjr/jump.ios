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
@synthesize department;
@synthesize description;
@synthesize endDate;
@synthesize location;
@synthesize name;
@synthesize primary;
@synthesize startDate;
@synthesize title;
@synthesize type;

- (id)init
{
    if ((self = [super init]))
    {
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

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (department)
        [dict setObject:department forKey:@"department"];

    if (description)
        [dict setObject:description forKey:@"description"];

    if (endDate)
        [dict setObject:endDate forKey:@"endDate"];

    if (location)
        [dict setObject:[location dictionaryFromObject] forKey:@"location"];

    if (name)
        [dict setObject:name forKey:@"name"];

    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

    if (startDate)
        [dict setObject:startDate forKey:@"startDate"];

    if (title)
        [dict setObject:title forKey:@"title"];

    if (type)
        [dict setObject:type forKey:@"type"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
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

- (void)dealloc
{
    [department release];
    [description release];
    [endDate release];
    [location release];
    [name release];
    [startDate release];
    [title release];
    [type release];

    [super dealloc];
}
@end
