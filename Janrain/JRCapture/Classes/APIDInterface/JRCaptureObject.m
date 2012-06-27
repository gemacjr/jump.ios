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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureInternal.h"
#import "JRCaptureApidInterface.h"
#import "JRCaptureObject.h"

#import "JRCaptureData.h"

@implementation NSArray (StringArray)
// TODO: Test this!
/* If it's just an array of strings, it will return an array of string. If it's not an array of strings or
   dictionaries, it will return null.  If type is null, and it is not an array of strings, it will return null. */
- (NSArray *)arrayOfStringsFromStringPluralDictionariesWithType:(NSString *)type
{
    NSMutableArray *filteredStringArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[NSString class]])
            [filteredStringArray addObject:object];
        else if (object == [NSNull null])
            [filteredStringArray addObject:object];
        else if ([object isKindOfClass:[NSDictionary class]] && type && [((NSDictionary *)object) objectForKey:type])
            [filteredStringArray addObject:[((NSDictionary *)object) objectForKey:type]];
        else
            return nil;

    return filteredStringArray;
}
@end

@interface JRCaptureObject (Private)
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRCaptureObject
@synthesize captureObjectPath;
@synthesize dirtyPropertySet;
@synthesize canBeUpdatedOrReplaced;

- (id)init
{
    if ((self = [super init]))
    {
        dirtyPropertySet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureObject *objectCopy =
                [[[self class] allocWithZone:zone] init];

    for (NSString *dirtyProperty in [self.dirtyPropertySet allObjects])
        [objectCopy.dirtyPropertySet addObject:dirtyProperty];

    objectCopy.captureObjectPath      = self.captureObjectPath;
    objectCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;

    return objectCopy;
}

- (NSDictionary *)toDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary *)toUpdateDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary*)objectProperties
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (BOOL)needsUpdate
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return NO; // TODO: What's the better way to raise the exception in a method w a return?
}

- (void)updateFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)replaceFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)updateObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context// returningResult:(BOOL)returningResult
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     //[NSNumber numberWithBool:returningResult], @"returningResult",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOrReplaced)
    {
        [self updateCaptureObjectDidFailWithResult:
                      @"{\"stat\":\"fail\",\"message\":\"This object or its parent is an element of an array, and the array needs to be replaced on Capture first\""
                                           context:newContext];

        return;
    }

    [JRCaptureApidInterface updateCaptureObject:[self toUpdateDictionary]
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

//- (void)updateOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate context:(NSObject *)context
//{
//    [self updateObjectOnCaptureForDelegate:delegate withContext:context returningResult:NO];
//}

- (void)replaceObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context// returningResult:(BOOL)returningResult
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     //[NSNumber numberWithBool:returningResult], @"returningResult",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOrReplaced)
    {
        [self updateCaptureObjectDidFailWithResult:
                      @"{\"stat\":\"fail\",\"message\":\"This object or its parent is an element of an array, and the array needs to be replaced on Capture first\""
                                           context:newContext];

        return;
    }

    [JRCaptureApidInterface replaceCaptureObject:[self toReplaceDictionaryIncludingArrays:YES]
                                          atPath:self.captureObjectPath
                                       withToken:[JRCaptureData accessToken]
                                     forDelegate:self
                                     withContext:newContext];
}

//- (void)replaceOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate context:(NSObject *)context
//{
//    [self replaceObjectOnCaptureForDelegate:delegate withContext:context returningResult:NO];
//}

// TODO: Finish this for encoding stuff
//- (void)replaceFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
//      includingStateVariables:(BOOL)includingStateVariables
//{
//    if (includingStateVariables)
//    {
//        self.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
//
//        self.dirtyPropertySet
//    }
//
//}

- (void)replaceArrayOnCapture:(NSArray *)array named:(NSString *)arrayName isArrayOfStrings:(BOOL)isStringArray withType:(NSString *)type
                  forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    if (!type) type = @"";

    NSString *captureArrayPath = [NSString stringWithFormat:@"%@/%@", self.captureObjectPath, arrayName];
    NSString *capitalizedName  =
                    [arrayName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                       withString:[[arrayName substringToIndex:1] capitalizedString]];

    NSArray *serialized;

    if (!isStringArray)
        serialized = [array performSelector:NSSelectorFromString([NSString stringWithFormat:
                           @"arrayOf%@ReplaceDictionariesFrom%@Elements", capitalizedName, capitalizedName])];
    else
        serialized = array;

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     arrayName, @"arrayName",
                                                     self.captureObjectPath, @"capturePath",
                                                     [NSNumber numberWithBool:isStringArray], @"isStringArray",
                                                     type, @"elementType",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface replaceCaptureArray:serialized
                                         atPath:captureArrayPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    // TODO: Parse error out of result
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(updateCaptureObject:didFailWithResult:context:)])
            [delegate updateCaptureObject:captureObject didFailWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(updateDidFailForObject:withError:context:)])
            [delegate updateDidFailForObject:captureObject withError:result context:callerContext];
}

- (void)updateCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
            [delegate updateCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(updateDidSucceedForObject:context:)])
            [delegate updateDidSucceedForObject:captureObject context:callerContext];
}

- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    // TODO: Parse error out of result
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceCaptureObject:didFailWithResult:context:)])
            [delegate replaceCaptureObject:captureObject didFailWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(replaceDidFailForObject:withError:context:)])
            [delegate replaceDidFailForObject:captureObject withError:result context:callerContext];
}

- (void)replaceCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];// includingStateVariables:NO];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
            [delegate replaceCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(replaceDidSucceedForObject:context:)])
            [delegate replaceDidSucceedForObject:captureObject context:callerContext];
}

- (void)replaceCaptureArrayDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceArrayNamed:onCaptureObject:didFailWithResult:context:)])
            [delegate replaceArrayNamed:arrayName onCaptureObject:captureObject didFailWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(replaceArrayDidFailForObject:arrayNamed:withError:context:)])
            [delegate replaceArrayDidFailForObject:captureObject arrayNamed:arrayName withError:result context:callerContext];
}

- (void)replaceCaptureArrayDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    NSString        *elementType   = [myContext objectForKey:@"elementType"];
    BOOL             isStringArray = [((NSNumber *)[myContext objectForKey:@"isStringArray"]) boolValue];

    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    NSString *capitalizedName =
                        [arrayName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                           withString:[[arrayName substringToIndex:1] capitalizedString]];

    SEL setNewArrayInParentSelector =
                NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalizedName]);

    NSArray *resultsArray = [resultDictionary objectForKey:@"result"];
    NSArray *newArray;
    if (isStringArray)
    {
        newArray = [resultsArray arrayOfStringsFromStringPluralDictionariesWithType:elementType];
    }
    else
    {
        SEL arrayOfObjectsFromArrayOfDictionariesSelector = NSSelectorFromString(
                [NSString stringWithFormat:@"arrayOf%@ElementsFrom%@DictionariesWithPath:", capitalizedName, capitalizedName]);

        newArray = [resultsArray performSelector:arrayOfObjectsFromArrayOfDictionariesSelector
                                      withObject:capturePath];
    }

    [captureObject performSelector:setNewArrayInParentSelector withObject:newArray];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceArray:named:onCaptureObject:didSucceedWithResult:context:)])
            [delegate replaceArray:newArray named:arrayName onCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(replaceArrayDidSucceedForObject:newArray:named:context:)])
            [delegate replaceArrayDidSucceedForObject:captureObject newArray:newArray named:arrayName context:callerContext];
}

- (void)dealloc
{
    [captureObjectPath release];
    [dirtyPropertySet release];

    [super dealloc];
}
@end
