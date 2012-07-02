#import "JROinoL1Object.h"
#import "JROinoL2Object.h"
#import "JROinoinoL1Object.h"
#import "JROinoinoL2Object.h"
#import "JROinoinoL3Object.h"
#import "JROinonipL1PluralElement.h"
#import "JROinonipL2Object.h"
#import "JROinonipL3Object.h"
#import "JROnipL1PluralElement.h"
#import "JROnipL2Object.h"
#import "JROnipinapL1PluralElement.h"
#import "JROnipinapL2PluralElement.h"
#import "JROnipinapL3Object.h"
#import "JROnipinoL1Object.h"
#import "JROnipinoL2PluralElement.h"
#import "JROnipinoL3Object.h"
#import "JRPinapL1PluralElement.h"
#import "JRPinapL2PluralElement.h"
#import "JRPinapinapL1PluralElement.h"
#import "JRPinapinapL2PluralElement.h"
#import "JRPinapinapL3PluralElement.h"
#import "JRPinapinoL1Object.h"
#import "JRPinapinoL2PluralElement.h"
#import "JRPinapinoL3PluralElement.h"
#import "JRPinoL1Object.h"
#import "JRPinoL2PluralElement.h"
#import "JRPinoinoL1Object.h"
#import "JRPinoinoL2Object.h"
#import "JRPinoinoL3PluralElement.h"
#import "JRPinonipL1PluralElement.h"
#import "JRPinonipL2Object.h"
#import "JRPinonipL3PluralElement.h"
#import "JRPluralTestAlphabeticElement.h"
#import "JRPluralTestUniqueElement.h"
#import "JRObjectTestRequired.h"
#import "JRObjectTestRequiredUnique.h"

