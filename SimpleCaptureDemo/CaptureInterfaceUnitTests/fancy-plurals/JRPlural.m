//
// Created by nathan on 6/22/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "JRPlural.h"
#import "jr_debug.h"

@implementation JRPlural

@synthesize capturePath;

- (id)init
{
    //DLog(@"");
    self = [super init];
    if (self)
    {
        backingStore = nil;
        capturePath = @"inited";
    }

    return self;
}

- (id)initWithObjects:(const id[])objects count:(NSUInteger)cnt
{
    //DLog(@"count: %d", cnt);
    if ((self = [self init]))
    {
        backingStore = [[NSArray arrayWithObjects:objects count:cnt] retain];
    }

    DLog("backingStore retaincount: %d", [backingStore retainCount]);
    return self;
}

//- (id)initWithArray:(NSArray *)array
//{
//    DLog(@"%@", [array description]);
//    if ((self = [self init]))
//    {
//        backingStore = [array copy];
//    }
//    return self;
//}

- (NSUInteger)count
{
    return [backingStore count];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [backingStore objectAtIndex:index];
}

- (void)dealloc
{
    //DLog(@"backingStore retainCount: %d", [backingStore retainCount]);
    [backingStore release]; backingStore = nil;
    [capturePath release]; capturePath = nil;
    [super dealloc];
}

@end