//
//  JRStringPluralElement.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCaptureInternal.h"

@interface JRStringPluralElement : JRCaptureObject
// TODO: Make JRObjectId type
@property (nonatomic, copy)     JRObjectId *elementId;
@property (nonatomic, readonly) NSString   *type;
@property (nonatomic, copy)     NSString   *value;
+ (id)stringElementWithType:(NSString *)elementType;
- (id)initWithType:(NSString *)elementType;
@end

@interface NSArray (JRStringPluralElement)
- (NSArray *)arrayOfStringPluralDictionariesFromStringPluralElements;
//- (NSArray *)arrayOfStringPluralUpdateDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringPluralReplaceDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringPluralElementsFromStringPluralDictionariesWithType:(NSString *)elementType andPath:(NSString *)capturePath;
//- (NSArray*)copyArrayOfStringsIntoArrayOfStringPluralElementsWithType:(NSString *)elementType;
- (NSArray*)copyArrayOfStringPluralElementsWithType:(NSString *)elementType;
@end
