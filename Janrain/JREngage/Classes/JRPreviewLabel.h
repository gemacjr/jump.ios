/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

 File:   JRSpecialLabel.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, October 5, 2011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JRPreviewLabel;
@protocol JRPreviewLabelDelegate <NSObject>
@optional
- (void)previewLabel:(JRPreviewLabel*)previewLabel didChangeContentHeightFrom:(CGFloat)fromHeight to:(CGFloat)toHeight;
@end

@interface JRPreviewLabel : UIView
{
    UILabel *usernameLabel;
    UILabel *textLabelLine1;
    UILabel *textLabelLine2;
    UILabel *textLabelLine3;
    UILabel *urlLabel;

    // TODO: Use NSAttributedStrings so you can change individual pieces and
    // find words/line-breaks (nextWordFromIndex:forward:/lineBreakBeforeIndex:withinRange:)

    NSString *username;
    NSString *url;
    NSString *usertext;
    NSString *text;

    CGFloat fontSize;
    UIFont *font;
    UIFont *boldFont;

    id<JRPreviewLabelDelegate> delegate;
    CGFloat contentHeight;
}
@property (retain) id<JRPreviewLabelDelegate> delegate;
@property (copy) NSString *username;
@property (copy) NSString *url;
@property (copy) NSString *usertext;
@property (readonly) NSString *text;
@property CGFloat fontSize;

- (id)initWithFrame:(CGRect)aRect defaultUsername:(NSString*)defaultUsername defaultUsertext:(NSString*)defaultUsertext
         defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize;
@end
