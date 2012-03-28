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


#import "JRPrimaryAddress.h"

@implementation JRPrimaryAddress
{
    NSString *_address1;
    NSString *_address2;
    NSString *_city;
    NSString *_company;
    NSString *_country;
    NSString *_mobile;
    NSString *_phone;
    NSString *_stateAbbreviation;
    NSString *_zip;
    NSString *_zipPlus4;
}
@dynamic address1;
@dynamic address2;
@dynamic city;
@dynamic company;
@dynamic country;
@dynamic mobile;
@dynamic phone;
@dynamic stateAbbreviation;
@dynamic zip;
@dynamic zipPlus4;

- (NSString *)address1
{
    return _address1;
}

- (void)setAddress1:(NSString *)newAddress1
{
    [self.dirtyPropertySet addObject:@"address1"];

    if (!newAddress1)
        _address1 = [NSNull null];
    else
        _address1 = [newAddress1 copy];
}

- (NSString *)address2
{
    return _address2;
}

- (void)setAddress2:(NSString *)newAddress2
{
    [self.dirtyPropertySet addObject:@"address2"];

    if (!newAddress2)
        _address2 = [NSNull null];
    else
        _address2 = [newAddress2 copy];
}

- (NSString *)city
{
    return _city;
}

- (void)setCity:(NSString *)newCity
{
    [self.dirtyPropertySet addObject:@"city"];

    if (!newCity)
        _city = [NSNull null];
    else
        _city = [newCity copy];
}

- (NSString *)company
{
    return _company;
}

- (void)setCompany:(NSString *)newCompany
{
    [self.dirtyPropertySet addObject:@"company"];

    if (!newCompany)
        _company = [NSNull null];
    else
        _company = [newCompany copy];
}

- (NSString *)country
{
    return _country;
}

- (void)setCountry:(NSString *)newCountry
{
    [self.dirtyPropertySet addObject:@"country"];

    if (!newCountry)
        _country = [NSNull null];
    else
        _country = [newCountry copy];
}

- (NSString *)mobile
{
    return _mobile;
}

- (void)setMobile:(NSString *)newMobile
{
    [self.dirtyPropertySet addObject:@"mobile"];

    if (!newMobile)
        _mobile = [NSNull null];
    else
        _mobile = [newMobile copy];
}

- (NSString *)phone
{
    return _phone;
}

- (void)setPhone:(NSString *)newPhone
{
    [self.dirtyPropertySet addObject:@"phone"];

    if (!newPhone)
        _phone = [NSNull null];
    else
        _phone = [newPhone copy];
}

- (NSString *)stateAbbreviation
{
    return _stateAbbreviation;
}

- (void)setStateAbbreviation:(NSString *)newStateAbbreviation
{
    [self.dirtyPropertySet addObject:@"stateAbbreviation"];

    if (!newStateAbbreviation)
        _stateAbbreviation = [NSNull null];
    else
        _stateAbbreviation = [newStateAbbreviation copy];
}

- (NSString *)zip
{
    return _zip;
}

- (void)setZip:(NSString *)newZip
{
    [self.dirtyPropertySet addObject:@"zip"];

    if (!newZip)
        _zip = [NSNull null];
    else
        _zip = [newZip copy];
}

- (NSString *)zipPlus4
{
    return _zipPlus4;
}

- (void)setZipPlus4:(NSString *)newZipPlus4
{
    [self.dirtyPropertySet addObject:@"zipPlus4"];

    if (!newZipPlus4)
        _zipPlus4 = [NSNull null];
    else
        _zipPlus4 = [newZipPlus4 copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/primaryAddress";
    }
    return self;
}

