//
//  JRStringPluralElement.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCaptureInternal.h"
#import "JRCapture.h"

@interface JRStringPluralElement : JRCaptureObject
@property (nonatomic, copy)     JRObjectId *elementId;
@property (nonatomic, readonly) NSString   *type;
@property (nonatomic, copy)     NSString   *value;
+ (id)stringElementWithType:(NSString *)elementType;
- (id)initWithType:(NSString *)elementType;
@end

@interface NSArray (JRStringPluralElement)
- (NSArray *)arrayOfStringPluralDictionariesFromStringPluralElements;
//- (NSArray *)arrayOfStringPluralUpdateDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringsFromStringPluralElements;
- (NSArray *)arrayOfStringPluralElementsFromStringPluralDictionariesWithType:(NSString *)elementType andExtendedPath:(NSString *)capturePath;
//- (NSArray*)copyArrayOfStringsIntoArrayOfStringPluralElementsWithType:(NSString *)elementType;
- (NSArray*)copyArrayOfStringPluralElementsWithType:(NSString *)elementType;
@end