@interface JROinoL1Object (TestCategory)
- (BOOL)isEqualToOinoL1Object:(JROinoL1Object *)otherOinoL1Object;
+ (id)oinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinoL2Object (TestCategory)
- (BOOL)isEqualToOinoL2Object:(JROinoL2Object *)otherOinoL2Object;
+ (id)oinoL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinoinoL1Object (TestCategory)
- (BOOL)isEqualToOinoinoL1Object:(JROinoinoL1Object *)otherOinoinoL1Object;
+ (id)oinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinoinoL2Object (TestCategory)
- (BOOL)isEqualToOinoinoL2Object:(JROinoinoL2Object *)otherOinoinoL2Object;
+ (id)oinoinoL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinoinoL3Object (TestCategory)
- (BOOL)isEqualToOinoinoL3Object:(JROinoinoL3Object *)otherOinoinoL3Object;
+ (id)oinoinoL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinonipL1PluralElement (TestCategory)
- (BOOL)isEqualToOinonipL1PluralElement:(JROinonipL1PluralElement *)otherOinonipL1PluralElement;
+ (id)oinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinonipL2Object (TestCategory)
- (BOOL)isEqualToOinonipL2Object:(JROinonipL2Object *)otherOinonipL2Object;
+ (id)oinonipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROinonipL3Object (TestCategory)
- (BOOL)isEqualToOinonipL3Object:(JROinonipL3Object *)otherOinonipL3Object;
+ (id)oinonipL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipL1PluralElement (TestCategory)
- (BOOL)isEqualToOnipL1PluralElement:(JROnipL1PluralElement *)otherOnipL1PluralElement;
+ (id)onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipL2Object (TestCategory)
- (BOOL)isEqualToOnipL2Object:(JROnipL2Object *)otherOnipL2Object;
+ (id)onipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinapL1PluralElement (TestCategory)
- (BOOL)isEqualToOnipinapL1PluralElement:(JROnipinapL1PluralElement *)otherOnipinapL1PluralElement;
+ (id)onipinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinapL2PluralElement (TestCategory)
- (BOOL)isEqualToOnipinapL2PluralElement:(JROnipinapL2PluralElement *)otherOnipinapL2PluralElement;
+ (id)onipinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinapL3Object (TestCategory)
- (BOOL)isEqualToOnipinapL3Object:(JROnipinapL3Object *)otherOnipinapL3Object;
+ (id)onipinapL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinoL1Object (TestCategory)
- (BOOL)isEqualToOnipinoL1Object:(JROnipinoL1Object *)otherOnipinoL1Object;
+ (id)onipinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinoL2PluralElement (TestCategory)
- (BOOL)isEqualToOnipinoL2PluralElement:(JROnipinoL2PluralElement *)otherOnipinoL2PluralElement;
+ (id)onipinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JROnipinoL3Object (TestCategory)
- (BOOL)isEqualToOnipinoL3Object:(JROnipinoL3Object *)otherOnipinoL3Object;
+ (id)onipinoL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapL1PluralElement (TestCategory)
- (BOOL)isEqualToPinapL1PluralElement:(JRPinapL1PluralElement *)otherPinapL1PluralElement;
+ (id)pinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapL2PluralElement (TestCategory)
- (BOOL)isEqualToPinapL2PluralElement:(JRPinapL2PluralElement *)otherPinapL2PluralElement;
+ (id)pinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinapL1PluralElement (TestCategory)
- (BOOL)isEqualToPinapinapL1PluralElement:(JRPinapinapL1PluralElement *)otherPinapinapL1PluralElement;
+ (id)pinapinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinapL2PluralElement (TestCategory)
- (BOOL)isEqualToPinapinapL2PluralElement:(JRPinapinapL2PluralElement *)otherPinapinapL2PluralElement;
+ (id)pinapinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinapL3PluralElement (TestCategory)
- (BOOL)isEqualToPinapinapL3PluralElement:(JRPinapinapL3PluralElement *)otherPinapinapL3PluralElement;
+ (id)pinapinapL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinoL1Object (TestCategory)
- (BOOL)isEqualToPinapinoL1Object:(JRPinapinoL1Object *)otherPinapinoL1Object;
+ (id)pinapinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinoL2PluralElement (TestCategory)
- (BOOL)isEqualToPinapinoL2PluralElement:(JRPinapinoL2PluralElement *)otherPinapinoL2PluralElement;
+ (id)pinapinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinapinoL3PluralElement (TestCategory)
- (BOOL)isEqualToPinapinoL3PluralElement:(JRPinapinoL3PluralElement *)otherPinapinoL3PluralElement;
+ (id)pinapinoL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinoL1Object (TestCategory)
- (BOOL)isEqualToPinoL1Object:(JRPinoL1Object *)otherPinoL1Object;
+ (id)pinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinoL2PluralElement (TestCategory)
- (BOOL)isEqualToPinoL2PluralElement:(JRPinoL2PluralElement *)otherPinoL2PluralElement;
+ (id)pinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinoinoL1Object (TestCategory)
- (BOOL)isEqualToPinoinoL1Object:(JRPinoinoL1Object *)otherPinoinoL1Object;
+ (id)pinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinoinoL2Object (TestCategory)
- (BOOL)isEqualToPinoinoL2Object:(JRPinoinoL2Object *)otherPinoinoL2Object;
+ (id)pinoinoL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinoinoL3PluralElement (TestCategory)
- (BOOL)isEqualToPinoinoL3PluralElement:(JRPinoinoL3PluralElement *)otherPinoinoL3PluralElement;
+ (id)pinoinoL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinonipL1PluralElement (TestCategory)
- (BOOL)isEqualToPinonipL1PluralElement:(JRPinonipL1PluralElement *)otherPinonipL1PluralElement;
+ (id)pinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinonipL2Object (TestCategory)
- (BOOL)isEqualToPinonipL2Object:(JRPinonipL2Object *)otherPinonipL2Object;
+ (id)pinonipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPinonipL3PluralElement (TestCategory)
- (BOOL)isEqualToPinonipL3PluralElement:(JRPinonipL3PluralElement *)otherPinonipL3PluralElement;
+ (id)pinonipL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end
@interface JRPluralTestAlphabeticElement (TestCategory)
- (BOOL)isEqualToPluralTestAlphabeticElement:(JRPluralTestAlphabeticElement *)otherPluralTestAlphabeticElement;
+ (id)pluralTestAlphabeticElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRPluralTestUniqueElement (TestCategory)
- (BOOL)isEqualToPluralTestUniqueElement:(JRPluralTestUniqueElement *)otherPluralTestUniqueElement;
+ (id)pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRObjectTestRequired (TestCategory)
- (BOOL)isEqualToObjectTestRequired:(JRObjectTestRequired *)otherObjectTestRequired;
+ (id)objectTestRequiredObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface JRObjectTestRequiredUnique (TestCategory)
- (BOOL)isEqualToObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)otherObjectTestRequiredUnique;
+ (id)objectTestRequiredUniqueObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
@end

@interface NSArray (CaptureUser_ArrayComparison)
- (BOOL)isEqualToBasicPluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPluralTestUniqueArray:(NSArray *)otherArray;
- (BOOL)isEqualToPluralTestAlphabeticArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOnipL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinapinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinonipL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOnipinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOinonipL1PluralArray:(NSArray *)otherArray;
@end

