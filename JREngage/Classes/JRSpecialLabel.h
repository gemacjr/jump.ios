//
//  JRSpecialLabel.h
//  SpecialLabelWorkbench
//
//  Created by lilli on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JRSpecialLabel : UIView
{
    UILabel *usernameLabel;
    UILabel *textLabelLine1;
    UILabel *textLabelLine2;
    UILabel *textLabelLine3;
    UILabel *urlLabel;

    NSString *username;
    NSString *url;
    NSString *text;
    
    CGFloat fontSize;
    UIFont *font;
    UIFont *boldFont;
}
- (void)setUsername_:(NSString*)newUsername;
- (void)setUrl_:(NSString*)newUrl;
- (void)setText_:(NSString*)newText;
- (void)setFontSize_:(CGFloat)newFontSize;

- (id)initWithFrame:(CGRect)aRect defaultUsername:(NSString*)defaultUsername defaultText:(NSString*)defaultText 
         defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize;
@end
