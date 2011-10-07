//
//  JRSpecialLabel.m
//  SpecialLabelWorkbench
//
//  Created by lilli on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JRSpecialLabel.h"


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface NSString (visibleText)
- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font;
- (NSInteger)lengthOfStringVisibleInSize:(CGSize)size withFont:(UIFont*)font andLineBreakMode:(UILineBreakMode)lineBreakMode;
@end

@implementation NSString (visibleText)

- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font
{
    NSString *visibleString = @"";
    for (int i = 1; i <= self.length; i++)
    {
        NSString *testString = [self substringToIndex:i];
        CGSize stringSize = [testString sizeWithFont:font];
        if (stringSize.height > rect.size.height || stringSize.width > rect.size.width)
            break;
        
        visibleString = testString;
    }
    
    return visibleString;
}

//- (NSUInteger)lengthOfStringVisibleInRect:(CGRect)rect withFont:(UIFont*)font andLineBreakMode:(UILineBreakMode)lineBreakMode
//{
//    DLog (@"rect width/height: %f, %f", rect.size.width, rect.size.height);
//    DLog (@"self           (%u): %@", self.length, self);
//    
//    NSString *visibleString = @"";
//    //    if (self.length == 0)
//    //    {
//    //        return 0;// @"";
//    //    }
//    //    if (self.length == 1)
//    //    {
//    //        CGSize stringSize = [self sizeWithFont:font 
//    //                             constrainedToSize:CGSizeMake(rect.size.width, rect.size.height + font.lineHeight)
//    //                                 lineBreakMode:lineBreakMode];
//    //        
//    //        if (stringSize.height > rect.size.height || stringSize.width >= rect.size.width)
//    //            return 0;//@"";
//    //        else
//    //            return 1;//self;
//    //    }
//    
//    //    NSString *testString = [self substringToIndex:1];
//    //    for (int i = 2; i <= self.length; i++)
//    for (int i = 1; i <= self.length; i++)
//    {
//        //        NSString *oneBefore = testString;
//        //        testString = [self substringToIndex:i];
//        NSString *testString = [self substringToIndex:i];
//        
//        DLog (@"visible string (%u): %@", visibleString.length, visibleString);
//        DLog (@"test string    (%u): %@", visibleString.length, testString);
//        
//        CGSize stringSize = [testString sizeWithFont:font 
//                                   constrainedToSize:CGSizeMake(rect.size.width, rect.size.height + font.lineHeight)
//                                       lineBreakMode:lineBreakMode];
//        
//        DLog (@"test width/height: %f, %f", stringSize.width, stringSize.height);
//        
//        if (stringSize.height > rect.size.height || stringSize.width > rect.size.width)
//        {
//            DLog (@"+--------------------------------------------------------------------------------------");
//            DLog (@"| test width/height: %f, %f", stringSize.width, stringSize.height);
//            DLog (@"| visible string (%u): %@", visibleString.length, visibleString);
//            DLog (@"| test string    (%u): %@", visibleString.length, testString);
//            DLog (@"+--------------------------------------------------------------------------------------");
//            break;
//        }
//        //        visibleString = oneBefore;
//        visibleString = testString;
//    }
//    
//    return visibleString.length;
//}

- (NSInteger)lengthOfStringVisibleInSize:(CGSize)size withFont:(UIFont*)font andLineBreakMode:(UILineBreakMode)lineBreakMode
{
    DLog (@"rect width/height: %f, %f", size.width, size.height);
    DLog (@"self           (%u): %@", self.length, self);
    
    if (self.length == 0)
        return 0;
    
    NSInteger indexOfLastBreakingCharacter = -1;
    NSString *visibleString = @"";
    for (int i = 1; i <= self.length; i++)
    {
        unichar currentChar = [self characterAtIndex:i - 1];
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:currentChar] || currentChar == '-')
            indexOfLastBreakingCharacter = i - 1;        
        
        NSString *testString = [self substringToIndex:i];
     
