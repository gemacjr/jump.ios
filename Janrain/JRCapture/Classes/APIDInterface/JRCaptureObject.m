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
#import "JRCaptureObject+Internal.h"
#import "JRCaptureApidInterface.h"


#import "JRCaptureData.h"
#import "JSONKit.h"
#import "JRCaptureError.h"

@interface JRCaptureError (JRCaptureError_ApidResultErrorHelpers)
+ (NSDictionary *)invalidClassErrorForResult:(NSObject *)result;
+ (NSDictionary *)invalidStatErrorForResult:(NSObject *)result;
+ (NSDictionary *)invalidDataErrorForResult:(NSObject *)result;
@end

@implementation NSArray (JRArray_StringArray)
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

@interface JRCaptureObjectApidHandler : NSObject <JRCaptureInterfaceDelegate>
@end

@implementation JRCaptureObjectApidHandler
+ (id)captureObjectApidHandler
{
    return [[[JRCaptureObjectApidHandler alloc] init] autorelease];
}

- (void)updateCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext             = (NSDictionary *)context;
    JRCaptureObject *captureObject         = [myContext objectForKey:@"captureObject"];
    NSDictionary    *dirtyPropertySnapshot = [myContext objectForKey:@"dirtyPropertySnapshot"];
    NSObject        *callerContext         = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate> delegate   = [myContext objectForKey:@"delegate"];

    //[captureObject.dirtyPropertySet setByAddingObjectsFromSet:dirtyPropertySnapshot];
    [captureObject restoreDirtyPropertiesFromSnapshotDictionary:dirtyPropertySnapshot];

    /* Calling the old protocol methods for testing purposes, but have to make sure we pass the result string... */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(updateCaptureObject:didFailWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) updateCaptureObject:captureObject
                                                             didFailWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                       context:callerContext];

    if ([delegate respondsToSelector:@selector(updateDidFailForObject:withError:context:)])
            [delegate updateDidFailForObject:captureObject withError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)updateCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    NSString     *resultString;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        resultDictionary = (NSDictionary *)result;
        resultString     = [(NSDictionary *)result JSONString];
    }
    else if ([result isKindOfClass:[NSString class]])
    {
        resultString     = (NSString *)result;
        resultDictionary = [(NSString *)result objectFromJSONString];
    }
    else /* Uh-oh!! */
    {
        return [self updateCaptureObjectDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] context:context];
    }

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self updateCaptureObjectDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    if (![resultDictionary objectForKey:@"result"])
        return [self updateCaptureObjectDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    /* Calling the old protocol methods for testing purposes */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) updateCaptureObject:captureObject
                                                          didSucceedWithResult:resultString
                                                                       context:callerContext];

    if ([delegate respondsToSelector:@selector(updateDidSucceedForObject:context:)])
            [delegate updateDidSucceedForObject:captureObject context:callerContext];
}

- (void)replaceCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    /* Calling the old protocol methods for testing purposes, but have to make sure we pass the result string... */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceCaptureObject:didFailWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceCaptureObject:captureObject
                                                              didFailWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                        context:callerContext];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceDidFailForObject:withError:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceDidFailForObject:captureObject withError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)replaceCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    NSString     *resultString;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        resultDictionary = (NSDictionary *)result;
        resultString     = [(NSDictionary *)result JSONString];
    }
    else if ([result isKindOfClass:[NSString class]])
    {
        resultString     = (NSString *)result;
        resultDictionary = [(NSString *)result objectFromJSONString];
    }
    else /* Uh-oh!! */
    {
        return [self replaceCaptureObjectDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] context:context];
    }

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self replaceCaptureObjectDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    if (![resultDictionary objectForKey:@"result"] || ![[resultDictionary objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
        return [self replaceCaptureObjectDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    // TODO: There's an issue in the replaceOnCapture code where if a captureObject changes between the call to capture
    // and the return, those changes will be lost.  Since this is no longer a public method, I'll table it for now...
    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];

    /* Calling the old protocol methods for testing purposes */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceCaptureObject:captureObject
                                                           didSucceedWithResult:resultString
                                                                        context:callerContext];

    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceDidSucceedForObject:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceDidSucceedForObject:captureObject context:callerContext];
}

