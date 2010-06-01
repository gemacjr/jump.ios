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
 
 File:	 DemoUserModel.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "DemoUserModel.h"

@interface DemoUserModel ()
- (void)loadSignedInUser;
- (void)finishSignUserIn:(NSDictionary *)user;
- (void)finishSignUserOut;
@end


@implementation DemoUserModel
static DemoUserModel* singleton = nil;

static NSString *appId = @"appcfamhnpkagijaeinl";
static NSString *tokenUrl = @"http://jrauthenticate.appspot.com/login";

@synthesize currentUser;
@synthesize selectedUser;

@synthesize loadingUserData;

- (DemoUserModel*)init
{
	if (self = [super init])
	{
		/* Instantiate an instance of the JRAuthenticate library with your appID and token URL */
		jrAuthenticate = [[JRAuthenticate jrAuthenticateWithAppID:appId andTokenUrl:tokenUrl delegate:self] retain];
		
		prefs = [[NSUserDefaults standardUserDefaults] retain];
		
		selectedUser = nil;
		currentUser = nil;
		identifier = nil;
		currentProvider = nil;
		displayName = nil;	

		historyCountSnapShot = [prefs integerForKey:@"historyCount"];
		
		/* Load any user that was still logged in when the app closed */
		[self loadSignedInUser];
	}
	
	return self;	
}


/* Return the singleton instance of this class */
+ (DemoUserModel*)getDemoUserModel
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
	
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getDemoUserModel] retain];
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
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

/* Instance variable access functions */

/* Returns the log in history as an ordered array of dictionaries, where each dictionary contains
   the identifier, display name, and timestamp for that log in.  As one user may log in many times,
   identifiers are not unique. */
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

