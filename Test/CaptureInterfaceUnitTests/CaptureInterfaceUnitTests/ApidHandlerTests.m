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

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

#define _sel       NSStringFromSelector(_cmd)
#define _csel      [NSString stringWithFormat:@"%@%@%@", @"continue", @".", _sel]
#define _fsel      [NSString stringWithFormat:@"%@%@%@", @"finish", @".", _sel]
#define _esel      [NSString stringWithFormat:@"%@%@%@", kJRApidResultFail, @".", _sel]
#define _ctel(str) [NSString stringWithFormat:@"%@%@%@", @"continue", @".", str]
#define _cnel(n,s) [NSString stringWithFormat:@"%@%@%@%@", @"continue", n, @".", s]
#define _ftel(str) [NSString stringWithFormat:@"%@%@%@", @"finish", @".", str]
#define _nsel(str) NSSelectorFromString(str)

#define kJRCallerContext         @"callerContext"
#define kJRCaptureObject         @"captureObject"
#define kJRCaptureUser           @"captureUser"
#define kJRCapturePath           @"capturePath"
#define kJRDirtyPropertySnapshot @"dirtyPropertySnapshot"
#define kJRDelegate              @"delegate"
#define kJRArrayName             @"arrayName"
#define kJRElementType           @"elementType"
#define kJRIsStringArray         @"isStringArray"
#define kJRNewArray              @"newArray"

#define kJRApidResult            @"apidResult"
#define kJRApidResultFail        @"fail"
#define kJRApidResultSuccess     @"success"
#define kJRError                 @"error"
#define kJRTesterDelegateResult  @"testerDelegateResult"
#define kJRSuccessCaseSuffix     @"_SuccessCase_withArguments:"