+ (id)primaryAddress
{
    return [[[JRPrimaryAddress alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPrimaryAddress *primaryAddressCopy =
                [[JRPrimaryAddress allocWithZone:zone] init];

    primaryAddressCopy.address1 = self.address1;
    primaryAddressCopy.address2 = self.address2;
    primaryAddressCopy.city = self.city;
    primaryAddressCopy.company = self.company;
    primaryAddressCopy.country = self.country;
    primaryAddressCopy.mobile = self.mobile;
    primaryAddressCopy.phone = self.phone;
    primaryAddressCopy.stateAbbreviation = self.stateAbbreviation;
    primaryAddressCopy.zip = self.zip;
    primaryAddressCopy.zipPlus4 = self.zipPlus4;

    return primaryAddressCopy;
}

+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPrimaryAddress *primaryAddress =
        [JRPrimaryAddress primaryAddress];

    primaryAddress.address1 = [dictionary objectForKey:@"address1"];
    primaryAddress.address2 = [dictionary objectForKey:@"address2"];
    primaryAddress.city = [dictionary objectForKey:@"city"];
    primaryAddress.company = [dictionary objectForKey:@"company"];
    primaryAddress.country = [dictionary objectForKey:@"country"];
    primaryAddress.mobile = [dictionary objectForKey:@"mobile"];
    primaryAddress.phone = [dictionary objectForKey:@"phone"];
    primaryAddress.stateAbbreviation = [dictionary objectForKey:@"stateAbbreviation"];
    primaryAddress.zip = [dictionary objectForKey:@"zip"];
    primaryAddress.zipPlus4 = [dictionary objectForKey:@"zipPlus4"];

    return primaryAddress;
}

- (NSDictionary*)dictionaryFromPrimaryAddressObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.address1 && self.address1 != [NSNull null])
        [dict setObject:self.address1 forKey:@"address1"];
    else
        [dict setObject:[NSNull null] forKey:@"address1"];

    if (self.address2 && self.address2 != [NSNull null])
        [dict setObject:self.address2 forKey:@"address2"];
    else
        [dict setObject:[NSNull null] forKey:@"address2"];

    if (self.city && self.city != [NSNull null])
        [dict setObject:self.city forKey:@"city"];
    else
        [dict setObject:[NSNull null] forKey:@"city"];

    if (self.company && self.company != [NSNull null])
        [dict setObject:self.company forKey:@"company"];
    else
        [dict setObject:[NSNull null] forKey:@"company"];

    if (self.country && self.country != [NSNull null])
        [dict setObject:self.country forKey:@"country"];
    else
        [dict setObject:[NSNull null] forKey:@"country"];

    if (self.mobile && self.mobile != [NSNull null])
        [dict setObject:self.mobile forKey:@"mobile"];
    else
        [dict setObject:[NSNull null] forKey:@"mobile"];

    if (self.phone && self.phone != [NSNull null])
        [dict setObject:self.phone forKey:@"phone"];
    else
        [dict setObject:[NSNull null] forKey:@"phone"];

    if (self.stateAbbreviation && self.stateAbbreviation != [NSNull null])
        [dict setObject:self.stateAbbreviation forKey:@"stateAbbreviation"];
    else
        [dict setObject:[NSNull null] forKey:@"stateAbbreviation"];

    if (self.zip && self.zip != [NSNull null])
        [dict setObject:self.zip forKey:@"zip"];
    else
        [dict setObject:[NSNull null] forKey:@"zip"];

    if (self.zipPlus4 && self.zipPlus4 != [NSNull null])
        [dict setObject:self.zipPlus4 forKey:@"zipPlus4"];
    else
        [dict setObject:[NSNull null] forKey:@"zipPlus4"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"address1"])
        _address1 = [dictionary objectForKey:@"address1"];

    if ([dictionary objectForKey:@"address2"])
        _address2 = [dictionary objectForKey:@"address2"];

    if ([dictionary objectForKey:@"city"])
        _city = [dictionary objectForKey:@"city"];

    if ([dictionary objectForKey:@"company"])
        _company = [dictionary objectForKey:@"company"];

    if ([dictionary objectForKey:@"country"])
        _country = [dictionary objectForKey:@"country"];

    if ([dictionary objectForKey:@"mobile"])
        _mobile = [dictionary objectForKey:@"mobile"];

    if ([dictionary objectForKey:@"phone"])
        _phone = [dictionary objectForKey:@"phone"];

    if ([dictionary objectForKey:@"stateAbbreviation"])
        _stateAbbreviation = [dictionary objectForKey:@"stateAbbreviation"];

    if ([dictionary objectForKey:@"zip"])
        _zip = [dictionary objectForKey:@"zip"];

    if ([dictionary objectForKey:@"zipPlus4"])
        _zipPlus4 = [dictionary objectForKey:@"zipPlus4"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _address1 = [dictionary objectForKey:@"address1"];
    _address2 = [dictionary objectForKey:@"address2"];
    _city = [dictionary objectForKey:@"city"];
    _company = [dictionary objectForKey:@"company"];
    _country = [dictionary objectForKey:@"country"];
    _mobile = [dictionary objectForKey:@"mobile"];
    _phone = [dictionary objectForKey:@"phone"];
    _stateAbbreviation = [dictionary objectForKey:@"stateAbbreviation"];
    _zip = [dictionary objectForKey:@"zip"];
    _zipPlus4 = [dictionary objectForKey:@"zipPlus4"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"address1"])
        [dict setObject:self.address1 forKey:@"address1"];

    if ([self.dirtyPropertySet containsObject:@"address2"])
        [dict setObject:self.address2 forKey:@"address2"];

    if ([self.dirtyPropertySet containsObject:@"city"])
        [dict setObject:self.city forKey:@"city"];

    if ([self.dirtyPropertySet containsObject:@"company"])
        [dict setObject:self.company forKey:@"company"];

    if ([self.dirtyPropertySet containsObject:@"country"])
        [dict setObject:self.country forKey:@"country"];

    if ([self.dirtyPropertySet containsObject:@"mobile"])
        [dict setObject:self.mobile forKey:@"mobile"];

    if ([self.dirtyPropertySet containsObject:@"phone"])
        [dict setObject:self.phone forKey:@"phone"];

    if ([self.dirtyPropertySet containsObject:@"stateAbbreviation"])
        [dict setObject:self.stateAbbreviation forKey:@"stateAbbreviation"];

    if ([self.dirtyPropertySet containsObject:@"zip"])
        [dict setObject:self.zip forKey:@"zip"];

    if ([self.dirtyPropertySet containsObject:@"zipPlus4"])
        [dict setObject:self.zipPlus4 forKey:@"zipPlus4"];

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

    [dict setObject:self.address1 forKey:@"address1"];
    [dict setObject:self.address2 forKey:@"address2"];
    [dict setObject:self.city forKey:@"city"];
    [dict setObject:self.company forKey:@"company"];
    [dict setObject:self.country forKey:@"country"];
    [dict setObject:self.mobile forKey:@"mobile"];
    [dict setObject:self.phone forKey:@"phone"];
    [dict setObject:self.stateAbbreviation forKey:@"stateAbbreviation"];
    [dict setObject:self.zip forKey:@"zip"];
    [dict setObject:self.zipPlus4 forKey:@"zipPlus4"];

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
    [_address1 release];
    [_address2 release];
    [_city release];
    [_company release];
    [_country release];
    [_mobile release];
    [_phone release];
    [_stateAbbreviation release];
    [_zip release];
    [_zipPlus4 release];

    [super dealloc];
}
@end
