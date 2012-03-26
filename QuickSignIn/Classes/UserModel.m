/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

 File:   UserModel.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "UserModel.h"


@interface UserModel ()
@property (retain) EmbeddedTableViewController *embeddedTable;
- (void)loadSignedInUser;
- (void)finishSignUserIn:(NSDictionary *)user;
- (void)finishSignUserOut;
@end

@implementation UserModel
@synthesize currentUser;
@synthesize selectedUser;
@synthesize authInfo;
@synthesize loadingUserData;
@synthesize customInterface;
@synthesize navigationController;
@synthesize embeddedTable;
@synthesize iPad;
@synthesize tokenUrlDelegate;
@synthesize pendingCallToTokenUrl;
@synthesize libraryDialogDelegate;
@synthesize latestAccessToken;

/* Singleton instance of UserModel */
static UserModel *singleton = nil;

/* To use the JREngage library, you must first sign up for an account and create
   an application on http://rpxnow.com.  You must also have a web server that can host
   your token URL.  Your token URL contains your Engage Application's 40-character key and
   makes the auth_info post to the Engage server.  You can have more than one token URL,
   and you can instantiate the JRAuthenticate library with tokenURL=nil, but you will need
   to post the token to a token URL to finish authentication.  If you already have an Engage
   widget working on your site, it is recommended that you create a second, more simple
   token URL specifically for the iPhone Library.  If you don't already have the Engage
   widget working on your site, or you don't have a site, we recommend that you create a
   very simple application using Google's App Engine: http://code.google.com/appengine/.
   See my reference application in the ../googleAppEngineDemoApp folder for an example
   of a simple token URL that call auth_info, and serves the returned json response
   back to this application.


Instantiate the JRAuthenticate Library with your Engage Application's 20-character ID and
(optional) token URL, which you create on your web site.  If you don't instantiate the
library with a token URL, you must make the call yourself after you receive the token,
otherwise, this happens automatically.                                                  */

// TODO: Document this!
//static NSString *captureDomain  = @"<you_capture_domain_or_nil>";
//static NSString *clientId       = @"<you_capture_client_id_or_nil>";
//static NSString *entityTypeName = @"<you_capture_entity_type_or_nil>";

//static NSString *appId    = @"<your_app_id>";
//static NSString *tokenUrl = @"<your_token_url>";

- (UserModel*)init
{
    if ((self = [super init]))
    {
        /* Capture demo is not currently built for the iPad. */
        /* For an Engage only demo, simply add the appId and tokenUrl.  For a Capture, add a captureDomain,
           clientId, and entityTypeName */
        if (captureDomain && clientId && entityTypeName && !(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
        {
            captureDemo = YES;
            [JRCaptureInterface setCaptureDomain:captureDomain clientId:clientId andEntityTypeName:entityTypeName];
            jrEngage = [JREngage jrEngageWithAppId:appId
                                       andTokenUrl:[JRCaptureInterface captureMobileEndpointUrl]
                                          delegate:self];
        }
        else
        {
         /* Instantiate an instance of the JRAuthenticate library with your application ID and token URL */
            jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];
        }

        prefs = [[NSUserDefaults standardUserDefaults] retain];

        selectedUser = nil;
        currentUser = nil;
        identifier = nil;
        currentProvider = nil;
        displayName = nil;

        historyCountSnapShot = (NSUInteger) [prefs integerForKey:@"historyCount"];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;

     /* Load any session that was still logged in when the application closed. */
        [self loadSignedInUser];
    }

    return self;
}

/* Return the singleton instance of this class. */
+ (UserModel*)getUserModel
{
    if (singleton == nil) {
        singleton = (UserModel *) [[super allocWithZone:NULL] init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getUserModel] retain];
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
    return NSUIntegerMax; /* Denotes an object that cannot be released */
}

- (oneway void)release { /* Do nothing */ }

- (id)autorelease
{
    return self;
}

+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
{
    NSString *name = nil;

    if ([profile objectForKey:@"preferredUsername"])
        name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
    else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
        name = [NSString stringWithFormat:@"%@",
                [[profile objectForKey:@"name"] objectForKey:@"formatted"]];
    else
        name = [NSString stringWithFormat:@"%@%@%@%@%@",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];

    return name;
}

+ (NSString*)getAddressFromProfile:(NSDictionary*)profile
{
    NSString *addr = nil;

    if ([[profile objectForKey:@"address"] objectForKey:@"formatted"])
        addr = [NSString stringWithFormat:@"%@",
                [[profile objectForKey:@"address"] objectForKey:@"formatted"]];
    else
        addr = [NSString stringWithFormat:@"%@%@%@%@%@",
                ([[profile objectForKey:@"address"] objectForKey:@"streetAddress"]) ?
                [NSString stringWithFormat:@"%@, ",
                 [[profile objectForKey:@"address"] objectForKey:@"streetAddress"]] : @"",
                ([[profile objectForKey:@"address"] objectForKey:@"locality"]) ?
                [NSString stringWithFormat:@"%@, ",
                 [[profile objectForKey:@"address"] objectForKey:@"locality"]] : @"",
                ([[profile objectForKey:@"address"] objectForKey:@"region"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"address"] objectForKey:@"region"]] : @"",
                ([[profile objectForKey:@"address"] objectForKey:@"postalCode"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"address"] objectForKey:@"postalCode"]] : @"",
                ([[profile objectForKey:@"address"] objectForKey:@"country"]) ?
                [NSString stringWithFormat:@"%@",
                 [[profile objectForKey:@"address"] objectForKey:@"country"]] : @""];

    return addr;
}