#define resultNil                       nil
#define resultNonJson                   @"not a json string"
#define resultBadJson                   @"{:\"()bad json \t string]"
#define resultEmptyString               @""
#define resultNonString                 [NSNull null]
#define resultMissingStat               @"{\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultBadStat                   @"{\"stat\":\"uhoh\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultEmptyStat                 @"{\"stat\":\"\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultMissing                   @"{\"stat\":\"ok\"}"
#define resultBad                       @"{\"stat\":\"ok\",\"result\":\"not a good result\"}"
#define resultEmpty                     @"{\"stat\":\"ok\",\"result\":\"\"}"
#define resultExpected                  @"{\"stat\":\"ok\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultUnexpected                @"{\"stat\":\"ok\",\"result\":{\"notTheBasicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"notTheBasicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"notTheSimpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultArrayExpected             @"{\"stat\":\"ok\",\"result\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}]}"
#define resultArrayUnexpected           @"{\"stat\":\"ok\",\"result\":{\"notExpected\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"extraString\":\"extraString\",\"id\":11},{\"string1\":\"string1\",\"noString2\":\"noString2\",\"id\":12}]}}"
#define resultArrayMissingIds           @"{\"stat\":\"ok\",\"result\":[{\"string1\":\"string1\",\"string2\":\"string2\"},{\"string1\":\"string1\",\"string2\":\"string2\"}]}"
#define resultStringArrayExpected       @"{\"stat\":\"ok\",\"result\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}"
#define resultStringArrayUnexpected     @"{\"stat\":\"ok\",\"result\":{\"notExpected\":[{\"notTheSimpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultStringArrayMissingIds     @"{\"stat\":\"ok\",\"result\":[{\"simpleTypeOne\":\"string1\"},{\"simpleTypeOne\":\"string2\"},{\"simpleTypeOne\":\"string3\"}]}"
#define resultUserExpected              @"{\"stat\":\"ok\",\"access_token\":\"ve5agstyyb9gqzjm\",\"result\":{\"basicIpAddress\":null,\"basicPassword\":null,\"onipinapL1Plural\":[{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"onipinapL2Plural\":[],\"id\":5218},{\"string1\":\"beaumont\",\"string2\":\"battlezone\",\"onipinapL2Plural\":[{\"string1\":\"asteroids\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"amnesia\",\"id\":5220},{\"string1\":\"battlezone\",\"onipinapL3Object\":{\"string1\":\"amnesia\",\"string2\":\"akita\"},\"string2\":\"bridgeport\",\"id\":5221},{\"string1\":\"centipede\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"cascade\",\"id\":5222}],\"id\":5219},{\"string1\":\"concordia\",\"string2\":\"centipede\",\"onipinapL2Plural\":[],\"id\":5223}],\"stringTestNSNull\":null,\"stringTestFeatures\":null,\"pinonipL1Plural\":[],\"stringTestUnicodePrintable\":null,\"oinoinoL1Object\":{\"string1\":null,\"oinoinoL2Object\":{\"oinoinoL3Object\":{\"string1\":null,\"string2\":null},\"string1\":null,\"string2\":null},\"string2\":null},\"pinapinoL1Object\":{\"string1\":null,\"string2\":null,\"pinapinoL2Plural\":[]},\"stringTestEmpty\":null,\"simpleStringPluralTwo\":[],\"stringTestUnicodeLetters\":null,\"basicDecimal\":null,\"jsonArray\":null,\"jsonDictionary\":null,\"pinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoL2Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5161},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5162},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5163}]},\"created\":\"2012-06-07 20:52:45.675771 +0000\",\"pluralTestUnique\":[{\"string1\":\"asteroids\",\"string2\":\"battlezone\",\"uniqueString\":\"centipede\",\"id\":5263},{\"string1\":\"amnesia\",\"string2\":\"bridgeport\",\"uniqueString\":\"cascade\",\"id\":5264}],\"onipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5164},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5165},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"onipL2Object\":{\"string1\":null,\"string2\":null},\"id\":5166}],\"stringTestInvalid\":null,\"pinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5149,\"pinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5150},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5151},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5152}]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5153,\"pinapL2Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5154},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5155},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5156}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5157,\"pinapL2Plural\":[]}],\"pluralTestAlphabetic\":[{\"string1\":null,\"string2\":null,\"uniqueString\":\"abc\",\"id\":5267}],\"id\":680,\"jsonString\":null,\"uuid\":\"2038f644-6b4d-4f7c-a51c-a316791bb940\",\"email\":\"lilli@janrain.com\",\"basicInteger\":null,\"basicPlural\":[],\"stringTestAlphanumeric\":null,\"oinoL1Object\":{\"string1\":null,\"string2\":null,\"oinoL2Object\":{\"string1\":null,\"string2\":null}},\"basicString\":null,\"lastUpdated\":\"2012-07-03 22:14:43.004941 +0000\",\"basicObject\":{\"string1\":null,\"string2\":null},\"stringTestLength\":null,\"basicBoolean\":true,\"basicDate\":null,\"objectTestRequiredUnique\":{\"uniqueString\":null,\"requiredString\":\"required\",\"requiredUniqueString\":\"requiredUnique\"},\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"asteroids\",\"id\":5134},{\"simpleTypeOne\":\"battlezone\",\"id\":5135},{\"simpleTypeOne\":\"centipede\",\"id\":5136},{\"simpleTypeOne\":\"asteroids\",\"id\":5137},{\"simpleTypeOne\":\"battlezone\",\"id\":5138},{\"simpleTypeOne\":\"centipede\",\"id\":5139}],\"stringTestEmailAddress\":null,\"stringTestNull\":null,\"pinoinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoinoL2Object\":{\"string1\":null,\"string2\":null,\"pinoinoL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5209},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5210},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5211}]}},\"onipinoL1Object\":{\"string1\":null,\"string2\":null,\"onipinoL2Plural\":[]},\"oinonipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5260,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5261,\"oinonipL2Object\":{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"oinonipL3Object\":{\"string1\":\"asteroids\",\"string2\":\"amnesia\"}}},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5262,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}}],\"jsonNumber\":null,\"pinapinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5194,\"pinapinapL2Plural\":[]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5195,\"pinapinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5196,\"pinapinapL3Plural\":[]},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5197,\"pinapinapL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5198},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5199},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5200}]},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5201,\"pinapinapL3Plural\":[]}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5202,\"pinapinapL2Plural\":[]}],\"stringTestCaseSensitive\":null,\"basicDateTime\":null,\"stringTestJson\":null,\"objectTestRequired\":{\"string1\":null,\"string2\":null,\"requiredString\":\"required\"}}}"
#define resultUserUnexpected            @"{\"stat\":\"ok\",\"access_token\":\"ve5agstyyb9gqzjm\",\"result\":[{\"basicIpAddress\":null,\"basicPassword\":null,\"onipinapL1Plural\":[{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"onipinapL2Plural\":[],\"id\":5218},{\"string1\":\"beaumont\",\"string2\":\"battlezone\",\"onipinapL2Plural\":[{\"string1\":\"asteroids\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"amnesia\",\"id\":5220},{\"string1\":\"battlezone\",\"onipinapL3Object\":{\"string1\":\"amnesia\",\"string2\":\"akita\"},\"string2\":\"bridgeport\",\"id\":5221},{\"string1\":\"centipede\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"cascade\",\"id\":5222}],\"id\":5219},{\"string1\":\"concordia\",\"string2\":\"centipede\",\"onipinapL2Plural\":[],\"id\":5223}],\"stringTestNSNull\":null,\"stringTestFeatures\":null,\"pinonipL1Plural\":[],\"stringTestUnicodePrintable\":null,\"oinoinoL1Object\":{\"string1\":null,\"oinoinoL2Object\":{\"oinoinoL3Object\":{\"string1\":null,\"string2\":null},\"string1\":null,\"string2\":null},\"string2\":null},\"pinapinoL1Object\":{\"string1\":null,\"string2\":null,\"pinapinoL2Plural\":[]},\"stringTestEmpty\":null,\"simpleStringPluralTwo\":[],\"stringTestUnicodeLetters\":null,\"basicDecimal\":null,\"jsonArray\":null,\"jsonDictionary\":null,\"pinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoL2Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5161},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5162},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5163}]},\"created\":\"2012-06-07 20:52:45.675771 +0000\",\"pluralTestUnique\":[{\"string1\":\"asteroids\",\"string2\":\"battlezone\",\"uniqueString\":\"centipede\",\"id\":5263},{\"string1\":\"amnesia\",\"string2\":\"bridgeport\",\"uniqueString\":\"cascade\",\"id\":5264}],\"onipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5164},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5165},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"onipL2Object\":{\"string1\":null,\"string2\":null},\"id\":5166}],\"stringTestInvalid\":null,\"pinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5149,\"pinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5150},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5151},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5152}]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5153,\"pinapL2Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5154},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5155},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5156}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5157,\"pinapL2Plural\":[]}],\"pluralTestAlphabetic\":[{\"string1\":null,\"string2\":null,\"uniqueString\":\"abc\",\"id\":5267}],\"id\":680,\"jsonString\":null,\"uuid\":\"2038f644-6b4d-4f7c-a51c-a316791bb940\",\"email\":\"lilli@janrain.com\",\"basicInteger\":null,\"basicPlural\":[],\"stringTestAlphanumeric\":null,\"oinoL1Object\":{\"string1\":null,\"string2\":null,\"oinoL2Object\":{\"string1\":null,\"string2\":null}},\"basicString\":null,\"lastUpdated\":\"2012-07-03 22:14:43.004941 +0000\",\"basicObject\":{\"string1\":null,\"string2\":null},\"stringTestLength\":null,\"basicBoolean\":true,\"basicDate\":null,\"objectTestRequiredUnique\":{\"uniqueString\":null,\"requiredString\":\"required\",\"requiredUniqueString\":\"requiredUnique\"},\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"asteroids\",\"id\":5134},{\"simpleTypeOne\":\"battlezone\",\"id\":5135},{\"simpleTypeOne\":\"centipede\",\"id\":5136},{\"simpleTypeOne\":\"asteroids\",\"id\":5137},{\"simpleTypeOne\":\"battlezone\",\"id\":5138},{\"simpleTypeOne\":\"centipede\",\"id\":5139}],\"stringTestEmailAddress\":null,\"stringTestNull\":null,\"pinoinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoinoL2Object\":{\"string1\":null,\"string2\":null,\"pinoinoL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5209},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5210},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5211}]}},\"onipinoL1Object\":{\"string1\":null,\"string2\":null,\"onipinoL2Plural\":[]},\"oinonipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5260,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5261,\"oinonipL2Object\":{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"oinonipL3Object\":{\"string1\":\"asteroids\",\"string2\":\"amnesia\"}}},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5262,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}}],\"jsonNumber\":null,\"pinapinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5194,\"pinapinapL2Plural\":[]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5195,\"pinapinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5196,\"pinapinapL3Plural\":[]},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5197,\"pinapinapL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5198},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5199},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5200}]},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5201,\"pinapinapL3Plural\":[]}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5202,\"pinapinapL2Plural\":[]}],\"stringTestCaseSensitive\":null,\"basicDateTime\":null,\"stringTestJson\":null,\"objectTestRequired\":{\"string1\":null,\"string2\":null,\"requiredString\":\"required\"}}]}"
#define resultUserMissingAccessToken    @"{\"stat\":\"ok\",\"result\":{\"basicIpAddress\":null,\"basicPassword\":null,\"onipinapL1Plural\":[{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"onipinapL2Plural\":[],\"id\":5218},{\"string1\":\"beaumont\",\"string2\":\"battlezone\",\"onipinapL2Plural\":[{\"string1\":\"asteroids\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"amnesia\",\"id\":5220},{\"string1\":\"battlezone\",\"onipinapL3Object\":{\"string1\":\"amnesia\",\"string2\":\"akita\"},\"string2\":\"bridgeport\",\"id\":5221},{\"string1\":\"centipede\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"cascade\",\"id\":5222}],\"id\":5219},{\"string1\":\"concordia\",\"string2\":\"centipede\",\"onipinapL2Plural\":[],\"id\":5223}],\"stringTestNSNull\":null,\"stringTestFeatures\":null,\"pinonipL1Plural\":[],\"stringTestUnicodePrintable\":null,\"oinoinoL1Object\":{\"string1\":null,\"oinoinoL2Object\":{\"oinoinoL3Object\":{\"string1\":null,\"string2\":null},\"string1\":null,\"string2\":null},\"string2\":null},\"pinapinoL1Object\":{\"string1\":null,\"string2\":null,\"pinapinoL2Plural\":[]},\"stringTestEmpty\":null,\"simpleStringPluralTwo\":[],\"stringTestUnicodeLetters\":null,\"basicDecimal\":null,\"jsonArray\":null,\"jsonDictionary\":null,\"pinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoL2Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5161},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5162},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5163}]},\"created\":\"2012-06-07 20:52:45.675771 +0000\",\"pluralTestUnique\":[{\"string1\":\"asteroids\",\"string2\":\"battlezone\",\"uniqueString\":\"centipede\",\"id\":5263},{\"string1\":\"amnesia\",\"string2\":\"bridgeport\",\"uniqueString\":\"cascade\",\"id\":5264}],\"onipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5164},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"onipL2Object\":{\"string1\":\"apples\",\"string2\":\"alameda\"},\"id\":5165},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"onipL2Object\":{\"string1\":null,\"string2\":null},\"id\":5166}],\"stringTestInvalid\":null,\"pinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5149,\"pinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5150},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5151},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5152}]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5153,\"pinapL2Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5154},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5155},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5156}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5157,\"pinapL2Plural\":[]}],\"pluralTestAlphabetic\":[{\"string1\":null,\"string2\":null,\"uniqueString\":\"abc\",\"id\":5267}],\"id\":680,\"jsonString\":null,\"uuid\":\"2038f644-6b4d-4f7c-a51c-a316791bb940\",\"email\":\"lilli@janrain.com\",\"basicInteger\":null,\"basicPlural\":[],\"stringTestAlphanumeric\":null,\"oinoL1Object\":{\"string1\":null,\"string2\":null,\"oinoL2Object\":{\"string1\":null,\"string2\":null}},\"basicString\":null,\"lastUpdated\":\"2012-07-03 22:14:43.004941 +0000\",\"basicObject\":{\"string1\":null,\"string2\":null},\"stringTestLength\":null,\"basicBoolean\":true,\"basicDate\":null,\"objectTestRequiredUnique\":{\"uniqueString\":null,\"requiredString\":\"required\",\"requiredUniqueString\":\"requiredUnique\"},\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"asteroids\",\"id\":5134},{\"simpleTypeOne\":\"battlezone\",\"id\":5135},{\"simpleTypeOne\":\"centipede\",\"id\":5136},{\"simpleTypeOne\":\"asteroids\",\"id\":5137},{\"simpleTypeOne\":\"battlezone\",\"id\":5138},{\"simpleTypeOne\":\"centipede\",\"id\":5139}],\"stringTestEmailAddress\":null,\"stringTestNull\":null,\"pinoinoL1Object\":{\"string1\":null,\"string2\":null,\"pinoinoL2Object\":{\"string1\":null,\"string2\":null,\"pinoinoL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5209},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5210},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5211}]}},\"onipinoL1Object\":{\"string1\":null,\"string2\":null,\"onipinoL2Plural\":[]},\"oinonipL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5260,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5261,\"oinonipL2Object\":{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"oinonipL3Object\":{\"string1\":\"asteroids\",\"string2\":\"amnesia\"}}},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5262,\"oinonipL2Object\":{\"string1\":null,\"string2\":null,\"oinonipL3Object\":{\"string1\":null,\"string2\":null}}}],\"jsonNumber\":null,\"pinapinapL1Plural\":[{\"string1\":\"apples\",\"string2\":\"alameda\",\"id\":5194,\"pinapinapL2Plural\":[]},{\"string1\":\"bananas\",\"string2\":\"beaumont\",\"id\":5195,\"pinapinapL2Plural\":[{\"string1\":\"asteroids\",\"string2\":\"amnesia\",\"id\":5196,\"pinapinapL3Plural\":[]},{\"string1\":\"battlezone\",\"string2\":\"bridgeport\",\"id\":5197,\"pinapinapL3Plural\":[{\"string1\":\"amnesia\",\"string2\":\"akita\",\"id\":5198},{\"string1\":\"bridgeport\",\"string2\":\"bulldog\",\"id\":5199},{\"string1\":\"cascade\",\"string2\":\"collie\",\"id\":5200}]},{\"string1\":\"centipede\",\"string2\":\"cascade\",\"id\":5201,\"pinapinapL3Plural\":[]}]},{\"string1\":\"coconuts\",\"string2\":\"concordia\",\"id\":5202,\"pinapinapL2Plural\":[]}],\"stringTestCaseSensitive\":null,\"basicDateTime\":null,\"stringTestJson\":null,\"objectTestRequired\":{\"string1\":null,\"string2\":null,\"requiredString\":\"required\"}}}"
#define resultUserMissingIds            @"{\"stat\":\"ok\",\"access_token\":\"ve5agstyyb9gqzjm\",\"result\":{\"onipinapL1Plural\":[{\"string1\":\"alameda\",\"string2\":\"asteroids\",\"onipinapL2Plural\":[]},{\"string1\":\"beaumont\",\"string2\":\"battlezone\",\"onipinapL2Plural\":[{\"string1\":\"asteroids\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"amnesia\"},{\"string1\":\"battlezone\",\"onipinapL3Object\":{\"string1\":\"amnesia\",\"string2\":\"akita\"},\"string2\":\"bridgeport\"},{\"string1\":\"centipede\",\"onipinapL3Object\":{\"string1\":null,\"string2\":null},\"string2\":\"cascade\"}]},{\"string1\":\"concordia\",\"string2\":\"centipede\",\"onipinapL2Plural\":[]}]}}"
#define resultFetchLastUpExpected       @"{\"stat\":\"ok\",\"result\":\"2012-07-03 22:14:43.004941 +0000\"}"
#define resultFetchLastUpUnexpected     @"{\"stat\":\"ok\",\"result\":\"bad stuff here\"}"
#define resultFetchObjectExpected       @"{\"stat\":\"ok\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"}}"
#define resultFetchObjectUnexpected     @"{\"stat\":\"ok\",\"result\":{\"notTheBasicObject\":{\"badString1\":\"string1\",\"string2\":\"string2\"}}"

