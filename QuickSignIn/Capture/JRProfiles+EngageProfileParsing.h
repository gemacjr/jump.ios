//
//  Created by lillialexis on 1/31/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRProfiles.h"

@interface JRProfiles (EngageProfileParsing)
+ (JRProfiles *)profilesObjectFromEngageProfileDictionary:(NSDictionary *)engageProfile;
@end