/**
 * Horrible hack to remove NSNulls from profile data to allow it to be stored in an NSUserDefaults
 * (Capture profiles can have null values and JSONKit parses them to NSNulls, but Engage profiles don't and so
 * didn't trigger this incompatibility.)
 */
- (id)nullWalker:(id)structure
{
    if ([structure isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *) structure;
        NSMutableDictionary *retval = [NSMutableDictionary dictionary];
        NSArray *keys = [dict allKeys];
        for (NSString *key in keys)
        {
            NSObject *val = [dict objectForKey:key];
            if ([val isKindOfClass:[NSNull class]])
                /* don't add */;
            else if ([val isKindOfClass:[NSDictionary class]])
                [retval setObject:[self nullWalker:val] forKey:key];
            else if ([val isKindOfClass:[NSArray class]])
                [retval setObject:[self nullWalker:val] forKey:key];
            else
                [retval setObject:val forKey:key];
        }
        return retval;
    }
    else if ([structure isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *) structure;
        NSMutableArray *retval = [NSMutableArray array];
        for (NSObject *val in array)
            if ([val isKindOfClass:[NSNull class]])
                /* don't add */;
            else if ([val isKindOfClass:[NSDictionary class]])
                [retval addObject:[self nullWalker:val]];
            else if ([val isKindOfClass:[NSArray class]])
                [retval addObject:[self nullWalker:val]];
            else
                [retval addObject:val];
        return retval;
    }
    else
    {
        ALog(@"Unrecognized stucture: %@", [structure description]);
        return nil;
        // TODO: Better error handling
        //exit(1);
    }
}

/* Returns the sign-in history as an ordered array of sessions, store as dictionaries.
   Each session's dictionary contains the identifier, display name, provider, and timestamp
   for that particular session.  As one user may log in many times, identifiers are not unique. */
- (NSArray*)signinHistory
{
    return [prefs objectForKey:@"signinHistory"];
}

/* Returns a dictionary of dictionaries, where each dictionary contains the profile
   data of previously logged in users.  One dictionary is saved per identifier. */
- (NSDictionary*)userProfiles
{
    return [prefs objectForKey:@"userProfiles"];
}