@interface JRCaptureObject (TestCategory)
+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
@end

@interface JRCaptureUser (TestCategory)
+ (void)testCaptureUserApidHandlerCreateCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
@end

@interface e2_ApidHandlerTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate, JRCaptureUserTesterDelegate>
{
    JRCaptureUser       *captureUser;
    NSMutableDictionary *defaultContext;
    NSMutableDictionary *defaultArrayContext;
    NSMutableDictionary *defaultStringArrayContext;
    NSMutableDictionary *defaultGetObjectContext;

    NSMutableDictionary *finisherArguments;
}
@property (retain) JRCaptureUser       *captureUser;
@property (retain) NSMutableDictionary *defaultContext;
@property (retain) NSMutableDictionary *defaultArrayContext;
@property (retain) NSMutableDictionary *defaultStringArrayContext;
@property (retain) NSMutableDictionary *defaultGetObjectContext;
@property (retain) NSMutableDictionary *finisherArguments;
@end

@implementation e2_ApidHandlerTests
@synthesize captureUser;
@synthesize defaultContext;
@synthesize defaultArrayContext;
@synthesize defaultStringArrayContext;
@synthesize defaultGetObjectContext;
@synthesize finisherArguments;


- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];

    self.captureUser = [SharedData getBlankCaptureUser];

    self.captureUser.basicObject = [JRBasicObject basicObject];

    self.captureUser.basicObject.string1 = @"string1";
    self.captureUser.basicObject.string2 = @"string2";

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    JRBasicPluralElement *element1 = [JRBasicPluralElement basicPluralElement];
    JRBasicPluralElement *element2 = [JRBasicPluralElement basicPluralElement];

    element1.string1 = element2.string1 = @"string1";
    element1.string2 = element2.string2 = @"string2";

    [array addObject:element1];
    [array addObject:element2];

    self.captureUser.basicPlural = array;

    self.captureUser.simpleStringPluralOne = [NSArray arrayWithObjects:@"string1", @"string2", @"string3", nil];

    self.defaultContext      = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            self.captureUser, kJRCaptureUser,
                                                            self.captureUser, kJRCaptureObject,
                                                            @"", kJRCapturePath,
                                                            [NSDictionary dictionary], kJRDirtyPropertySnapshot,
                                                            self, kJRDelegate, nil];

    self.defaultArrayContext = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @"basicPlural", kJRArrayName,
                                                            @"basicPluralElement", kJRElementType,
                                                            [NSNumber numberWithBool:NO], kJRIsStringArray,
                                                            nil];

    [self.defaultArrayContext addEntriesFromDictionary:defaultContext];

    self.defaultStringArrayContext = [NSMutableDictionary dictionaryWithDictionary:defaultArrayContext];

    [self.defaultStringArrayContext setObject:@"simpleStringPluralOne"      forKey:kJRArrayName];
    [self.defaultStringArrayContext setObject:@"simpleTypeOne"              forKey:kJRElementType];
    [self.defaultStringArrayContext setObject:[NSNumber numberWithBool:YES] forKey:kJRIsStringArray];

    self.defaultGetObjectContext = [NSMutableDictionary dictionaryWithDictionary:defaultContext];
}

