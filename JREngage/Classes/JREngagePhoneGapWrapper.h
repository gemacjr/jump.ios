//
//  JREngagePhoneGapWrapper.h
//  JREngage
//
//  Created by Lilli Szafranski on 12/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>
#import "JREngage.h"

@interface JREngagePhoneGapWrapper : PGPlugin <JREngageDelegate>
{
    JREngage *jrEngage;
    NSString *callbackID;
}

@property (nonatomic, copy) NSString* callbackID;
@end