//        DLog (@"test string    (%u): %@", testString.length, testString);
        
        CGSize stringSize = [testString sizeWithFont:font 
                                   constrainedToSize:CGSizeMake(size.width, size.height + font.lineHeight)
                                       lineBreakMode:lineBreakMode];
//        DLog (@"test width/height: %f, %f", stringSize.width, stringSize.height);

        if (stringSize.height > size.height || stringSize.width > size.width)
        {
            DLog (@"+--------------------------------------------------------------------------------------");
            DLog (@"| test width/height: %f, %f", stringSize.width, stringSize.height);
            DLog (@"| self           (%u): %@", self.length, self);
            DLog (@"| visible string (%u): %@", visibleString.length, visibleString);
            DLog (@"| test string    (%u): %@", testString.length, testString);
            DLog (@"| index of last breaking character: %u", indexOfLastBreakingCharacter);
            if (indexOfLastBreakingCharacter != -1)
            DLog (@"| new string     (%u): %@", [self substringFromIndex:indexOfLastBreakingCharacter + 1].length, [self substringFromIndex:indexOfLastBreakingCharacter + 1]);
            DLog (@"+--------------------------------------------------------------------------------------");
            break;
        }
        
        visibleString = testString;
        
//        DLog (@"visible string (%u): %@", visibleString.length, visibleString);
//        DLog (@" - - - - - - - - - - - - - - - - - - - - - - -");
    }
    
    if (lineBreakMode == UILineBreakModeWordWrap && indexOfLastBreakingCharacter != -1)
        return indexOfLastBreakingCharacter + 1;
    
    return visibleString.length;
}

@end

#define FONT_SIZE 15.0
#define SYS_FONT [UIFont systemFontOfSize:FONT_SIZE]
#define CHAR_WRAP UILineBreakModeCharacterWrap
#define WORD_WRAP UILineBreakModeWordWrap
#define TAIL_TRUNK UILineBreakModeTailTruncation

@interface JRSpecialLabel ()
@property (retain) NSString *username;
@property (retain) NSString *url;
@property (retain) NSString *text;
@property (retain) UIFont *font;
@property (retain) UIFont *boldFont;
@property CGFloat fontSize;
@end

@implementation JRSpecialLabel
@synthesize username;
@synthesize text;
@synthesize url;
@synthesize fontSize;
@synthesize font;
@synthesize boldFont;