- (void)setCapturePathForGetObjectContext:(NSString *)capturePath
{
    [self.defaultGetObjectContext setObject:capturePath forKey:kJRCapturePath];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser = nil;
}

- (void)setUp
{
    self.finisherArguments = [NSMutableDictionary dictionaryWithCapacity:10];
}

- (void)tearDown
{
    self.captureUser = nil;
}

- (void)test_e200_update_resultNil
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e200_update_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e201_update_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e201_update_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e202_update_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e202_update_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e203_update_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e203_update_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e204_update_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e204_update_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e205_update_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e205_update_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e206_update_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e206_update_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e207_update_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e207_update_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e208_update_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e208_update_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

/* As update does not parse the result, this is a success case, even if the result is bad */
- (void)test_e209_update_resultBad_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e209_update_resultBad_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

/* As update does not parse the result, this is a success case, even if the result is bad */
- (void)test_e210_update_resultEmpty_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e210_update_resultEmpty_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e211_update_resultExpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e211_update_resultExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e212_update_resultUnexpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e212_update_resultUnexpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e220_replace_resultNil
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e220_replace_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e221_replace_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e221_replace_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e222_replace_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e222_replace_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e223_replace_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e223_replace_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e224_replace_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e224_replace_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e225_replace_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e225_replace_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e226_replace_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e226_replace_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e227_replace_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e227_replace_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e228_replace_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e228_replace_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e229_replace_resultBad
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    //[self prepare];
    @try
    {
        [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    }
    @catch (NSException* exception)
    {
        if (![exception.name isEqualToString:@"NSInvalidArgumentException"])
            [exception raise];
    }

    //[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}
//
//- (void)finish_e229_replace_resultBad_withArguments:(NSDictionary *)arguments
//{
//    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
//    NSError  *error                = [arguments objectForKey:kJRError];
//    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];
//
//    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
//                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
//            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);
//
//    GHAssertNotNil(error, nil);
//    GHAssertNotNil(testerDelegateResult, nil);
//}

- (void)test_e230_replace_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e230_replace_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e231_replace_resultExpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e231_replace_resultExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

/* This is not so much a success case, but the replacingWithDictionary code on the captureObject just ignores anything that's
   in the result dictionary with keys that don't match the property keys. Not sure if/how to write code to validate the result
   or if it's even necessary... */
- (void)test_e232_replace_resultUnexpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e232_replace_resultUnexpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);

}


