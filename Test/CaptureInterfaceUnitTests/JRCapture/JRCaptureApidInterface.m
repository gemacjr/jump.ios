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

 File:   JRCaptureInterface.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureApidInterface.h"
#import "JRCaptureData.h"
#import "JSONKit.h"
#import "JRCaptureError.h"


@implementation JRCaptureApidInterface
static JRCaptureApidInterface *singleton = nil;

/* Here for testing against Carl's local instance */
#ifdef TESTING_CARL_LOCAL
static NSString *appIdArg = @"&application_id=qx3ss262yufnmpb3ck93jr3zfs"
#endif

- (JRCaptureApidInterface *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureApidInterface *)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureInterfaceInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

typedef enum CaptureInterfaceStatEnum
{
    StatOk,
    StatFail,
} CaptureInterfaceStat;

- (void)finishCreateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                            forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidSucceedWithResult:context:)])
            [delegate createCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidFailWithResult:context:)])
            [delegate createCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startCreateCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureUser JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ type_name=%@ attributes=%@ creation_token=%@", [[request URL] absoluteString], [JRCaptureData entityTypeName], attributes, token);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail
                                    andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"error", @"stat",
                                                            @"url_connection", @"error",
                                                            [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                            [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                                       forDelegate:delegate
                                       withContext:context];

}

- (void)finishSigninCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    result = @"{\"access_token\":\"p6bsy8bbcwr5wbpu\",\"capture_user\":{\"testerBoolean\":true,\"aboutMe\":\"\",\"pluralLevelOne\":[{\"name\":\"Kljkljkl;\",\"level\":\"one\",\"id\":251,\"pluralLevelTwo\":[{\"name\":\"bar\",\"level\":\"two\",\"id\":252,\"pluralLevelThree\":[{\"name\":\"appletree\",\"level\":\"three\",\"id\":253},{\"name\":\"gazook\",\"level\":\"three\",\"id\":254},{\"name\":\"baz\",\"level\":\"three\",\"id\":255}]},{\"name\":\"peartree\",\"level\":\"two\",\"id\":256,\"pluralLevelThree\":[]}]},{\"name\":\"foo\",\"level\":\"one\",\"id\":258,\"pluralLevelTwo\":[{\"name\":\"bar\",\"level\":\"two\",\"id\":259,\"pluralLevelThree\":[{\"name\":\"appletree\",\"level\":\"three\",\"id\":260},{\"name\":\"gazook\",\"level\":\"three\",\"id\":261},{\"name\":\"baz\",\"level\":\"three\",\"id\":262}]}]},{\"name\":\"foo\",\"level\":\"one\",\"id\":263,\"pluralLevelTwo\":[{\"name\":\"bar\",\"level\":\"two\",\"id\":264,\"pluralLevelThree\":[]}]},{\"name\":\"foo\",\"level\":\"one\",\"id\":265,\"pluralLevelTwo\":[{\"name\":\"bar\",\"level\":\"two\",\"id\":266,\"pluralLevelThree\":[]}]}],\"currentLocation\":\"Portland, OR\",\"givenName\":\"Jkjkljlkjkl\",\"testerUniqueString\":\"\",\"objectLevelOne\":{\"name\":\"Foo\",\"level\":\"One\",\"objectLevelTwo\":{\"name\":null,\"level\":\"Foo\",\"objectLevelThree\":{\"name\":null,\"level\":\"Dfgdgfd\"}}},\"testerInteger\":5,\"familyName\":null,\"created\":\"2012-02-27 22:34:27.002541 +0000\",\"testerStringPlural\":[{\"stringPluralItem\":\"Fdfdgf\",\"id\":9810},{\"stringPluralItem\":\"five\",\"id\":9811},{\"stringPluralItem\":\"nine\",\"id\":9812},{\"stringPluralItem\":\"eight\",\"id\":9813},{\"stringPluralItem\":\"nine\",\"id\":9814},{\"stringPluralItem\":\"eight\",\"id\":9815},{\"stringPluralItem\":\"seven\",\"id\":9816},{\"stringPluralItem\":\"eight\",\"id\":9817},{\"stringPluralItem\":\"Jkljkljlk\",\"id\":9818},{\"stringPluralItem\":\"foo\",\"id\":9819},{\"stringPluralItem\":\"bar\",\"id\":9820},{\"stringPluralItem\":\"baz\",\"id\":9821},{\"stringPluralItem\":\"foo\",\"id\":9822},{\"stringPluralItem\":\"bar\",\"id\":9823},{\"stringPluralItem\":\"baz\",\"id\":9824},{\"stringPluralItem\":null,\"id\":9825}],\"statuses\":[],\"games\":[{\"rating\":0,\"name\":\"trouble\",\"opponents\":[{\"name\":\"foo\",\"id\":401},{\"name\":\"baz\",\"id\":402},{\"name\":\"baz\",\"id\":403},{\"name\":\"bar\",\"id\":404}],\"id\":400,\"isFavorite\":true},{\"rating\":0,\"name\":\"uno\",\"opponents\":[],\"id\":405,\"isFavorite\":false},{\"rating\":0,\"name\":\"uno\",\"opponents\":[],\"id\":406,\"isFavorite\":false},{\"rating\":0,\"name\":\"uno\",\"opponents\":[],\"id\":407,\"isFavorite\":false}],\"id\":5,\"displayName\":null,\"uuid\":\"48850871-6e14-4099-9f81-6a9807b5889f\",\"email\":\"\",\"gender\":null,\"lastUpdated\":\"2012-07-23 22:33:18.714422 +0000\",\"photos\":[],\"password\":null,\"lastLogin\":\"2012-07-23 22:33:18 +0000\",\"birthday\":null,\"profiles\":[{\"followers\":[],\"following\":[],\"friends\":[],\"provider\":null,\"domain\":\"google.com\",\"identifier\":\"https://www.google.com/accounts/o8/id?id=AItOawl_N-YbU0ajJrDCIeUxhoMOViiWx8Ay27k\",\"id\":267,\"accessCredentials\":null,\"remote_key\":null,\"profile\":{\"interests\":[],\"aboutMe\":null,\"updated\":null,\"status\":null,\"fashion\":null,\"currentLocation\":{\"streetAddress\":null,\"formatted\":null,\"extendedAddress\":null,\"latitude\":null,\"longitude\":null,\"locality\":null,\"region\":null,\"type\":null,\"country\":null,\"postalCode\":null,\"poBox\":null},\"politicalViews\":null,\"ims\":[],\"relationships\":[],\"name\":{\"givenName\":\"Lilli\",\"formatted\":\"Lilli McSpilli\",\"honorificSuffix\":null,\"familyName\":\"McSpilli\",\"honorificPrefix\":null,\"middleName\":null},\"happiestWhen\":null,\"heroes\":[],\"turnOffs\":[],\"tags\":[],\"languages\":[],\"music\":[],\"profileUrl\":null,\"sexualOrientation\":null,\"note\":null,\"anniversary\":null,\"addresses\":[],\"relationshipStatus\":null,\"preferredUsername\":\"mcspilli\",\"cars\":[],\"children\":[],\"food\":[],\"tvShows\":[],\"pets\":[],\"accounts\":[],\"jobInterests\":[],\"drinker\":null,\"smoker\":null,\"languagesSpoken\":[],\"religion\":null,\"displayName\":\"mcspilli\",\"humor\":null,\"livingArrangement\":null,\"phoneNumbers\":[],\"lookingFor\":[],\"gender\":null,\"emails\":[],\"turnOns\":[],\"utcOffset\":null,\"photos\":[],\"profileSong\":null,\"interestedInMeeting\":null,\"ethnicity\":null,\"romance\":null,\"quotes\":[],\"birthday\":null,\"sports\":[],\"published\":null,\"urls\":[],\"bodyType\":{\"eyeColor\":null,\"build\":null,\"color\":null,\"height\":null,\"hairColor\":null},\"organizations\":[],\"nickname\":null,\"scaredOf\":null,\"movies\":[],\"books\":[],\"profileVideo\":null}}],\"testerIpAddr\":null,\"middleName\":null,\"display\":null,\"emailVerified\":null,\"primaryAddress\":{\"address2\":null,\"address1\":null,\"city\":null,\"company\":null,\"mobile\":null,\"stateAbbreviation\":null,\"zip\":null,\"zipPlus4\":null,\"phone\":null,\"country\":null},\"onipLevelOne\":[{\"name\":\"apple\",\"level\":\"one\",\"onipLevelTwo\":{\"name\":\"banana\",\"level\":\"two\",\"onipLevelThree\":{\"name\":\"carrot\",\"level\":\"three\"}},\"id\":581},{\"name\":\"atlanta\",\"level\":\"one\",\"onipLevelTwo\":{\"name\":\"boston\",\"level\":\"two\",\"onipLevelThree\":{\"name\":\"chicago\",\"level\":\"three\"}},\"id\":582},{\"name\":null,\"level\":null,\"onipLevelTwo\":{\"name\":\"Fewtwerw\",\"level\":null,\"onipLevelThree\":{\"name\":null,\"level\":null}},\"id\":583},{\"name\":null,\"level\":null,\"onipLevelTwo\":{\"name\":null,\"level\":\"4\",\"onipLevelThree\":{\"name\":null,\"level\":null}},\"id\":584}],\"pinoLevelOne\":{\"name\":\"ralph\",\"level\":\"one\",\"pinoLevelTwo\":{\"name\":\"nelson\",\"level\":\"two\",\"pinoLevelThree\":[{\"name\":null,\"level\":null,\"id\":551}]}}},\"is_new\":false,\"stat\":\"ok\"}";

    if (1)//(stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(signinCaptureUserDidSucceedWithResult:context:)])
            [delegate signinCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(signinCaptureUserDidFailWithResult:context:)])
            [delegate signinCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startSigninCaptureUserWithCredentials:(NSDictionary *)credentials ofType:(NSString *)signinType
                             forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];
    NSString *signinName = [credentials objectForKey:signinType];
    NSString *password   = [credentials objectForKey:@"password"];

    [body appendData:[[NSString stringWithFormat:@"%@=%@", signinType, signinName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&password=%@", password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"client_id=%@", [JRCaptureData clientId]] dataUsingEncoding:NSUTF8StringEncoding]];


#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/oauth/mobile_signin_username_password", [JRCaptureData captureUIBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *newTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"signinUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ %@=%@", [[request URL] absoluteString], signinType, signinName);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
        [self finishSigninCaptureUserWithStat:StatFail
                                    andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"error", @"stat",
                                                    @"url_connection", @"error",
                                                    [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                                  forDelegate:delegate
                                  withContext:context];
}

- (void)finishGetCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidSucceedWithResult:context:)])
            [delegate getCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidFailWithResult:context:)])
            [delegate getCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startGetCaptureUserWithToken:(NSString *)token
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *newTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ type_name=%@ access_token=%@", [[request URL] absoluteString], [JRCaptureData entityTypeName], token);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
        [self finishGetCaptureUserWithStat:StatFail
                                 andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"error", @"stat",
                                                    @"url_connection", @"error",
                                                    [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                               forDelegate:delegate
                               withContext:context];
}

- (void)finishGetObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidSucceedWithResult:context:)])
            [delegate getCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidFailWithResult:context:)])
            [delegate getCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startGetCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishGetObjectWithStat:StatFail
                            andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                               @"error", @"stat",
                                               @"url_connection", @"error",
                                               [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                               [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                          forDelegate:delegate
                          withContext:context];

}

- (void)finishUpdateObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidSucceedWithResult:context:)])
            [delegate updateCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidFailWithResult:context:)])
            [delegate updateCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startUpdateObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.update", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"updateObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishUpdateObjectWithStat:StatFail
                               andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"error", @"stat",
                                                  @"url_connection", @"error",
                                                  [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                  [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                             forDelegate:delegate
                             withContext:context];

}

- (void)finishReplaceObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidSucceedWithResult:context:)])
            [delegate replaceCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidFailWithResult:context:)])
            [delegate replaceCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startReplaceObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath
                 withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.replace", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"replaceObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishReplaceObjectWithStat:StatFail
                                andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"error", @"stat",
                                                   @"url_connection", @"error",
                                                   [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                   [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                              forDelegate:delegate
                              withContext:context];

}

- (void)finishReplaceArrayWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidSucceedWithResult:context:)])
            [delegate replaceCaptureArrayDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidFailWithResult:context:)])
            [delegate replaceCaptureArrayDidFailWithResult:result context:context];
    }
}