- (void)replaceCaptureArrayDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    /* Calling the old protocol methods for testing purposes, but have to make sure we pass the result string... */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceArrayNamed:onCaptureObject:didFailWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceArrayNamed:arrayName onCaptureObject:captureObject
                                                           didFailWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                     context:callerContext];

    if ([delegate respondsToSelector:@selector(replaceArrayDidFailForObject:arrayNamed:withError:context:)])
            [delegate replaceArrayDidFailForObject:captureObject arrayNamed:arrayName withError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)replaceCaptureArrayDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSString        *elementType   = [myContext objectForKey:@"elementType"];
    BOOL             isStringArray = [((NSNumber *)[myContext objectForKey:@"isStringArray"]) boolValue];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];


    NSDictionary *resultDictionary;
    NSString     *resultString;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        resultDictionary = (NSDictionary *)result;
        resultString     = [(NSDictionary *)result JSONString];
    }
    else if ([result isKindOfClass:[NSString class]])
    {
        resultString     = (NSString *)result;
        resultDictionary = [(NSString *)result objectFromJSONString];
    }
    else /* Uh-oh!! */
    {
        return [self replaceCaptureArrayDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] context:context];
    }

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self replaceCaptureArrayDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    if (![resultDictionary objectForKey:@"result"])
        return [self replaceCaptureArrayDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    NSArray *resultsArray = [resultDictionary objectForKey:@"result"];

    if (![resultsArray isKindOfClass:[NSArray class]])
        return [self replaceCaptureArrayDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    NSString *capitalizedName =
                        [arrayName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                           withString:[[arrayName substringToIndex:1] capitalizedString]];

    SEL setNewArrayInParentSelector =
                NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalizedName]);

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

    /* Calling the old protocol methods for testing purposes */
    if ([delegate conformsToProtocol:@protocol(JRCaptureObjectTesterDelegate)] &&
        [delegate respondsToSelector:@selector(replaceArray:named:onCaptureObject:didSucceedWithResult:context:)])
            [((id<JRCaptureObjectTesterDelegate>)delegate) replaceArray:newArray named:arrayName
                                                        onCaptureObject:captureObject
                                                   didSucceedWithResult:resultString
                                                                context:callerContext];

    if ([delegate respondsToSelector:@selector(replaceArrayDidSucceedForObject:newArray:named:context:)])
            [delegate replaceArrayDidSucceedForObject:captureObject newArray:newArray named:arrayName context:callerContext];
}
@end

@interface JRCaptureObject (JRCaptureObject_Private)
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCaptureObject
@synthesize captureObjectPath;
@synthesize dirtyPropertySet;
@synthesize canBeUpdatedOnCapture;

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
    JRCaptureObject *objectCopy = [[[self class] allocWithZone:zone] init];

    for (NSString *dirtyProperty in [self.dirtyPropertySet allObjects])
        [objectCopy.dirtyPropertySet addObject:dirtyProperty];

    objectCopy.captureObjectPath      = self.captureObjectPath;
    objectCopy.canBeUpdatedOnCapture  = self.canBeUpdatedOnCapture;

    return objectCopy;
}

- (NSDictionary *)toDictionaryForEncoder:(BOOL)forEncoder
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil;
}

- (NSDictionary *)toUpdateDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil;
}

- (NSDictionary *)toReplaceDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil;
}

- (NSDictionary*)objectProperties
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil;
}

- (NSSet *)setOfAllUpdatableProperties
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil;
}

- (BOOL)needsUpdate
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return NO;
}

- (NSSet *)updatablePropertySet
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return NO;
}

- (void)setAllPropertiesToDirty
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return NO;
}


- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshot
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
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

- (void)updateOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     [self snapshotDictionaryFromDirtyPropertySet], @"dirtyPropertySnapshot",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    NSDictionary *updateDictionary = [self toUpdateDictionary];