- (void)test_e240_replaceArray_resultNil
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNil context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e240_replaceArray_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e241_replaceArray_resultNonJson
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonJson context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e241_replaceArray_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e242_replaceArray_resultBadJson
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadJson context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e242_replaceArray_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e243_replaceArray_resultEmptyString
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyString context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e243_replaceArray_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e244_replaceArray_resultNonString
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonString context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e244_replaceArray_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e245_replaceArray_resultMissingStat
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissingStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e245_replaceArray_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e246_replaceArray_resultBadStat
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e246_replaceArray_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e247_replaceArray_resultEmptyStat
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e247_replaceArray_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e248_replaceArray_resultMissing
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissing context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e248_replaceArray_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e249_replaceArray_resultBad
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBad context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e249_replaceArray_resultBad_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e250_replaceArray_resultEmpty
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmpty context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e250_replaceArray_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e251_replaceArray_resultArrayExpected_SuccessCase
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayExpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e251_replaceArray_resultArrayExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e252_replaceArray_resultArrayUnexpected
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayUnexpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e252_replaceArray_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

/* This is not so much a success case, but the replacingWithDictionary code on the captureObject just ignores anything that's
   in the result dictionary with keys that don't match the property keys or properties with missing keys. Not sure
   if/how to write code to validate the result or if it's even necessary... */
