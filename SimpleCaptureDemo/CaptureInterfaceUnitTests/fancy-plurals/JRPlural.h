//
// Created by nathan on 6/22/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface JRPlural : NSArray
{
    NSString *capturePath;
    @private
    NSArray *backingStore;
}
@property(nonatomic, retain) NSString *capturePath;

@end