//    /* Removing the objects from the set here, because if there's an error, they will all get put back anyway... */
//    [dirtyPropertySet removeAllObjects];

    if (!self.canBeUpdatedOnCapture)
    {
        [[JRCaptureObjectApidHandler captureObjectApidHandler] updateCaptureObjectDidFailWithResult:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"error", @"stat",
                                            @"invalid_array_element", @"error",
                                            @"This object or its parent is an element of an array, and the array needs to be replaced on Capture first", @"error_description",
                                            [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidArrayElement], @"code", nil]
                                            //[NSDictionary dictionaryWithObjectsAndKeys:self.captureObjectPath, @"attribute_name", nil], @"extraFields", nil]
                                                                                context:newContext];

        return;
    }

    [JRCaptureApidInterface updateCaptureObject:updateDictionary
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:[JRCaptureObjectApidHandler captureObjectApidHandler]
                                    withContext:newContext];
}

- (void)replaceOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOnCapture)
    {
        [[JRCaptureObjectApidHandler captureObjectApidHandler] updateCaptureObjectDidFailWithResult:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"error", @"stat",
                                            @"invalid_array_element", @"error",
                                            @"This object or its parent is an element of an array, and the array needs to be replaced on Capture first", @"error_description",
                                            [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidArrayElement], @"code", nil]
                                            //[NSDictionary dictionaryWithObjectsAndKeys:self.captureObjectPath, @"attribute_name", nil], @"extraFields", nil]
                                                                                context:newContext];

        return;
    }

    [JRCaptureApidInterface replaceCaptureObject:[self toReplaceDictionary]
                                          atPath:self.captureObjectPath
                                       withToken:[JRCaptureData accessToken]
                                     forDelegate:[JRCaptureObjectApidHandler captureObjectApidHandler]
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
                                    forDelegate:[JRCaptureObjectApidHandler captureObjectApidHandler]
                                    withContext:newContext];
}

+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] updateCaptureObjectDidFailWithResult:result context:context];
}

+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] updateCaptureObjectDidSucceedWithResult:result context:context];
}

+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] replaceCaptureObjectDidFailWithResult:result context:context];
}

+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] replaceCaptureObjectDidSucceedWithResult:result context:context];
}

+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] replaceCaptureArrayDidFailWithResult:result context:context];
}

+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureObjectApidHandler captureObjectApidHandler] replaceCaptureArrayDidSucceedWithResult:result context:context];
}

- (BOOL)isEqualByPrivateProperties:(JRCaptureObject *)otherObj
{
    //DLog(@"%@: %@", [[self class] description], self.captureObjectPath);
    if (![self.captureObjectPath isEqual:otherObj.captureObjectPath]) return NO;
    if (![self.dirtyPropertySet isEqual:otherObj.dirtyPropertySet]) return NO;
    if (self.canBeUpdatedOnCapture != otherObj.canBeUpdatedOnCapture) return NO;

    NSDictionary *const props = [self objectProperties];
    for (NSString *key in props)
    {
        const SEL selectorForProp = NSSelectorFromString(key);
        id prop = [self performSelector:selectorForProp];
        id otherProp = [otherObj performSelector:selectorForProp];

        if ([prop isKindOfClass:[JRCaptureObject class]])
            if (![((JRCaptureObject *) prop) isEqualByPrivateProperties:otherProp]) return NO;

        if ([prop isKindOfClass:[NSArray class]])
        {
            for (id elmt in ((NSArray *) prop))
            {
                id otherElmt = [((NSArray *) otherProp) objectAtIndex:[((NSArray *) prop) indexOfObject:elmt]];
                if ([elmt isKindOfClass:[JRCaptureObject class]])
                    if (![((JRCaptureObject *) elmt) isEqualByPrivateProperties:otherElmt]) return NO;
            }
        }
    }
    return YES;
}

- (void)dealloc
{
    [captureObjectPath release];
    [dirtyPropertySet release];

    [super dealloc];
}
@end