- (void)test_e253_replaceArray_resultArrayMissingIds_SuccessCase
{
    [self.defaultArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayMissingIds context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e253_replaceArray_resultArrayMissingIds_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e254_replaceStringArray_resultNil
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNil context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e254_replaceStringArray_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e255_replaceStringArray_resultNonJson
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonJson context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e255_replaceStringArray_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e256_replaceStringArray_resultBadJson
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadJson context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e256_replaceStringArray_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e257_replaceStringArray_resultEmptyString
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyString context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e257_replaceStringArray_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e258_replaceStringArray_resultNonString
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonString context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e258_replaceStringArray_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e259_replaceStringArray_resultMissingStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissingStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e259_replaceStringArray_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e260_replaceStringArray_resultBadStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e260_replaceStringArray_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e261_replaceStringArray_resultEmptyStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e261_replaceStringArray_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e262_replaceStringArray_resultMissing
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissing context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e262_replaceStringArray_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e263_replaceStringArray_resultBad
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBad context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e263_replaceStringArray_resultBad_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e264_replaceStringArray_resultEmpty
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmpty context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e264_replaceStringArray_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e265_replaceStringArray_resultStringArrayExpected_SuccessCase
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayExpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e265_replaceStringArray_resultStringArrayExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e266_replaceStringArray_resultStringArrayUnexpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayUnexpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e266_replaceStringArray_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

/* This is not so much a success case, but the replacingWithDictionary code on the captureObject just ignores anything that's
   in the result dictionary with keys that don't match the property keys or properties with missing keys. Not sure
   if/how to write code to validate the result or if it's even necessary... */
- (void)test_e267_replaceStringArray_resultStringArrayMissingIds_SuccessCase
{
    [self.defaultStringArrayContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayMissingIds context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e267_replaceStringArray_resultStringArrayMissingIds_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e270_createUser_resultNil
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e270_createUser_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e271_createUser_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e271_createUser_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e272_createUser_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e272_createUser_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e273_createUser_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e273_createUser_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e274_createUser_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e274_createUser_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e275_createUser_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e275_createUser_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e276_createUser_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e276_createUser_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e277_createUser_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e277_createUser_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e278_createUser_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e278_createUser_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e279_createUser_resultBad
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e279_createUser_resultBad_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e280_createUser_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e280_createUser_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e281_createUser_resultUserExpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e281_createUser_resultUserExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e282_createUser_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e282_createUser_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

/* This is not so much a success case, but the replacingWithDictionary code on the captureObject just ignores anything that's
   in the result dictionary with keys that don't match the property keys or properties with missing keys. Not sure
   if/how to write code to validate the result or if it's even necessary... */
- (void)test_e283_createUser_resultUserMissingIds_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e283_createUser_resultUserMissingIds_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}



- (void)test_e284_createUser_resultUserMissingAccessToken
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserMissingAccessToken context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e284_createUser_resultUserMissingAccessToken_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];
    NSString *testerDelegateResult = [arguments objectForKey:kJRTesterDelegateResult];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
    GHAssertNotNil(testerDelegateResult, nil);
}

- (void)test_e285_fetchUser_resultNil
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e285_fetchUser_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e286_fetchUser_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e286_fetchUser_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e287_fetchUser_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e287_fetchUser_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e288_fetchUser_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e288_fetchUser_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e289_fetchUser_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e289_fetchUser_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e290_fetchUser_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e290_fetchUser_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e291_fetchUser_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e291_fetchUser_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e293_fetchUser_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e293_fetchUser_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e294_fetchUser_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e294_fetchUser_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e295_fetchUser_resultBad
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e295_fetchUser_resultBad_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e296_fetchUser_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e296_fetchUser_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e297_fetchUser_resultUserExpected_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e297_fetchUser_resultUserExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e298_fetchUser_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e298_fetchUser_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

/* This is not so much a success case, but the replacingWithDictionary code on the captureObject just ignores anything that's
   in the result dictionary with keys that don't match the property keys or properties with missing keys. Not sure
   if/how to write code to validate the result or if it's even necessary... */
- (void)test_e299_fetchUser_resultUserMissingIds_SuccessCase
{
    [self.defaultContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e299_fetchUser_resultUserMissingIds_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e2910_fetchLastUpdated_resultNil
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNil context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2910_fetchLastUpdated_resultNil_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2911_fetchLastUpdated_resultNonJson
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonJson context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2911_fetchLastUpdated_resultNonJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2912_fetchLastUpdated_resultBadJson
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadJson context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2912_fetchLastUpdated_resultBadJson_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2913_fetchLastUpdated_resultEmptyString
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2913_fetchLastUpdated_resultEmptyString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2914_fetchLastUpdated_resultNonString
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonString context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2914_fetchLastUpdated_resultNonString_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2915_fetchLastUpdated_resultMissingStat
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2915_fetchLastUpdated_resultMissingStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2916_fetchLastUpdated_resultBadStat
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadStat context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2916_fetchLastUpdated_resultBadStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2917_fetchLastUpdated_resultEmptyStat
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2917_fetchLastUpdated_resultEmptyStat_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2918_fetchLastUpdated_resultMissing
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissing context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2918_fetchLastUpdated_resultMissing_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2919_fetchLastUpdated_resultEmpty
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmpty context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2919_fetchLastUpdated_resultEmpty_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2920_fetchLastUpdated_resultExpected_SuccessCase
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultFetchLastUpExpected context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2920_fetchLastUpdated_resultExpected_SuccessCase_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNil(error, nil);
}

- (void)test_e2921_fetchLastUpdated_resultUnexpected
{
    [self setCapturePathForGetObjectContext:@"/lastUpdated"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultFetchLastUpUnexpected context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2921_fetchLastUpdated_resultUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}

- (void)test_e2922_fetchObject_resultExpected
{
    [self setCapturePathForGetObjectContext:@"/basicObject"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultFetchObjectExpected context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2922_fetchObject_resultExpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    /* Should be nil */
    GHAssertNotNil(error, nil);
}

- (void)test_e2923_fetchObject_resultUnexpected
{
    [self setCapturePathForGetObjectContext:@"/basicObject"];
    [self.defaultGetObjectContext setObject:_fsel forKey:kJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultFetchObjectUnexpected context:defaultGetObjectContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2923_fetchObject_resultUnexpected_withArguments:(NSDictionary *)arguments
{
    NSString *apidResult           = [arguments objectForKey:kJRApidResult];
    NSError  *error                = [arguments objectForKey:kJRError];

    GHAssertTrue((([apidResult isEqualToString:kJRApidResultFail] && ![_sel hasSuffix:kJRSuccessCaseSuffix]) ||
                 ([apidResult isEqualToString:kJRApidResultSuccess] && [_sel hasSuffix:kJRSuccessCaseSuffix])),
            @"Unexpected test result: %@ for selector: %@", apidResult, _sel);

    GHAssertNotNil(error, nil);
}


typedef enum
{
    ApidStatusSuccess,
    ApidStatusFail,
} ApidStatus;

- (void)notifyFinisher:(NSString *)finisherString ofStatus:(ApidStatus)apidStatus withArguments:(NSDictionary *)arguments
          originalTest:(NSString *)testSelectorString
{
    DLog(@"%@", finisherString);
    [finisherArguments setObject:(apidStatus == ApidStatusFail ? kJRApidResultFail : kJRApidResultSuccess) forKey:kJRApidResult];

    @try
    {
        if ([self respondsToSelector:_nsel(finisherString)])
            [self performSelector:_nsel(finisherString) withObject:arguments];
        else
            GHAssertFalse(TRUE, @"Missing test result comparison for %@", testSelectorString);
    }
    @catch (NSException *exception)
    {
        GHTestLog([exception description]);
        [self notify:kGHUnitWaitStatusFailure forSelector:_nsel(testSelectorString)];

        return;
    }

    [self notify:kGHUnitWaitStatusSuccess forSelector:_nsel(testSelectorString)];
}

- (NSString *)getTestSelectorStringFromContext:(NSObject *)context
{
    NSArray *const splitContext  = [((NSString *) context) componentsSeparatedByString:@"."];
    return [splitContext objectAtIndex:1];
}

- (NSString *)getFinisherFromTestSelectorString:(NSString *)testSelectorString
{
    return [NSString stringWithFormat:@"%@%@",
                   [testSelectorString stringByReplacingOccurrencesOfString:@"test" withString:@"finish"],
                   @"_withArguments:"];
}

/******* Update Object *******/
/* Tester Delegate Fail */
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Fail */
- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];
    [finisherArguments setObject:error forKey:kJRError];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Succeed */
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Replace Object *******/
/* Tester Delegate Fail */
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Fail */
- (void)replaceDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];
    [finisherArguments setObject:error forKey:kJRError];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Succeed */
- (void)replaceDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Replace Array *******/
/* Tester Delegate Fail */
- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Fail */
- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];
    [finisherArguments setObject:error forKey:kJRError];

    if (arrayName) [finisherArguments setObject:arrayName forKey:kJRArrayName];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Succeed */
- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray named:(NSString *)arrayName context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:kJRCaptureObject];
    [finisherArguments setObject:replacedArray forKey:kJRNewArray];
    [finisherArguments setObject:arrayName forKey:kJRArrayName];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}


/******* Create User *******/
/* Tester Delegate Fail */
- (void)createCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Fail */
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:user forKey:kJRCaptureObject];
    [finisherArguments setObject:error forKey:kJRError];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)createCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:kJRTesterDelegateResult];
}

/* Real Delegate Succeed */
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context
{
    [finisherArguments setObject:user forKey:kJRCaptureObject];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Fetch User *******/
/* Real Delegate Fail */
- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:error forKey:kJRError];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Real Delegate Succeed */
- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context
{
    [finisherArguments setObject:fetchedUser forKey:kJRCaptureObject];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Fetch LastUpdated *******/
/* Real Delegate Fail */
- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:error forKey:kJRError];

    GHTestLog(_sel);
    GHTestLog([error description]);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Real Delegate Succeed */
- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context
{
    [finisherArguments setObject:serverLastUpdated forKey:@"serverLastUpdated"];
    [finisherArguments setObject:[NSNumber numberWithBool:isOutdated] forKey:@"isOutdated"];

    GHTestLog(_sel);

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}


- (void)dealloc
{
    [captureUser release];
    [defaultContext release];
    [defaultArrayContext release];
    [defaultStringArrayContext release];
    [finisherArguments release];
    [defaultGetObjectContext release];
    [super dealloc];
}
@end