- (void)pruneUserProfiles
{
    NSArray *historyArr = [prefs arrayForKey:@"signinHistory"];

 /* Since the sign-in history array likely contains several duplicate identifiers, we'll first
    go through the array one time, pull out all the identifiers, and add them to an NSMutableSet.
    When finished, the NSSet will contain only the *unique* identifiers, which should be far fewer than
    the size of the sign-in history array. */
    NSMutableSet *uniqueIDS = [[[NSMutableSet alloc] initWithCapacity:[historyArr count]] autorelease];

 /* Don't forget the current user. */
    if (currentUser)
        [uniqueIDS addObject:[currentUser objectForKey:@"identifier"]];

    for (NSDictionary* savedLogin in historyArr)
    {
        [uniqueIDS addObject:[savedLogin objectForKey:@"identifier"]];
    }

 /* This is the dictionary of profiles which we will be pruning. */
    NSDictionary *profiles = [[prefs objectForKey:@"userProfiles"] retain];

 /* This is the new dictionary of profiles init-ed to the correct capacity. */
    NSMutableDictionary* newProfiles = [[NSMutableDictionary alloc]
                                        initWithCapacity:[uniqueIDS count]];

 /* Figure out the new size for the number of profiles in our new dictionary based on the number of
    identifiers we are saving in our history, so we can stop one we've finished pruning */
    NSUInteger theNewSize = [uniqueIDS count];
    NSUInteger whatWeHaveFoundSoFar = 0;

    for (NSString* ident in [profiles allKeys])
    {
     /* If we're done, just stop */
        if (whatWeHaveFoundSoFar == theNewSize)
            break;

     /* If this identifier is still in the set, add it to the new dictionary of profiles */
        if ([uniqueIDS containsObject:ident])
        {
            [newProfiles setObject:[profiles objectForKey:ident] forKey:ident];
            whatWeHaveFoundSoFar++;
        }
    }

 /* Now, save the new, pruned dictionary and release */
    [prefs setObject:newProfiles forKey:@"userProfiles"];
    [newProfiles release];
    [profiles release];

 /* And update the test value */
    historyCountSnapShot = [historyArr count];

 /* Save the historyCountSnapShot, as it may be bigger than the current array count */
    [prefs setInteger:historyCountSnapShot forKey:@"historyCount"];
}

- (void)removeUserFromHistory:(NSUInteger)index
{
 /* Create a mutable array from the non-mutable NSUserDefaults array, */
    NSArray *tmpArr = [prefs arrayForKey:@"signinHistory"];
    NSMutableArray *historyArr = [[NSMutableArray alloc] initWithCapacity:[tmpArr count]];
    [historyArr addObjectsFromArray:tmpArr];

 /* Remove the entry, */
    @try
        { [historyArr removeObjectAtIndex:index]; }
    @catch ( NSException *e )
        { return; }

 /* And save. */
    [prefs setObject:historyArr forKey:@"signinHistory"];

 /* As we remove the unique sign-ins from the history, eventually we may remove all entries
    for a specific user, but we will still have their profile data saved in the userProfiles
    dictionary.  Therefore, we should eventually prune the userProfiles dictionary so that
    we don't have needless information hanging around. Since this is time consuming, only
    prune when the size of the signinHistory array is half of what it was before. */
    if ([historyArr count] <= (historyCountSnapShot/2))
        [self pruneUserProfiles];

    [historyArr release];
}

- (void)loadSignedInUser
{
 /* First, see if there is a saved user */
    currentUser = [prefs objectForKey:@"currentUser"];

    if (!currentUser)
        return;

 /* If there is, load the displayName and identifier */
    identifier      = [[currentUser objectForKey:@"identifier"] retain];
    displayName     = [[currentUser objectForKey:@"displayName"] retain];
    currentProvider = [[currentUser objectForKey:@"provider"] retain];

 /* Then check the cookies to make sure the saved user's identifier matches any cookie returned from
    the token URL, or if their session has expired */
    NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:@"http://jrauthenticate.appspot.com"]];
    NSString *cookieIdentifier = nil;

    for (NSHTTPCookie *cookie in cookies)
    {
        if ([cookie.name isEqualToString:@"sid"])
        {
            cookieIdentifier = [[NSString stringWithString:cookie.value]
                                stringByTrimmingCharactersInSet:
                                [NSCharacterSet characterSetWithCharactersInString:@"\""]];
        }
    }

 /* Then the cookie expired, and we have a user currently logged in, so we have to
    log out the current user and save the history of the session in the array of previous sessions */
    if (!cookieIdentifier)
    {
        [self finishSignUserOut];
        return;
    }

 /* Make sure the cookie's identifier matches the saved user's identifier,
    otherwise, sign the user out. */
    if (![cookieIdentifier isEqualToString:identifier])
    {
        [self finishSignUserOut];
        return;
    }

    return;
}

