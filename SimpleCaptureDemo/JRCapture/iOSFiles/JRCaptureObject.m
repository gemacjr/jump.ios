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

#import "JRCaptureObject.h"
#import "JRStringPluralElement.h"


@implementation NSArray (StringArray)
- (NSArray *)arrayOfStringsFromStringPluralDictionariesWithType:(NSString *)type
{
    DLog(@"");

    NSMutableArray *filteredStringArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredStringArray addObject:[((NSDictionary *)dictionary) objectForKey:type]];

    return filteredStringArray;
}
@end

@interface JRCaptureObject (Internal)
@property BOOL canBeUpdatedOrReplaced;
//- (NSDictionary *)toUpdateDictionary;
//- (NSDictionary *)toReplaceDictionary;
//- (void)updateFromDictionary:(NSDictionary*)dictionary;
//- (void)replaceFromDictionary:(NSDictionary*)dictionary;
@end

@implementation JRCaptureObject
@synthesize captureObjectPath;
@synthesize dirtyPropertySet;
//@synthesize dirtyArraySet;
@synthesize canBeUpdatedOrReplaced;

- (id)init
{
    if ((self = [super init]))
    {
        dirtyPropertySet = [[NSMutableSet alloc] init];
//        dirtyArraySet    = [[NSMutableSet alloc] init];
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

- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didFailWithResult:context:)])
        [delegate updateCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)updateCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

//    [captureObject updateFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
//    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
        [delegate updateCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didFailWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didFailWithResult:result context:callerContext];
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

    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)replaceCaptureArrayDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(replaceArrayNamed:onCaptureObject:didFailWithResult:context:)])
        [delegate replaceArrayNamed:arrayName onCaptureObject:captureObject didFailWithResult:result context:callerContext];
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
    //[captureObject.dirtyArraySet removeObject:arrayName];

    if ([delegate respondsToSelector:@selector(replaceArray:named:onCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceArray:newArray named:arrayName onCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
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

//- (void)updateObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
//}
//
//- (void)replaceObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
//}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOrReplaced)
    {
        [self updateCaptureObjectDidFailWithResult:
                      @"{\"stat\":\"fail\",\"message\":\"This object or its parent is an element of an array, and the array needs to be replaced on Capture first\""
                                           context:newContext];

        return;
    }

//    if ([dirtyArraySet count])
//    {
//        [self updateCaptureObjectDidFailWithResult:
//                      [NSString stringWithFormat:@"{\"stat\":\"fail\",\"message\":\"The following arrays needs to be replaced on Capture first:%@",
//                                [[dirtyArraySet allObjects] description]]
//                                           context:newContext];
//
//        return;
//    }

    [JRCaptureApidInterface updateCaptureObject:[self toUpdateDictionary]
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
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

//- (void)replaceSimpleArrayOnCapture:(NSArray *)array ofType:(NSString *)elementType named:(NSString *)arrayName
//                        forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    NSString *captureArrayPath = [NSString stringWithFormat:@"%@/%@", self.captureObjectPath, arrayName];
//
//    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                     self, @"captureObject",
//                                                     arrayName, @"arrayName",
//                                                     elementType, @"elementType",
//                                                     self.captureObjectPath, @"capturePath",
//                                                     [NSNumber numberWithBool:YES], @"isSimpleArray",
//                                                     delegate, @"delegate",
//                                                     context, @"callerContext", nil];
//
//    [JRCaptureApidInterface replaceCaptureArray:[array arrayOfStringsFromStringPluralElements]
//                                     atPath:captureArrayPath
//                                  withToken:[JRCaptureData accessToken]
//                                forDelegate:self
//                                withContext:newContext];
//}

- (void)dealloc
{
    [captureObjectPath release];
    [dirtyPropertySet release];
    //[dirtyArraySet release];

    [super dealloc];
}
@end
