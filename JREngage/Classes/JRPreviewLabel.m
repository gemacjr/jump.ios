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

 File:   JRSpecialLabel.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, October 5, 2011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRPreviewLabel.h"

@interface NSString (visibleText)
- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font;
- (NSUInteger)lengthOfStringVisibleInSize:(CGSize)size withFont:(UIFont*)font andLineBreakMode:(UILineBreakMode)lineBreakMode;
@end

@implementation NSString (visibleText)

- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font
{
    NSString *visibleString = @"";
    for (NSUInteger i = 1; i <= self.length; i++)
    {
        NSString *testString = [self substringToIndex:i];
        CGSize stringSize = [testString sizeWithFont:font];
        if (stringSize.height > rect.size.height || stringSize.width > rect.size.width)
            break;

        visibleString = testString;
    }

    return visibleString;
}

- (NSUInteger)lengthOfStringVisibleInSize:(CGSize)size withFont:(UIFont*)font andLineBreakMode:(UILineBreakMode)lineBreakMode
{
    if (self.length == 0)
        return 0;

    NSInteger indexOfLastBreakingCharacter = -1;
    NSString *visibleString = @"";
    CGFloat   lineHeight = ([font respondsToSelector:@selector(lineHeight)]) ? 
                             font.lineHeight : font.ascender - font.descender + 1.0;

    for (NSUInteger i = 1; i <= self.length; i++)
    {
        unichar currentChar = [self characterAtIndex:i - 1];
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:currentChar] || currentChar == '-')
            indexOfLastBreakingCharacter = i - 1;

        NSString *testString = [self substringToIndex:i];

        CGSize stringSize = [testString sizeWithFont:font
                                   constrainedToSize:CGSizeMake(size.width, size.height + lineHeight)
                                       lineBreakMode:lineBreakMode];

        if (stringSize.height > size.height || stringSize.width > size.width)
            break;

        visibleString = testString;
    }

    if (lineBreakMode == UILineBreakModeWordWrap && indexOfLastBreakingCharacter != -1)
        return (NSUInteger)indexOfLastBreakingCharacter + 1;

    return visibleString.length;
}

@end

@interface JRPreviewLabel ()
@property (retain) UIFont *font;
@property (retain) UIFont *boldFont;
- (void)rebuildText;
@end

@implementation JRPreviewLabel
@dynamic username;
@dynamic usertext;
@dynamic url;
@dynamic fontSize;
@synthesize text;
@synthesize font;
@synthesize boldFont;
@synthesize delegate;