- (void)addCaptureUserFromCaptureResult:(NSString *)captureResult
{
    DLog(@"");

    NSDictionary        *tmpProfiles = [prefs objectForKey:@"userProfiles"];
    NSMutableDictionary *newProfiles = [NSMutableDictionary dictionaryWithDictionary:tmpProfiles];
    NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithDictionary:
                                                   [newProfiles objectForKey:
                                                               [currentUser objectForKey:@"identifier"]]];
    NSDictionary        *captureDictionary  = [captureResult objectFromJSONString];

    if (!captureDictionary)
    {
        ALog(@"Unable to parse token URL response: %@", captureResult);
        return; // TODO: Better error handling (Add a GOTO?)
    }

    NSString     *captureAccessToken   = [captureDictionary objectForKey:@"access_token"];
    NSDictionary *captureCredentials;

    // TODO: Temp test for Cypress
    self.latestAccessToken = captureAccessToken;

    if (captureAccessToken)
        captureCredentials = [NSDictionary dictionaryWithObject:captureAccessToken
                                                         forKey:@"access_token"];
    else
        captureCredentials = nil;

    NSDictionary *captureProfile = nil;
    if (captureDemo && captureAccessToken)
        captureProfile = [self nullWalker:[captureDictionary objectForKey:@"result"]];

    if (captureProfile)
        [userProfile setObject:captureProfile forKey:@"captureProfile"];
    if (captureCredentials)
        [userProfile setObject:captureCredentials forKey:@"captureCredentials"];

    [newProfiles setObject:userProfile forKey:[currentUser objectForKey:@"identifier"]];
    [prefs setObject:newProfiles forKey:@"userProfiles"];

//    [tokenUrlDelegate didReachTokenUrl];
//    [tokenUrlDelegate release], tokenUrlDelegate = nil;
}


- (void)finishSignUserOut
{
 /* Save the currentUser's session dictionary (identifier, display name, provider and timestamp)
    at the beginning of the sign-in history array.  One specific user may have multiple distinct
    sessions saved in this array, which is why we're saving minimal session data in this array
    and keeping their full profiles in the separate userProfiles dictionary. */

 /* Create a mutable array from the non-mutable NSUserDefaults array, */
    NSArray *tmp = [prefs arrayForKey:@"signinHistory"];
    NSMutableArray *signinHistory = [[NSMutableArray alloc]
                                     initWithCapacity:([tmp count] + 1)];
    [signinHistory addObjectsFromArray:tmp];

 /* Insert the currentUser's session dictionary at the beginning of the array, */
    [signinHistory insertObject:currentUser atIndex:0];

 /* save the array, and nullify the currentUser. */
    [prefs setObject:signinHistory forKey:@"signinHistory"];
    [prefs setObject:nil forKey:@"currentUser"];

    [signinHistory release];

    [currentUser release];
    currentUser = nil;

    [displayName release];
    displayName = nil;

    [identifier release];
    identifier = nil;

    [currentProvider release];
    currentProvider = nil;

    [signOutDelegate userDidSignOut];
    [signOutDelegate release], signOutDelegate = nil;

 /* As we remove sign-in sessions from the history, eventually we need to prune the profiles from the
    userProfiles dictionary.  We do this when the size of the signinHistory array is half
    of the historyCountSnapShot.  As the array grows, so does historyCountSnapShot, but
    historyCountSnapShot only shrinks after a pruning. */
    historyCountSnapShot++;

 /* Save the historyCountSnapShot, as it may be bigger than the current array count. */
    [prefs setInteger:historyCountSnapShot forKey:@"historyCount"];
}

- (void)startSignUserOut:(id<UserModelDelegate>)interestedParty
{
    signOutDelegate = [interestedParty retain];

    [self finishSignUserOut];
}