- (id)initWithFrame:(CGRect)aRect defaultUsername:(NSString*)defaultUsername defaultText:(NSString*)defaultText 
         defaultUrl:(NSString*)defaultUrl andDefaultFontSize:(CGFloat)defaultFontSize
{
    if ((self = [super initWithFrame:aRect]))
    {
        if (defaultUsername && ![defaultUsername isEqualToString:@""])
            username = [[NSString alloc] initWithFormat:@"%@ ", 
                        [defaultUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

        if (defaultText && ![defaultText isEqualToString:@""])
            text     = [[NSString alloc] initWithFormat:@"%@", 
                        [defaultText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        if (defaultUrl && ![defaultUrl isEqualToString:@""])
            url      = [[NSString alloc] initWithFormat:@" %@", 
                        [defaultUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        if (defaultFontSize)
            fontSize = defaultFontSize;
        else
            fontSize = 12.0;

        font     = [[UIFont fontWithName:@"Courier" size:fontSize] retain];//[[UIFont systemFontOfSize:fontSize] retain];
        boldFont = [[UIFont fontWithName:@"Courier-Bold" size:fontSize] retain];//[[UIFont boldSystemFontOfSize:fontSize] retain];
        
        usernameLabel = [[UILabel alloc] init];
        usernameLabel.numberOfLines = 1;
        usernameLabel.lineBreakMode = TAIL_TRUNK;
        usernameLabel.font = boldFont;
        
        textLabelLine1 = [[UILabel alloc] init];
        textLabelLine1.numberOfLines = 0;
        textLabelLine1.lineBreakMode = WORD_WRAP;
        textLabelLine1.font = font;
        
        textLabelLine2 = [[UILabel alloc] init];
        textLabelLine2.numberOfLines = 0;
        textLabelLine2.lineBreakMode = WORD_WRAP;
        textLabelLine2.font = font;
     
        textLabelLine3 = [[UILabel alloc] init];
        textLabelLine3.numberOfLines = 1;
        textLabelLine3.lineBreakMode = TAIL_TRUNK;
        textLabelLine3.font = font;
        
        urlLabel = [[UILabel alloc] init];
        urlLabel.numberOfLines = 1;
        urlLabel.lineBreakMode = TAIL_TRUNK;
        urlLabel.font = font;
        urlLabel.textColor = [UIColor darkGrayColor];
        
//        usernameLabel.backgroundColor = [UIColor redColor];
//        textLabelLine1.backgroundColor = [UIColor blueColor];
//        textLabelLine2.backgroundColor = [UIColor yellowColor];
//        textLabelLine3.backgroundColor = [UIColor greenColor];
//        urlLabel.backgroundColor = [UIColor purpleColor];
//        self.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:usernameLabel];
        [self addSubview:textLabelLine1];
        [self addSubview:textLabelLine2];
        [self addSubview:textLabelLine3];
        [self addSubview:urlLabel];
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
    
    CGFloat lineWidth        = self.frame.size.width;
    CGFloat lineHeight       = boldFont.lineHeight;
    CGFloat superviewHeight  = self.frame.size.height;
    CGFloat usernameMaxWidth = (lineWidth * 3) / 4;
    CGFloat urlMaxWidth      = (lineWidth * 3) / 4;
    
//    NSUInteger lineNumberOfUrl = 0;
    BOOL wrapTextToSecondLine  = NO;
    BOOL wrapTextToThirdLine   = NO;
    
    CGSize sizeOfFirstLineOfText  = CGSizeZero;
    CGSize sizeOfSecondLineOfText = CGSizeZero;
    CGSize sizeOfThirdLineOfText  = CGSizeZero;
    
    NSInteger lengthOfFirstLineOfText  = 0;
    NSInteger lengthOfSecondLineOfText = 0;
    
    NSString *firstLineOfText;
    NSString *secondLineOfText;
    NSString *thirdLineOfText;
    NSString *remainingText;
    
    CGSize sizeOfUrl = [url sizeWithFont:font
                       constrainedToSize:CGSizeMake(urlMaxWidth, lineHeight)
                           lineBreakMode:TAIL_TRUNK];
    
    CGSize sizeOfUsername = [username sizeWithFont:boldFont
                                 constrainedToSize:CGSizeMake(usernameMaxWidth, lineHeight)
                                     lineBreakMode:TAIL_TRUNK];
    
    CGFloat remainingLineOneWidth = lineWidth - sizeOfUsername.width;
    
    sizeOfFirstLineOfText = [text sizeWithFont:font
                             constrainedToSize:CGSizeMake(remainingLineOneWidth, superviewHeight)
                                 lineBreakMode:WORD_WRAP];

    if (sizeOfFirstLineOfText.height <= lineHeight)
    {    
        lengthOfFirstLineOfText = text.length;
        firstLineOfText = text;
    }
    else
    {
        wrapTextToSecondLine = YES;

        lengthOfFirstLineOfText = [text lengthOfStringVisibleInSize:CGSizeMake(sizeOfFirstLineOfText.width, lineHeight) 
                                                           withFont:font 
                                                   andLineBreakMode:WORD_WRAP];
        
        firstLineOfText = [text substringToIndex:lengthOfFirstLineOfText];

        if (text.length > lengthOfFirstLineOfText)
            remainingText = [text substringFromIndex:lengthOfFirstLineOfText];

        sizeOfSecondLineOfText = [remainingText sizeWithFont:font
                                           constrainedToSize:CGSizeMake(lineWidth, superviewHeight)
                                               lineBreakMode:WORD_WRAP];
        
        if (sizeOfSecondLineOfText.height <= lineHeight)
        {    
            lengthOfSecondLineOfText = remainingText.length;
            secondLineOfText = remainingText;
        }
        else
        {
            wrapTextToThirdLine = YES;
            
            lengthOfSecondLineOfText = [remainingText lengthOfStringVisibleInSize:CGSizeMake(sizeOfSecondLineOfText.width, lineHeight)
                                                                withFont:font 
                                                        andLineBreakMode:WORD_WRAP];

            secondLineOfText = [remainingText substringToIndex:lengthOfSecondLineOfText];
            
            if (remainingText.length > lengthOfSecondLineOfText)
                thirdLineOfText = [remainingText substringFromIndex:lengthOfSecondLineOfText];
            
            sizeOfThirdLineOfText = [thirdLineOfText sizeWithFont:font
                                                constrainedToSize:CGSizeMake(lineWidth - sizeOfUrl.width, lineHeight)
                                                    lineBreakMode:TAIL_TRUNK];
        }
    }

    usernameLabel.frame = CGRectMake(0, 0, sizeOfUsername.width, lineHeight);
    usernameLabel.text = username;
    
    textLabelLine1.frame = CGRectMake(sizeOfUsername.width, 0, sizeOfFirstLineOfText.width, lineHeight);
    textLabelLine1.text = firstLineOfText;    
    
    if (!wrapTextToSecondLine) // && !wrapTextToThirdLine
    {
        [textLabelLine2 setHidden:YES];
        [textLabelLine3 setHidden:YES];
     
        if (sizeOfUsername.width + sizeOfFirstLineOfText.width + sizeOfUrl.width < lineWidth)
            urlLabel.frame = CGRectMake(sizeOfUsername.width + sizeOfFirstLineOfText.width, 0,
                                        sizeOfUrl.width, lineHeight);
        else
            urlLabel.frame = CGRectMake(0, lineHeight, 
                                        sizeOfUrl.width, lineHeight);
    }
    else if (wrapTextToSecondLine && !wrapTextToThirdLine)
    {
        [textLabelLine2 setHidden:NO];
        [textLabelLine3 setHidden:YES];
   
        textLabelLine2.frame = CGRectMake(0, lineHeight, sizeOfSecondLineOfText.width, lineHeight);
        textLabelLine2.text = secondLineOfText;

        if (sizeOfSecondLineOfText.width + sizeOfUrl.width < lineWidth)
            urlLabel.frame = CGRectMake(sizeOfSecondLineOfText.width, lineHeight,
                                        sizeOfUrl.width, lineHeight);
        else
            urlLabel.frame = CGRectMake(0, lineHeight * 2, 
                                        sizeOfUrl.width, lineHeight);
    }
    else // (wrapTextToSecondLine && wrapTextToThirdLine)
    {
        [textLabelLine2 setHidden:NO];
        [textLabelLine3 setHidden:NO];
        
        textLabelLine2.frame = CGRectMake(0, lineHeight, sizeOfSecondLineOfText.width, lineHeight);
        textLabelLine2.text = secondLineOfText;
                
        textLabelLine3.frame = CGRectMake(0, lineHeight * 2, sizeOfThirdLineOfText.width, lineHeight);
        textLabelLine3.text = thirdLineOfText;
        
        urlLabel.frame = CGRectMake(sizeOfThirdLineOfText.width, lineHeight * 2,
                                    sizeOfUrl.width, lineHeight);
        
    }
    
    [urlLabel setHidden:NO];
    [urlLabel setText:url];
    
}

- (void)setUsername_:(NSString*)newUsername
{
    if (newUsername && ![newUsername isEqualToString:@""])
        self.username = [NSString stringWithFormat:@"%@ ", 
                         [newUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    else
        self.username = nil;
    
    [self setNeedsLayout];
}

- (void)setUrl_:(NSString*)newUrl
{
    if (newUrl && ![newUrl isEqualToString:@""])
        self.url = [NSString stringWithFormat:@" %@", 
                       [newUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    else
        self.url = nil;
    
    [self setNeedsLayout];
}

- (void)setText_:(NSString*)newText;
{
    if (newText && ![newText isEqualToString:@""])
        self.text = [NSString stringWithFormat:@"%@", 
                     [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    else
        self.text = nil;
    
    [self setNeedsLayout];
}

- (void)setFontSize_:(CGFloat)newFontSize
{
    self.fontSize = newFontSize;

    self.font     = [[UIFont fontWithName:@"Courier" size:fontSize] retain];//[[UIFont systemFontOfSize:fontSize] retain];
    self.boldFont = [[UIFont fontWithName:@"Courier-Bold" size:fontSize] retain];//[[UIFont boldSystemFontOfSize:fontSize] retain];

//    self.font     = [UIFont systemFontOfSize:fontSize];
//    self.boldFont = [UIFont boldSystemFontOfSize:fontSize];
    
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
    [url release];
    [text release];
    [font release];
    [boldFont release];

    [super dealloc];
}
@end


//- (void)layoutSubviews
//{
//    usernameLabel.text = @"";
//    textLabelLine1.text = @"";
//    textLabelLine2.text = @"";
//    textLabelLine3.text = @"";
//    urlLabel.text = @"";
//    
//    CGFloat lineWidth        = self.frame.size.width;
//    CGFloat lineHeight       = boldFont.lineHeight;
//    CGFloat superviewHeight  = self.frame.size.height;
//    CGFloat usernameMaxWidth = (lineWidth * 3) / 4;
//    CGFloat urlMaxWidth      = (lineWidth * 3) / 4;
//    
//    NSUInteger lineNumberOfUrl = 0;
//    BOOL wrapTextToSecondLine  = NO;
//    BOOL wrapTextToThirdLine   = NO;
//    
//    CGSize sizeOfFirstLineOfText  = CGSizeZero;
//    CGSize sizeOfSecondLineOfText = CGSizeZero;
//    CGSize sizeOfThirdLineOfText  = CGSizeZero;
//    
//    NSInteger lengthOfFirstLineOfText  = 0;
//    NSInteger lengthOfSecondLineOfText = 0;
//    
//    NSString *firstLineOfText;
//    NSString *secondLineOfText;
//    NSString *remainingText;
//    
//    CGSize sizeOfUrl = [url sizeWithFont:font
//                       constrainedToSize:CGSizeMake(urlMaxWidth, lineHeight)
//                           lineBreakMode:CHAR_WRAP];
//    
//    CGSize sizeOfUsername = [username sizeWithFont:boldFont
//                                 constrainedToSize:CGSizeMake(usernameMaxWidth, lineHeight)
//                                     lineBreakMode:CHAR_WRAP];
//    
//    usernameLabel.frame = CGRectMake(0, 0, sizeOfUsername.width, lineHeight);
//    usernameLabel.text = username;
//    
//    CGFloat remainingLineOneWidth = lineWidth - sizeOfUsername.width;
//    
//    sizeOfFirstLineOfText = [text sizeWithFont:font
//                             constrainedToSize:CGSizeMake(remainingLineOneWidth, superviewHeight)
//                                 lineBreakMode:WORD_WRAP];
//    
//    lengthOfFirstLineOfText = [text lengthOfStringVisibleInSize:CGSizeMake(sizeOfFirstLineOfText.width, lineHeight) 
//                                                       withFont:font 
//                                               andLineBreakMode:WORD_WRAP];
//    
//    firstLineOfText = [text substringToIndex:lengthOfFirstLineOfText];
//    
//    if (text.length > lengthOfFirstLineOfText)
//        remainingText = [text substringFromIndex:lengthOfFirstLineOfText];
//        
//        if (sizeOfFirstLineOfText.height > lineHeight)
//            wrapTextToSecondLine = YES;
//            
//            textLabelLine1.frame = CGRectMake(sizeOfUsername.width, 0, sizeOfFirstLineOfText.width, lineHeight);
//            textLabelLine1.text = firstLineOfText;//text;
//            
//            if (!wrapTextToSecondLine)
//            {
//                [textLabelLine2 setHidden:YES];
//                [textLabelLine3 setHidden:YES];
//                
//                if (sizeOfUsername.width + sizeOfFirstLineOfText.width + sizeOfUrl.width < lineWidth)
//                    lineNumberOfUrl = 1;
//                else
//                    lineNumberOfUrl = 2;
//            }
//            else
//            {
//                [textLabelLine2 setHidden:NO];
//                
//                //        NSString *secondLine = [text substringFromIndex:
//                //                                [text lengthOfStringVisibleInRect:
//                //                                 CGRectMake(0, 0, sizeOfFirstLineOfText.width, lineHeight) 
//                //                                                         withFont:font
//                //                                                 andLineBreakMode:WORD_WRAP]];
//                
//                sizeOfSecondLineOfText = [remainingText sizeWithFont:font//[secondLine sizeWithFont:font
//                                                   constrainedToSize:CGSizeMake(lineWidth, superviewHeight)
//                                                       lineBreakMode:WORD_WRAP];
//                
//                if (sizeOfSecondLineOfText.height > lineHeight) 
//                    wrapTextToThirdLine = YES;
//                
//                textLabelLine2.frame = CGRectMake(0, lineHeight, sizeOfSecondLineOfText.width, lineHeight);
//                textLabelLine2.text = secondLine;
//                
//                if (!wrapTextToThirdLine)
//                {
//                    [textLabelLine3 setHidden:YES];
//                    
//                    if (sizeOfSecondLineOfText.width + sizeOfUrl.width < lineWidth)
//                        lineNumberOfUrl = 2;
//                    else
//                        lineNumberOfUrl = 3;
//                }
//                else
//                {
//                    [textLabelLine3 setHidden:NO];
//                    
//                    lineNumberOfUrl = 3;
//                    
//                    NSString *thirdLine = [secondLine substringFromIndex:
//                                           [secondLine lengthOfStringVisibleInRect:
//                                            CGRectMake(0, 0, sizeOfSecondLineOfText.width, lineHeight) 
//                                                                          withFont:font
//                                                                  andLineBreakMode:WORD_WRAP]];
//                    
//                    sizeOfThirdLineOfText = [thirdLine sizeWithFont:font
//                                                  constrainedToSize:CGSizeMake(lineWidth - sizeOfUrl.width, lineHeight)
//                                                      lineBreakMode:TAIL_TRUNK];
//                    
//                    textLabelLine3.frame = CGRectMake(0, lineHeight * 2, sizeOfThirdLineOfText.width, lineHeight);
//                    textLabelLine3.text = thirdLine;
//                }
//            }
//    
//    if (url)
//    {
//        switch (lineNumberOfUrl)
//        {
//            case 1:
//                urlLabel.frame = CGRectMake(sizeOfUsername.width + sizeOfFirstLineOfText.width, 0,
//                                            sizeOfUrl.width, lineHeight);
//                break;
//            case 2:
//                urlLabel.frame = CGRectMake(sizeOfSecondLineOfText.width, lineHeight, 
//                                            sizeOfUrl.width, lineHeight);
//                break;
//            case 3:
//                urlLabel.frame = CGRectMake(sizeOfThirdLineOfText.width, lineHeight * 2,
//                                            sizeOfUrl.width, lineHeight);
//                break;
//            default:
//                break;
//        }
//        
//        [urlLabel setHidden:NO];
//        [urlLabel setText:url];
//    }
//    else
//    {
//        [urlLabel setHidden:YES];
//    }
//}
//
//
//
//
//








