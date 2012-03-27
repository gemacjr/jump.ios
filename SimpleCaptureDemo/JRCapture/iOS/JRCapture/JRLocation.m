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


#import "JRLocation.h"

@implementation JRLocation
{
    NSString *_country;
    NSString *_extendedAddress;
    NSString *_formatted;
    NSNumber *_latitude;
    NSString *_locality;
    NSNumber *_longitude;
    NSString *_poBox;
    NSString *_postalCode;
    NSString *_region;
    NSString *_streetAddress;
    NSString *_type;

}
@dynamic country;
@dynamic extendedAddress;
@dynamic formatted;
@dynamic latitude;
@dynamic locality;
@dynamic longitude;
@dynamic poBox;
@dynamic postalCode;
@dynamic region;
@dynamic streetAddress;
@dynamic type;

- (NSString *)country
{
    return _country;
}

- (void)setCountry:(NSString *)newCountry
{
    [self.dirtyPropertySet addObject:@"country"];

    _country = [newCountry copy];
}

- (NSString *)extendedAddress
{
    return _extendedAddress;
}

- (void)setExtendedAddress:(NSString *)newExtendedAddress
{
    [self.dirtyPropertySet addObject:@"extendedAddress"];

    _extendedAddress = [newExtendedAddress copy];
}

- (NSString *)formatted
{
    return _formatted;
}

- (void)setFormatted:(NSString *)newFormatted
{
    [self.dirtyPropertySet addObject:@"formatted"];

    _formatted = [newFormatted copy];
}

- (NSNumber *)latitude
{
    return _latitude;
}

- (void)setLatitude:(NSNumber *)newLatitude
{
    [self.dirtyPropertySet addObject:@"latitude"];

    _latitude = [newLatitude copy];
}

- (NSString *)locality
{
    return _locality;
}

- (void)setLocality:(NSString *)newLocality
{
    [self.dirtyPropertySet addObject:@"locality"];

    _locality = [newLocality copy];
}

- (NSNumber *)longitude
{
    return _longitude;
}

- (void)setLongitude:(NSNumber *)newLongitude
{
    [self.dirtyPropertySet addObject:@"longitude"];

    _longitude = [newLongitude copy];
}

- (NSString *)poBox
{
    return _poBox;
}

- (void)setPoBox:(NSString *)newPoBox
{
    [self.dirtyPropertySet addObject:@"poBox"];

    _poBox = [newPoBox copy];
}

- (NSString *)postalCode
{
    return _postalCode;
}

- (void)setPostalCode:(NSString *)newPostalCode
{
    [self.dirtyPropertySet addObject:@"postalCode"];

    _postalCode = [newPostalCode copy];
}

- (NSString *)region
{
    return _region;
}

- (void)setRegion:(NSString *)newRegion
{
    [self.dirtyPropertySet addObject:@"region"];

    _region = [newRegion copy];
}

- (NSString *)streetAddress
{
    return _streetAddress;
}

- (void)setStreetAddress:(NSString *)newStreetAddress
{
    [self.dirtyPropertySet addObject:@"streetAddress"];

    _streetAddress = [newStreetAddress copy];
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
        self.captureObjectPath = @"/profiles/profile/organizations/location";
    }
    return self;
}

+ (id)location
{
    return [[[JRLocation alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLocation *locationCopy =
                [[JRLocation allocWithZone:zone] init];

    locationCopy.country = self.country;
    locationCopy.extendedAddress = self.extendedAddress;
    locationCopy.formatted = self.formatted;
    locationCopy.latitude = self.latitude;
    locationCopy.locality = self.locality;
    locationCopy.longitude = self.longitude;
    locationCopy.poBox = self.poBox;
    locationCopy.postalCode = self.postalCode;
    locationCopy.region = self.region;
    locationCopy.streetAddress = self.streetAddress;
    locationCopy.type = self.type;

    return locationCopy;
}

+ (id)locationObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLocation *location =
        [JRLocation location];

    location.country = [dictionary objectForKey:@"country"];
    location.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    location.formatted = [dictionary objectForKey:@"formatted"];
    location.latitude = [dictionary objectForKey:@"latitude"];
    location.locality = [dictionary objectForKey:@"locality"];
    location.longitude = [dictionary objectForKey:@"longitude"];
    location.poBox = [dictionary objectForKey:@"poBox"];
    location.postalCode = [dictionary objectForKey:@"postalCode"];
    location.region = [dictionary objectForKey:@"region"];
    location.streetAddress = [dictionary objectForKey:@"streetAddress"];
    location.type = [dictionary objectForKey:@"type"];

    return location;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.country)
        [dict setObject:self.country forKey:@"country"];

    if (self.extendedAddress)
        [dict setObject:self.extendedAddress forKey:@"extendedAddress"];

    if (self.formatted)
        [dict setObject:self.formatted forKey:@"formatted"];

    if (self.latitude)
        [dict setObject:self.latitude forKey:@"latitude"];

    if (self.locality)
        [dict setObject:self.locality forKey:@"locality"];

    if (self.longitude)
        [dict setObject:self.longitude forKey:@"longitude"];

    if (self.poBox)
        [dict setObject:self.poBox forKey:@"poBox"];

    if (self.postalCode)
        [dict setObject:self.postalCode forKey:@"postalCode"];

    if (self.region)
        [dict setObject:self.region forKey:@"region"];

    if (self.streetAddress)
        [dict setObject:self.streetAddress forKey:@"streetAddress"];

    if (self.type)
        [dict setObject:self.type forKey:@"type"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"country"])
        self.country = [dictionary objectForKey:@"country"];

    if ([dictionary objectForKey:@"extendedAddress"])
        self.extendedAddress = [dictionary objectForKey:@"extendedAddress"];

    if ([dictionary objectForKey:@"formatted"])
        self.formatted = [dictionary objectForKey:@"formatted"];

    if ([dictionary objectForKey:@"latitude"])
        self.latitude = [dictionary objectForKey:@"latitude"];

    if ([dictionary objectForKey:@"locality"])
        self.locality = [dictionary objectForKey:@"locality"];

    if ([dictionary objectForKey:@"longitude"])
        self.longitude = [dictionary objectForKey:@"longitude"];

    if ([dictionary objectForKey:@"poBox"])
        self.poBox = [dictionary objectForKey:@"poBox"];

    if ([dictionary objectForKey:@"postalCode"])
        self.postalCode = [dictionary objectForKey:@"postalCode"];

    if ([dictionary objectForKey:@"region"])
        self.region = [dictionary objectForKey:@"region"];

    if ([dictionary objectForKey:@"streetAddress"])
        self.streetAddress = [dictionary objectForKey:@"streetAddress"];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];
}

- (void)dealloc
{
    [_country release];
    [_extendedAddress release];
    [_formatted release];
    [_latitude release];
    [_locality release];
    [_longitude release];
    [_poBox release];
    [_postalCode release];
    [_region release];
    [_streetAddress release];
    [_type release];

    [super dealloc];
}
@end