- (void)finishSignUserIn:(NSDictionary*)user
{
    if (currentUser)
        [self finishSignUserOut];

 /* Get the identifier and normalize it (remove html escapes) */
    identifier =
            [[[[user objectForKey:@"profile"] objectForKey:@"identifier"]
                     stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] retain];

 /* Get the display name */
    displayName = [[UserModel getDisplayNameFromProfile:[user objectForKey:@"profile"]] retain];

 /* Store the current user's profile dictionary in the dictionary of users,
    using the identifier as the key, and then save the dictionary of users */
    NSDictionary *tmpProfiles = [prefs objectForKey:@"userProfiles"];

// TODO: Not saving the dictionary causes problems with the capture token; investigate a better way?
// /* If this profile doesn't already exist in the dictionary of saved profiles */
//    if (![tmpProfiles objectForKey:identifier])
//    {
     /* Create a mutable dictionary from the non-mutable NSUserDefaults dictionary, */
        NSMutableDictionary* newProfiles = [NSMutableDictionary dictionaryWithDictionary:tmpProfiles];

     /* add the user's profile to the dictionary, indexed by the identifier, */
        [newProfiles setObject:user forKey:identifier];

     /* and save. */
        [prefs setObject:newProfiles forKey:@"userProfiles"];
//    }

 /* Get the approximate timestamp of the user's log in */
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    NSString *currentTime = [dateFormatter stringFromDate:today];
    [dateFormatter release];

 /* Create a dictionary of the identifier and the timestamp.  For now, save this dictionary
    as the currently logged in user. */
    currentUser = [[NSDictionary dictionaryWithObjectsAndKeys:
                    identifier, @"identifier",
                    currentProvider, @"provider",
                    displayName, @"displayName",
                    currentTime, @"timestamp", nil] retain];

    [prefs setObject:currentUser forKey:@"currentUser"];

    loadingUserData = NO;

    [signInDelegate userDidSignIn];

    [self setTokenUrlDelegate:signInDelegate];
    [signInDelegate release], signInDelegate = nil;
}

- (void)startSignUserIn:(id<UserModelDelegate>)interestedParty
{
    DLog(@"");

    loadingUserData = YES;
    signInDelegate = [interestedParty retain];

    NSMutableDictionary *moreCustomizations = nil;

    if (NO) /* Change this to "if (YES)" to see an example of how you can add native login to the list of providers. */
    {
     /* EmbeddedTableViewController acts as the delegate and datasource of the embeddedTable, whose view will be added
        as a "subtable", as the provider table's header view. While they are two different tables, it will appear as if
        they are different sections of the same table. */
        if (!embeddedTable)
            self.embeddedTable = [[[EmbeddedTableViewController alloc] init] autorelease];

        /* If you want your embeddedTable to control the navigationController, you must use your own. */
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.navigationController = [[[UINavigationController alloc] init] autorelease];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }

        moreCustomizations = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    embeddedTable.view, kJRProviderTableHeaderView,
                                    @"Sign in with a social provider", kJRProviderTableSectionHeaderTitleString,
                                    navigationController, (iPad ?
                                               kJRCustomModalNavigationController : kJRApplicationNavigationController),
                                    nil] autorelease];
    }

    if (customInterface)
        [customInterface addEntriesFromDictionary:moreCustomizations];
    else
        customInterface = [moreCustomizations retain];

 /* Launch the JRAuthenticate Library. */
    [jrEngage showAuthenticationDialogWithCustomInterfaceOverrides:customInterface];
}


- (void)startSignUserIn:(id<UserModelDelegate>)interestedPartySignIn
           afterSignOut:(id<UserModelDelegate>)interestedPartySignOut
{
    signOutDelegate = [interestedPartySignOut retain];
    [self startSignUserIn:interestedPartySignIn];
}

