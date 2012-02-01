//
//  Created by lillialexis on 1/31/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JRProfiles+EngageProfileParsing.h"


@implementation JRProfiles (EngageProfileParsing)
+ (JRProfiles *)profilesObjectFromEngageProfileDictionary:(NSDictionary *)engageProfile
{
    NSDictionary *profile           = [engageProfile objectForKey:@"profile"];
    NSDictionary *accessCredentials = [engageProfile objectForKey:@"accessCredentials"];
    NSDictionary *mergedPoco        = [engageProfile objectForKey:@"merged_poco"];
    NSArray      *friends           = [engageProfile objectForKey:@"friends"];

    JRProfiles *profilesObject = [JRProfiles profilesWithDomain:[profile objectForKey:@"providerName"]
                                                  andIdentifier:[profile objectForKey:@"identifier"]];

    profilesObject.accessCredentials = accessCredentials;
    profilesObject.friends           = friends;
    profilesObject.provider          = [profile objectForKey:@"providerName"];
    profilesObject.remote_key        = [profile objectForKey:@"primaryKey"];

    profilesObject.profile = [JRProfile profileObjectFromDictionary:profile];

    return profilesObject;
}
@end
