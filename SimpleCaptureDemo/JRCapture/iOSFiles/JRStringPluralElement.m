//
//  JRStringPluralElement.m
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRStringPluralElement.h"

@interface JRStringPluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRStringPluralElement
{
    NSNumber   *_elementId;
    NSString   *_value;
}
@synthesize type = _type;
@dynamic    elementId;
@dynamic    value;
@synthesize canBeUpdatedOrReplaced;

- (NSNumber *)elementId
{
    return _elementId;
}

- (void)setElementId:(NSNumber *)newElementId
{
    [self.dirtyPropertySet addObject:@"elementId"];
    _elementId = [newElementId copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];
    _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)stringPluralElement
{
    return [[[JRStringPluralElement alloc] init] autorelease];
}

- (id)initWithType:(NSString *)elementType
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = NO;

        _type = elementType;
    }
    return self;
}

+ (id)stringElementWithType:(NSString *)elementType
{
    return [[[JRStringPluralElement alloc] initWithType:elementType] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRStringPluralElement *stringElementCopy =
                [[JRStringPluralElement allocWithZone:zone] initWithType:self.type];

    stringElementCopy.captureObjectPath = self.captureObjectPath;

    stringElementCopy.elementId = self.elementId;
    stringElementCopy.value     = self.value;

    stringElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;

    [stringElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [stringElementCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return stringElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.elementId ? [NSNumber numberWithInteger:[self.elementId integerValue]] : [NSNull null])
             forKey:@"id"];

    if (self.value && self.value != [NSNull null])
        [dict setObject:self.value forKey:self.type];
    else
        [dict setObject:[NSNull null] forKey:self.type];

    return dict;
}

+ (id)stringElementFromDictionary:(NSDictionary*)dictionary withType:(NSString *)elementType andPath:(NSString *)capturePath
{
    JRStringPluralElement *stringElement =
        [JRStringPluralElement stringElementWithType:elementType];

    stringElement.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    stringElement.elementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ?
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    stringElement.value =
            [dictionary objectForKey:elementType] != [NSNull null] ?
            [dictionary objectForKey:elementType] : nil;

    [stringElement.dirtyPropertySet removeAllObjects];
    [stringElement.dirtyArraySet removeAllObjects];

    return stringElement;
}

+ (id)stringElementFromString:(NSString*)valueString withType:(NSString *)elementType
{
    JRStringPluralElement *stringElement =
        [JRStringPluralElement stringElementWithType:elementType];

    stringElement.value = valueString;

    [stringElement.dirtyPropertySet removeAllObjects];
    [stringElement.dirtyArraySet removeAllObjects];

    return stringElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.elementId =
            [dictionary objectForKey:@"id"] != [NSNull null] ?
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:_type])
        self.value =
            [dictionary objectForKey:_type] != [NSNull null] ?
            [dictionary objectForKey:_type] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.elementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ?
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.value =
        [dictionary objectForKey:_type] != [NSNull null] ?
        [dictionary objectForKey:_type] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

//    if ([self.dirtyPropertySet containsObject:@"elementId"])
//        [dict setObject:[NSNumber numberWithInt:self.elementId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:(self.value ? self.value : [NSNull null]) forKey:self.type];

    return dict;
}

//- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                     self, @"captureObject",
//                                                     self.captureObjectPath, @"capturePath",
//                                                     delegate, @"delegate",
//                                                     context, @"callerContext", nil];
//
//    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
////                                     withId:[self.elementId integerValue]
//                                     atPath:self.captureObjectPath
//                                  withToken:[JRCaptureData accessToken]
//                                forDelegate:self
//                                withContext:newContext];
//}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

//    [dict setObject:[NSNumber numberWithInt:self.elementId] forKey:@"id"];
    [dict setObject:(self.value ? self.value : [NSNull null]) forKey:self.type];

    return dict;
}

//- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                     self, @"captureObject",
//                                                     self.captureObjectPath, @"capturePath",
//                                                     delegate, @"delegate",
//                                                     context, @"callerContext", nil];
//
//    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
////                                      withId:[self.elementId integerValue]
//                                      atPath:self.captureObjectPath
//                                   withToken:[JRCaptureData accessToken]
//                                 forDelegate:self
//                                 withContext:newContext];
//}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"elementId"];
    [dict setObject:@"NSString" forKey:@"type"];
    [dict setObject:@"NSString" forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_value release];
    [_type release];
    [_elementId release];

    [super dealloc];
}
@end

@implementation NSArray (JRStringPluralElement)
- (NSArray*)arrayOfStringPluralDictionariesFromStringPluralElements
{
    DLog(@"");
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStringPluralElement class]])
            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

//- (NSArray *)arrayOfStringPluralUpdateDictionariesFromStringPluralElements
//{
//    DLog(@"");
//    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
//    for (NSObject *object in self)
//        if ([object isKindOfClass:[JRStringPluralElement class]])
//            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toUpdateDictionary]];
//
//    return filteredDictionaryArray;
//}

- (NSArray *)arrayOfStringPluralReplaceDictionariesFromStringPluralElements
{
    DLog(@"");
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStringPluralElement class]])
            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStringPluralElementsFromStringPluralDictionariesWithType:(NSString *)elementType andPath:(NSString *)capturePath
{
    DLog(@"");
    NSMutableArray *filteredPluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralArray addObject:[JRStringPluralElement stringElementFromDictionary:(NSDictionary*)dictionary
                                                                                     withType:elementType
                                                                                      andPath:capturePath]];

    return filteredPluralArray;
}

//- (NSArray*)arrayOfStringPluralElementsFromArrayOfStringsWithType:(NSString *)elementType
//{
//    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
//    for (NSString *valueString in self)
//        if ([valueString isKindOfClass:[NSString class]])
//            [filteredDictionaryArray addObject:[JRStringPluralElement stringElementFromString:valueString
//                                                                                     withType:elementType]];
//
//    return filteredDictionaryArray;
//}

- (NSArray*)copyArrayOfStringPluralElementsWithType:(NSString *)elementType
{
    DLog(@"");
    NSMutableArray *filteredArrayCopy = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[NSString class]])
            [filteredArrayCopy addObject:[JRStringPluralElement stringElementFromString:(NSString *)object
                                                                               withType:elementType]];
        else if ([object isKindOfClass:[JRStringPluralElement class]]) // TODO: Copy or not???
            [filteredArrayCopy addObject:[[(JRStringPluralElement *)object copy] autorelease]];

    return [filteredArrayCopy retain];
}
@end