- (void)finishInitWithDefaultUsername:(NSString*)defaultUsername defaultUsertext:(NSString*)defaultUsertext
                           defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize
{
    if (defaultUsername && ![defaultUsername isEqualToString:@""])
        username = [[defaultUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];

    if (defaultUsertext && ![defaultUsertext isEqualToString:@""])
        usertext = [[defaultUsertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];

    if (defaultUrl && ![defaultUrl isEqualToString:@""])
        url      = [[defaultUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];

    [self rebuildText];

    if (defaultFontSize)
        fontSize = defaultFontSize;
    else
        fontSize = 12.0;

    font     = [[UIFont systemFontOfSize:fontSize] retain];
    boldFont = [[UIFont boldSystemFontOfSize:fontSize] retain];

    usernameLabel = [[UILabel alloc] init];
    usernameLabel.numberOfLines = 1;
    usernameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    usernameLabel.font = boldFont;

    textLabelLine1 = [[UILabel alloc] init];
    textLabelLine1.numberOfLines = 0;
    textLabelLine1.lineBreakMode = UILineBreakModeWordWrap;
    textLabelLine1.font = font;

    textLabelLine2 = [[UILabel alloc] init];
    textLabelLine2.numberOfLines = 0;
    textLabelLine2.lineBreakMode = UILineBreakModeWordWrap;
    textLabelLine2.font = font;

    textLabelLine3 = [[UILabel alloc] init];
    textLabelLine3.numberOfLines = 1;
    textLabelLine3.lineBreakMode = UILineBreakModeTailTruncation;
    textLabelLine3.font = font;

    urlLabel = [[UILabel alloc] init];
    urlLabel.numberOfLines = 1;
    urlLabel.lineBreakMode = UILineBreakModeTailTruncation;
    urlLabel.font = font;
    urlLabel.textColor = [UIColor darkGrayColor];

    usernameLabel.backgroundColor  = [UIColor clearColor];
    textLabelLine1.backgroundColor = [UIColor clearColor];
    textLabelLine2.backgroundColor = [UIColor clearColor];
    textLabelLine3.backgroundColor = [UIColor clearColor];
    urlLabel.backgroundColor       = [UIColor clearColor];
    self.backgroundColor           = [UIColor clearColor];

    [self addSubview:usernameLabel];
    [self addSubview:textLabelLine1];
    [self addSubview:textLabelLine2];
    [self addSubview:textLabelLine3];
    [self addSubview:urlLabel];
}

- (id)initWithFrame:(CGRect)aRect defaultUsername:(NSString*)defaultUsername defaultUsertext:(NSString*)defaultUsertext
         defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize
{
    if ((self = [super initWithFrame:aRect]))
    {
        [self finishInitWithDefaultUsername:defaultUsername defaultUsertext:defaultUsertext
                                 defaultUrl:defaultUrl andDefaultFontSize:defaultFontSize];
    }

    return self;
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect]))
    {
        [self finishInitWithDefaultUsername:nil defaultUsertext:nil
                                 defaultUrl:nil andDefaultFontSize:12.0];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder]))
    {
        [self finishInitWithDefaultUsername:nil defaultUsertext:nil
                                 defaultUrl:nil andDefaultFontSize:12.0];
    }

    return self;
}

