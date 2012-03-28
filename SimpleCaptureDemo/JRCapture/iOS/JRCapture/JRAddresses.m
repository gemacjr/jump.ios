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


#import "JRAddresses.h"

@implementation JRAddresses
{
    NSInteger _addressesId;
    NSString *_country;
    NSString *_extendedAddress;
    NSString *_formatted;
    NSNumber *_latitude;
    NSString *_locality;
    NSNumber *_longitude;
    NSString *_poBox;
    NSString *_postalCode;
    BOOL _primary;
    NSString *_region;
    NSString *_streetAddress;
    NSString *_type;
}
@dynamic addressesId;
@dynamic country;
@dynamic extendedAddress;
@dynamic formatted;
@dynamic latitude;
@dynamic locality;
@dynamic longitude;
@dynamic poBox;
@dynamic postalCode;
@dynamic primary;
@dynamic region;
@dynamic streetAddress;
@dynamic type;

- (NSInteger)addressesId
{
    return _addressesId;
}

- (void)setAddressesId:(NSInteger)newAddressesId
{
    [self.dirtyPropertySet addObject:@"addressesId"];

    _addressesId = newAddressesId;
}

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

- (BOOL)primary
{
    return _primary;
}

- (void)setPrimary:(BOOL)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];

    _primary = newPrimary;
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
        self.captureObjectPath = @"/profiles/profile/addresses";
    }
    return self;
}

+ (id)addresses
{
    return [[[JRAddresses alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRAddresses *addressesCopy =
                [[JRAddresses allocWithZone:zone] init];

    addressesCopy.addressesId = self.addressesId;
    addressesCopy.country = self.country;
    addressesCopy.extendedAddress = self.extendedAddress;
    addressesCopy.formatted = self.formatted;
    addressesCopy.latitude = self.latitude;
    addressesCopy.locality = self.locality;
    addressesCopy.longitude = self.longitude;
    addressesCopy.poBox = self.poBox;
    addressesCopy.postalCode = self.postalCode;
    addressesCopy.primary = self.primary;
    addressesCopy.region = self.region;
    addressesCopy.streetAddress = self.streetAddress;
    addressesCopy.type = self.type;

    return addressesCopy;
}

+ (id)addressesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRAddresses *addresses =
        [JRAddresses addresses];

    addresses.addressesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    addresses.country = [dictionary objectForKey:@"country"];
    addresses.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    addresses.formatted = [dictionary objectForKey:@"formatted"];
    addresses.latitude = [dictionary objectForKey:@"latitude"];
    addresses.locality = [dictionary objectForKey:@"locality"];
    addresses.longitude = [dictionary objectForKey:@"longitude"];
    addresses.poBox = [dictionary objectForKey:@"poBox"];
    addresses.postalCode = [dictionary objectForKey:@"postalCode"];
    addresses.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    addresses.region = [dictionary objectForKey:@"region"];
    addresses.streetAddress = [dictionary objectForKey:@"streetAddress"];
    addresses.type = [dictionary objectForKey:@"type"];

    return addresses;
}

- (NSDictionary*)dictionaryFromAddressesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.addressesId)
        [dict setObject:[NSNumber numberWithInt:self.addressesId] forKey:@"id"];

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

    if (self.primary)
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if (self.region)
        [dict setObject:self.region forKey:@"region"];

    if (self.streetAddress)
        [dict setObject:self.streetAddress forKey:@"streetAddress"];

    if (self.type)
        [dict setObject:self.type forKey:@"type"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
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

    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"region"])
        self.region = [dictionary objectForKey:@"region"];

    if ([dictionary objectForKey:@"streetAddress"])
        self.streetAddress = [dictionary objectForKey:@"streetAddress"];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.addressesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.country = [dictionary objectForKey:@"country"];
    self.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    self.formatted = [dictionary objectForKey:@"formatted"];
    self.latitude = [dictionary objectForKey:@"latitude"];
    self.locality = [dictionary objectForKey:@"locality"];
    self.longitude = [dictionary objectForKey:@"longitude"];
    self.poBox = [dictionary objectForKey:@"poBox"];
    self.postalCode = [dictionary objectForKey:@"postalCode"];
    self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    self.region = [dictionary objectForKey:@"region"];
    self.streetAddress = [dictionary objectForKey:@"streetAddress"];
    self.type = [dictionary objectForKey:@"type"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"country"])
        [dict setObject:self.country forKey:@"country"];

    if ([self.dirtyPropertySet containsObject:@"extendedAddress"])
        [dict setObject:self.extendedAddress forKey:@"extendedAddress"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dict setObject:self.formatted forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"latitude"])
        [dict setObject:self.latitude forKey:@"latitude"];

    if ([self.dirtyPropertySet containsObject:@"locality"])
        [dict setObject:self.locality forKey:@"locality"];

    if ([self.dirtyPropertySet containsObject:@"longitude"])
        [dict setObject:self.longitude forKey:@"longitude"];

    if ([self.dirtyPropertySet containsObject:@"poBox"])
        [dict setObject:self.poBox forKey:@"poBox"];

    if ([self.dirtyPropertySet containsObject:@"postalCode"])
        [dict setObject:self.postalCode forKey:@"postalCode"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"region"])
        [dict setObject:self.region forKey:@"region"];

    if ([self.dirtyPropertySet containsObject:@"streetAddress"])
        [dict setObject:self.streetAddress forKey:@"streetAddress"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:self.type forKey:@"type"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:self.addressesId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.country forKey:@"country"];
    [dict setObject:self.extendedAddress forKey:@"extendedAddress"];
    [dict setObject:self.formatted forKey:@"formatted"];
    [dict setObject:self.latitude forKey:@"latitude"];
    [dict setObject:self.locality forKey:@"locality"];
    [dict setObject:self.longitude forKey:@"longitude"];
    [dict setObject:self.poBox forKey:@"poBox"];
    [dict setObject:self.postalCode forKey:@"postalCode"];
    [dict setObject:[NSNumber numberWithBool:self.primary] forKey:@"primary"];
    [dict setObject:self.region forKey:@"region"];
    [dict setObject:self.streetAddress forKey:@"streetAddress"];
    [dict setObject:self.type forKey:@"type"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:self.addressesId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
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
