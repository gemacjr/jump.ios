//
//  JRSpecialLabel.h
//  SpecialLabelWorkbench
//
//  Created by lilli on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
    // find words/linebreaks (nextWordFromIndex:forward:/lineBreakBeforeIndex:withinRange:)
    
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
//- (void)setUsername_:(NSString*)newUsername;
//- (void)setUrl_:(NSString*)newUrl;
//- (void)setText_:(NSString*)newText;
//- (void)setFontSize_:(CGFloat)newFontSize;
@property (copy) NSString *username;
@property (copy) NSString *url;
@property (copy) NSString *usertext;
@property (readonly) NSString *text;
@property CGFloat fontSize;

- (id)initWithFrame:(CGRect)aRect defaultUsername:(NSString*)defaultUsername defaultUsertext:(NSString*)defaultUsertext 
         defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize;
@end