- (void)removeUserFromHistory:(int)index
{
	NSArray *tmpArr = [prefs arrayForKey:@"signinHistory"];
	NSMutableArray *historyArr = [[NSMutableArray alloc] initWithCapacity:[tmpArr count]];
	[historyArr addObjectsFromArray:tmpArr];

	@try
		{ [historyArr removeObjectAtIndex:index]; }
	@catch ( NSException *e ) 
		{ return; }

	[prefs setObject:historyArr forKey:@"signinHistory"];

	/* As we remove log ins from the history, eventually we will have to prune the dictionary of user profiles,
	   so that we don't have needless information hanging around.  Since this is time consuming, only prune when
	   the size of the signinHistory array is half of what it was before. */
	if ([historyArr count] <= (historyCountSnapShot/2)) 
	{	
		/* Since the login history array likely contains several duplicate identifiers, we'll first 
		   go through the array one time, pull out all the identifiers, and add them to an NSMutableSet.
		   When finished, the NSSet will contain only the *unique* identifiers, which should be far fewer than
		   the size of the login history array. */
		NSMutableSet *uniqueIDS = [[NSMutableSet alloc] initWithCapacity:[historyArr count]];
		
		if (currentUser)
			[uniqueIDS addObject:[currentUser objectForKey:@"identifier"]];

		for (NSDictionary* savedLogin in historyArr)
		{
			[uniqueIDS addObject:[savedLogin objectForKey:@"identifier"]];
		}
				
		/* This is the dictionary of profiles which we will be pruning */
		NSDictionary *profiles = [[prefs objectForKey:@"userProfiles"] retain];

		/* This is the new dictionary of profiles inited to the correct capacity */
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
	
	[historyArr release];
}



- (void)loadSignedInUser
{
	/* First, see if there is a saved user */
	currentUser = [prefs objectForKey:@"currentUser"];
	
	if (!currentUser)
		return;// NO;	
	
	/* If there is, load the displayName and identifier */
	identifier = [[currentUser objectForKey:@"identifier"] retain];
	displayName = [[currentUser objectForKey:@"displayName"] retain];
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
	 log out the current user and save the history of the session in the array of preivous sessions */
	if (!cookieIdentifier)
	{
		[self finishSignUserOut];
		return;// NO;
	}
	
	/* Make sure the cookie's identifier matches the saved user's identifier,
	 otherwise, sign the user out */
	if (![cookieIdentifier isEqualToString:identifier])
	{
		[self finishSignUserOut];
		return;
	}
	
	return;
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


- (void)finishSignUserIn:(NSDictionary*)user
{
	if (currentUser)
		[self finishSignUserOut];
	
	/* Get the identifier and normalize it (remove html escapes) */
	identifier = [[[[user objectForKey:@"profile"] objectForKey:@"identifier"] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] retain];
	
	/* Get the display name */
	displayName = [[DemoUserModel getDisplayNameFromProfile:[user objectForKey:@"profile"]] retain];
	
	/* Store the current user's profile dictionary in the dictionary of users, 
	 using the identifier as the key, and then save the dictionary of users */
	NSDictionary *tmp = [prefs objectForKey:@"userProfiles"];
	
	/* If this profile doesn't already exist in the dictionary of saved profiles */
	if (![tmp objectForKey:identifier])
	{
		NSMutableDictionary* profiles = [[NSMutableDictionary alloc] 
												  initWithCapacity:([tmp count] + 1)]; 
		[profiles addEntriesFromDictionary:tmp];
		
		[profiles setObject:user forKey:identifier];
		[prefs setObject:profiles forKey:@"userProfiles"];
		
		[profiles release];
	}
	
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
	[signInDelegate release];
	signInDelegate = nil;
}

- (void)finishSignUserOut
{
	/* Save the dictionary (identifier and the timestamp) at the beginning of the array (stack) of 
	 previously logged in users one user may have multiple sessions.  Saving a list of timestamps 
	 in the previous users' dictionaries would require more work to sort in the UserProfileLevel1 
	 class, whereas the sole purpose of using this array is to preserve login order. */
	NSArray *tmp = [prefs arrayForKey:@"signinHistory"];
	NSMutableArray *signinHistory = [[NSMutableArray alloc] 
									 initWithCapacity:([tmp count] + 1)];
	[signinHistory addObjectsFromArray:tmp];
	
	[signinHistory insertObject:currentUser atIndex:0];
	
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
	[signOutDelegate release];
	signInDelegate = nil;

	/* As we remove log ins from the history, eventually we need to prune the profiles from the
	   dictionary of profiles.  We do this when the size of the signinHistory array is half 
	   of the historyCountSnapShot.  As the array grows, so does historyCountSnapShot, but
	   historyCountSnapShot only shrinks after a pruning. */
	historyCountSnapShot++;

	/* Save the historyCountSnapShot, as it may be bigger than the current array count */
	[prefs setInteger:historyCountSnapShot forKey:@"historyCount"];
}

- (void)startSignUserIn:(id<DemoUserModelDelegate>)interestedParty
{
	signInDelegate = [interestedParty retain]; 
	
	loadingUserData = YES;
	
	[jrAuthenticate showJRAuthenticateDialog];	
}

- (void)startSignUserIn:(id<DemoUserModelDelegate>)interestedPartySignIn afterSignOut:(id<DemoUserModelDelegate>)interestedPartySignOut
{
	signOutDelegate = [interestedPartySignOut retain]; 
	[self startSignUserIn:interestedPartySignIn];
}

- (void)startSignUserOut:(id<DemoUserModelDelegate>)interestedParty
{
	signOutDelegate = [interestedParty retain];
	
	[self finishSignUserOut];	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
	
	[signInDelegate didReceiveToken];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token forProvider:(NSString*)provider
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;

	currentProvider = [[NSString stringWithString:provider] retain];
	[signInDelegate didReceiveToken];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO;
	
	NSRange found = [tokenUrlPayload rangeOfString:@"{"];
	
	if (found.length == 0)
		return;
	
	NSString *userStr = [tokenUrlPayload substringFromIndex:found.location];
	NSDictionary* user = [userStr JSONValue];
	
	if(!user) // Then there was an error
		return; // TODO: manage error and memory
	
	[self finishSignUserIn:user];
}

- (void)jrAuthenticateDidNotCompleteAuthentication:(JRAuthenticate*)jrAuth
{
	loadingUserData = NO;
	[signInDelegate didFailToSignIn:nil];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSError*)error 
{
	loadingUserData = NO;
	[signInDelegate didFailToSignIn:error];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth callToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error
{
	loadingUserData = NO;
	[signInDelegate didFailToSignIn:error];
}

- (void)dealloc 
{	
	[currentUser release];	
	[currentProvider release];
	[displayName release];
	[identifier release];
	[selectedUser release];
	
	
	[super dealloc];
}

@end