- (void)layoutSubviews
{
    usernameLabel.text = @"";
    textLabelLine1.text = @"";
    textLabelLine2.text = @"";
    textLabelLine3.text = @"";
    urlLabel.text = @"";
    
    CGFloat newContentHeight = 0;
    CGFloat lineWidth        = self.frame.size.width;
    CGFloat lineHeight       = ([boldFont respondsToSelector:@selector(lineHeight)]) ? 
                                 boldFont.lineHeight : boldFont.ascender - boldFont.descender + 1.0;
    CGFloat superviewHeight  = self.frame.size.height;
    CGFloat usernameMaxWidth = (lineWidth * 3) / 4;
    CGFloat urlMaxWidth      = (lineWidth * 3) / 4;
    CGFloat usernamePadding  = (username) ? fontSize / 3 : 0;
    CGFloat urlPadding       = (url)      ? fontSize / 3 : 0;

    BOOL wrapTextToSecondLine  = NO;
    BOOL wrapTextToThirdLine   = NO;

    CGSize sizeOfFirstLineOfText  = CGSizeZero;
    CGSize sizeOfSecondLineOfText = CGSizeZero;
    CGSize sizeOfThirdLineOfText  = CGSizeZero;

    NSUInteger lengthOfFirstLineOfText  = 0;
    NSUInteger lengthOfSecondLineOfText = 0;

    NSString *firstLineOfText  = @"";
    NSString *secondLineOfText = @"";
    NSString *thirdLineOfText  = @"";
    NSString *remainingText    = @"";

    CGSize sizeOfUrl = (!url) ? CGSizeMake(0, 0) :
                                [url sizeWithFont:font
                                constrainedToSize:CGSizeMake(urlMaxWidth, lineHeight)
                                    lineBreakMode:UILineBreakModeTailTruncation];

    CGSize sizeOfUsername = (!username) ? CGSizeMake(0, 0):
                                          [username sizeWithFont:boldFont
                                               constrainedToSize:CGSizeMake(usernameMaxWidth, lineHeight)
                                                   lineBreakMode:UILineBreakModeTailTruncation];


    CGFloat remainingLineOneWidth = lineWidth - sizeOfUsername.width - usernamePadding;

    sizeOfFirstLineOfText = [usertext sizeWithFont:font
                                 constrainedToSize:CGSizeMake(remainingLineOneWidth, superviewHeight)
                                     lineBreakMode:UILineBreakModeWordWrap];

    if (sizeOfFirstLineOfText.height <= lineHeight)
    {
//        lengthOfFirstLineOfText = usertext.length;
        firstLineOfText = usertext;
    }
    else
    {
        wrapTextToSecondLine = YES;

        lengthOfFirstLineOfText = [usertext lengthOfStringVisibleInSize:CGSizeMake(sizeOfFirstLineOfText.width, lineHeight)
                                                               withFont:font
                                                       andLineBreakMode:UILineBreakModeWordWrap];

        firstLineOfText = [usertext substringToIndex:lengthOfFirstLineOfText];

        if (usertext.length > lengthOfFirstLineOfText)
            remainingText = [usertext substringFromIndex:lengthOfFirstLineOfText];

        sizeOfSecondLineOfText = [remainingText sizeWithFont:font
                                           constrainedToSize:CGSizeMake(lineWidth, superviewHeight)
                                               lineBreakMode:UILineBreakModeWordWrap];

        if (sizeOfSecondLineOfText.height <= lineHeight)
        {
//            lengthOfSecondLineOfText = remainingText.length;
            secondLineOfText = remainingText;
        }
        else
        {
            wrapTextToThirdLine = YES;

            lengthOfSecondLineOfText = [remainingText lengthOfStringVisibleInSize:CGSizeMake(sizeOfSecondLineOfText.width, lineHeight)
                                                                withFont:font
                                                        andLineBreakMode:UILineBreakModeWordWrap];

            secondLineOfText = [remainingText substringToIndex:lengthOfSecondLineOfText];

            if (remainingText.length > lengthOfSecondLineOfText)
                thirdLineOfText = [remainingText substringFromIndex:lengthOfSecondLineOfText];

            sizeOfThirdLineOfText = [thirdLineOfText sizeWithFont:font
                                                constrainedToSize:CGSizeMake(lineWidth - sizeOfUrl.width - urlPadding, lineHeight)
                                                    lineBreakMode:UILineBreakModeTailTruncation];
        }
    }

    usernameLabel.frame = CGRectMake(0, 0, sizeOfUsername.width, lineHeight);
    usernameLabel.text = username;

    textLabelLine1.frame = CGRectMake(sizeOfUsername.width + usernamePadding, 0, sizeOfFirstLineOfText.width, lineHeight);
    textLabelLine1.text = firstLineOfText;

    if (!wrapTextToSecondLine) /* && !wrapTextToThirdLine of course */
    {
        [textLabelLine2 setHidden:YES];
        [textLabelLine3 setHidden:YES];

        /* Special check for the case where we don't have any text whatsoever */
        if (!username && !usertext && !url)
        {
            newContentHeight = 0;
        }
        else if (!usertext)
        {
            if (!username)
            {
                urlLabel.frame = CGRectMake(0, 0, sizeOfUrl.width, lineHeight);
                newContentHeight = lineHeight;
            }
            else if (sizeOfUsername.width + usernamePadding + sizeOfUrl.width < lineWidth)
            {
                urlLabel.frame = CGRectMake(sizeOfUsername.width + usernamePadding, 0,
                                            sizeOfUrl.width, lineHeight);

                newContentHeight = lineHeight;
            }
            else
            {
                urlLabel.frame = CGRectMake(0, lineHeight,
                                            sizeOfUrl.width, lineHeight);

                newContentHeight = lineHeight * 2;
            }
        }
        else if (sizeOfUsername.width + usernamePadding + sizeOfFirstLineOfText.width + urlPadding + sizeOfUrl.width < lineWidth)
        {
            urlLabel.frame = CGRectMake(sizeOfUsername.width + usernamePadding + sizeOfFirstLineOfText.width + urlPadding, 0,
                                        sizeOfUrl.width, lineHeight);

            newContentHeight = lineHeight;
        }
        else
        {
            urlLabel.frame = CGRectMake(0, lineHeight,
                                         sizeOfUrl.width, lineHeight);

            newContentHeight = lineHeight * 2;
        }
    }
    else if (wrapTextToSecondLine && !wrapTextToThirdLine)
    {
        [textLabelLine2 setHidden:NO];
        [textLabelLine3 setHidden:YES];

        textLabelLine2.frame = CGRectMake(0, lineHeight, sizeOfSecondLineOfText.width, lineHeight);
        textLabelLine2.text = secondLineOfText;

        if (sizeOfSecondLineOfText.width + urlPadding + sizeOfUrl.width < lineWidth)
        {
            urlLabel.frame = CGRectMake(sizeOfSecondLineOfText.width + urlPadding, lineHeight,
                                         sizeOfUrl.width, lineHeight);

            newContentHeight = lineHeight * 2;
        }
        else
        {
            urlLabel.frame = CGRectMake(0, lineHeight * 2,
                                        sizeOfUrl.width, lineHeight);

            newContentHeight = lineHeight * 3;
        }
    }
    else /* (wrapTextToSecondLine && wrapTextToThirdLine) */
    {
        [textLabelLine2 setHidden:NO];
        [textLabelLine3 setHidden:NO];

        textLabelLine2.frame = CGRectMake(0, lineHeight, sizeOfSecondLineOfText.width, lineHeight);
        textLabelLine2.text = secondLineOfText;

        textLabelLine3.frame = CGRectMake(0, lineHeight * 2, sizeOfThirdLineOfText.width, lineHeight);
        textLabelLine3.text = thirdLineOfText;

        urlLabel.frame = CGRectMake(sizeOfThirdLineOfText.width + urlPadding, lineHeight * 2,
                                    sizeOfUrl.width, lineHeight);

        newContentHeight = lineHeight * 3;
    }

    [urlLabel setHidden:NO];
    [urlLabel setText:url];

    if (newContentHeight != contentHeight)
    {
        if ([delegate respondsToSelector:@selector(previewLabel:didChangeContentHeightFrom:to:)])
            [delegate previewLabel:self didChangeContentHeightFrom:contentHeight to:newContentHeight];

        contentHeight = newContentHeight;
    }
}