- (void)triggerAuthenticationDidCancel:(id)sender
{
    [jrEngage authenticationDidCancel];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError *)error
{
    if ([error code] == JRDialogShowingError)
        return;

    loadingUserData = NO;
    [signInDelegate didFailToSignIn:YES];
    [signInDelegate release], signInDelegate = nil;

    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
        [libraryDialogDelegate libraryDialogClosed];
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary *)auth_info forProvider:(NSString *)provider
{
    if (!tokenUrl)
    {
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
    }
    else
    {
        pendingCallToTokenUrl = YES;
        [self setTokenUrlDelegate:signInDelegate];
    }

    currentProvider = [[NSString stringWithString:provider] retain];

    [signInDelegate didReceiveToken];

    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
        [libraryDialogDelegate libraryDialogClosed];

    if(!auth_info) // Then there was an error
        return; // TODO: Manage error

    self.authInfo = [NSMutableDictionary dictionaryWithDictionary:auth_info];
//    [self finishSignUserIn:auth_info];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
{
    DLog(@"");

    NSString     *payload     = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *payloadDict = [payload objectFromJSONString];

    DLog(@"token url payload: %@", [payload description]);

    if (!payloadDict)
    {
        ALog(@"Unable to parse token URL response: %@", payload);
        [self finishSignUserIn:authInfo]; // call this to keep avoid missing data in user registry
        return;
        // TODO: Better error handling (Add a GOTO)
        //exit(1);
    }

    NSString     *captureAccessToken   = [payloadDict objectForKey:@"access_token"];
    NSString     *captureCreationToken = [payloadDict objectForKey:@"creation_token"];
    NSDictionary *captureCredentials;

    // TODO: Temp test for Cypress
    self.latestAccessToken = captureAccessToken;


    if (captureAccessToken)
        captureCredentials = [NSDictionary dictionaryWithObject:captureAccessToken
                                                         forKey:@"access_token"];
    else if (captureCreationToken)
        captureCredentials =  [NSDictionary dictionaryWithObject:captureCreationToken
                                                          forKey:@"creation_token"];
    else
        captureCredentials = nil;

    NSDictionary *captureProfile = nil;
    if (captureDemo && captureAccessToken)
        captureProfile = [self nullWalker:[payloadDict objectForKey:@"capture_user"]];

//    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

//    captureProfile = captureProfile ?
//            [self nullWalker:captureProfile]
//            : nil;

    if (captureProfile)
        [authInfo setObject:captureProfile forKey:@"captureProfile"];
    if (captureCredentials)
        [authInfo setObject:captureCredentials forKey:@"captureCredentials"];

    // XXX hack for Capture mobile demo
    [self finishSignUserIn:authInfo];
    [self setAuthInfo:nil];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    pendingCallToTokenUrl = NO;

    // TODO: Fix this delegation crap; maybe add show stuff to didReachTokenUrl or something
    if (captureCreationToken)
        if ([tokenUrlDelegate respondsToSelector:@selector(showCaptureScreen)])
                [tokenUrlDelegate showCaptureScreen];

    // TODO: delegate function is optional
    [tokenUrlDelegate didReachTokenUrl];
    [tokenUrlDelegate release], tokenUrlDelegate = nil;
}

- (void)jrAuthenticationDidNotComplete
{
    loadingUserData = NO;
    [signInDelegate didFailToSignIn:NO];
    [signInDelegate release], signInDelegate = nil;

    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
        [libraryDialogDelegate libraryDialogClosed];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    loadingUserData = NO;
    [signInDelegate didFailToSignIn:YES];
    [signInDelegate release], signInDelegate = nil;

    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
        [libraryDialogDelegate libraryDialogClosed];
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)theTokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    loadingUserData = NO;
    pendingCallToTokenUrl = NO;

    [tokenUrlDelegate didFailToReachTokenUrl];
    [tokenUrlDelegate release], tokenUrlDelegate = nil;

//  [signInDelegate didFailToSignIn:YES];
//  [signInDelegate release], signInDelegate = nil;
}

- (void)dealloc
{
    [displayName release];
    [identifier release];
    [currentProvider release];

    [customInterface release];
    [signOutDelegate release];
    [signOutDelegate release];
    [signInDelegate release];
    [currentUser release];
    [prefs release];
    [super dealloc];
}
@end