- (void)startReplaceArray:(NSArray *)captureArray atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureArray JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef TESTING_CARL_LOCAL
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];
#endif

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.replace", [JRCaptureData captureApidBaseUrl]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"replaceArray", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag]) /* tag vs context for workaround */
        [self finishReplaceArrayWithStat:StatFail
                               andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"error", @"stat",
                                                  @"url_connection", @"error",
                                                  [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                  [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                             forDelegate:delegate
                             withContext:context];

}

+ (void)signinCaptureUserWithCredentials:(NSDictionary *)credentials ofType:(NSString *)signinType
                             forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startSigninCaptureUserWithCredentials:credentials ofType:signinType forDelegate:delegate withContext:context];

}

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureUserWithToken:token forDelegate:delegate withContext:context];
}

+ (void)createCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
              forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startCreateCaptureUser:captureUser withToken:token forDelegate:delegate withContext:context];
}

+ (void)getCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureObjectAtPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)updateCaptureObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    [[JRCaptureApidInterface captureInterfaceInstance]
            startUpdateObject:captureObject atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceObject:captureObject atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureArray:(NSArray *)captureArray atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceArray:captureArray atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];

    NSDictionary *response    = [payload objectFromJSONString];
    CaptureInterfaceStat stat = [[response objectForKey:@"stat"] isEqualToString:@"ok"] ? StatOk : StatFail;

    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"signinUser"])
    {
        [self finishSigninCaptureUserWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getObject"])
    {
        [self finishGetObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        [self finishUpdateObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        [self finishReplaceObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceArray"])
    {
        [self finishReplaceArrayWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request andTag:(id)userdata { }
- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"");

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"error", @"stat",
                                    [error localizedDescription], @"error",
                                    [error localizedFailureReason], @"error_description",
                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorConnectionDidFail], @"code", nil];


    if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"signinUser"])
    {
        [self finishSigninCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getObject"])
    {
        [self finishGetObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        [self finishUpdateObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        [self finishReplaceObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceArray"])
    {
        [self finishReplaceArrayWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
}

- (void)connectionWasStoppedWithTag:(id)userdata { }
@end