- (void)rebuildText
{
    [text release];
    text = [[NSString stringWithFormat:@"%@%@%@",
            (username) ? [NSString stringWithFormat:@"%@ ", username] : @"",
            (usertext) ? [NSString stringWithFormat:@"%@ ", usertext] : @"",
            (url)      ? (url) : (@"")] retain];
}

- (NSString*)username { return [[username copy] autorelease]; }
- (NSString*)usertext { return [[usertext copy] autorelease]; }
- (NSString*)url      { return [[url copy] autorelease]; }

- (void)setUsername:(NSString*)newUsername
{
    [username release];

    if (newUsername && ![newUsername isEqualToString:@""])
        username = [[newUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
    else
        username = nil;

    [self rebuildText];
    [self setNeedsLayout];
}

- (void)setUrl:(NSString*)newUrl
{
    [url release];

    if (newUrl && ![newUrl isEqualToString:@""])
        url = [[newUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
    else
        url = nil;

    [self rebuildText];
    [self setNeedsLayout];
}

- (void)setUsertext:(NSString*)newUsertext;
{
    [usertext release];

    if (newUsertext && ![newUsertext isEqualToString:@""])
        usertext = [[newUsertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
    else
        usertext = nil;

    [self rebuildText];
    [self setNeedsLayout];
}

- (CGFloat)fontSize { return fontSize; }

- (void)setFontSize:(CGFloat)newFontSize
{
    fontSize = newFontSize;

    self.font     = [UIFont systemFontOfSize:fontSize];
    self.boldFont = [UIFont boldSystemFontOfSize:fontSize];

    usernameLabel.font = boldFont;
    textLabelLine1.font = font;
    textLabelLine2.font = font;
    textLabelLine3.font = font;
    urlLabel.font = font;

    [self setNeedsLayout];
}

- (void)dealloc
{
    [usernameLabel release];
    [textLabelLine1 release];
    [textLabelLine2 release];
    [textLabelLine3 release];
    [urlLabel release];
    [username release];
    [usertext release];
    [url release];
    [text release], text = nil;
    [font release];
    [boldFont release];

    [super dealloc];
}
@end





