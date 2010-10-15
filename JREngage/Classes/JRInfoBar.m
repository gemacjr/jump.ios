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
 
 File:	 JRInfoBar.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRInfoBar.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


@implementation JRInfoBar

- (id)initWithFrame:(CGRect)frame andStyle:(JRInfoBarStyle)style
{
    DLog(@"");
	
	if (self = [super initWithFrame:frame]) 
	{
        hidesPoweredBy = style;
		y_origin_hidden = self.frame.origin.y + self.frame.size.height;
		
		if (hidesPoweredBy)
			[self setFrame:CGRectMake(self.frame.origin.x, y_origin_hidden, self.frame.size.width, self.frame.size.height)];
		
		barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
		barImage.image = [UIImage imageNamed:@"bottom_bar.png"];

		poweredByLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 130, 30)];
		poweredByLabel.backgroundColor = [UIColor clearColor];
		poweredByLabel.font = [UIFont italicSystemFontOfSize:13.0];
		poweredByLabel.textColor = [UIColor whiteColor];
		poweredByLabel.textAlignment = UITextAlignmentRight;
		
        // TODO: Localize this string (and all others, of course)
		if (style == JRInfoBarStyleShowPoweredBy)
			poweredByLabel.text = @"Powered by Janrain";
		else
			poweredByLabel.text = @"";
		
		infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		infoButton.frame = CGRectMake(300, 7, 15, 15);
		[infoButton addTarget:self
					   action:@selector(getInfo) 
			 forControlEvents:UIControlEventTouchUpInside];
		
		spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		
		loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 130, 30)];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.font = [UIFont systemFontOfSize:13.0];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.textAlignment = UITextAlignmentLeft;
		loadingLabel.text = @"Loading...";

		[self addSubview:barImage];
		[self addSubview:poweredByLabel];
		[self addSubview:infoButton];
		[self addSubview:spinner];
		[self addSubview:loadingLabel];
		
		spinner.alpha = 0.0;
		loadingLabel.alpha = 0.0;		

		self.alpha = 0.9;
	}		

    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView	setAnimationDelay:0.0];
	self.alpha = 0.8;
	[UIView commitAnimations];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView	setAnimationDelay:0.0];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)getInfo
{
    DLog(@"");
    
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];

    NSString *version = [infoPlist objectForKey:@"CFBundleShortVersionString"];
    
 /* So long as I always number the versions v#.#.#, this will always trim the leading 'v', leaving just the numbers.
    Also, if my script accidentally adds a trailing '\n', this gets trimmed too. */
    version = [[version stringByTrimmingCharactersInSet:[NSCharacterSet lowercaseLetterCharacterSet]]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:
                                                                   @"Janrain Engage for iPhone Library\nVersion %@\nwww.janrain.com", version]
														 delegate:self
												cancelButtonTitle:@"OK"  
										   destructiveButtonTitle:nil
												otherButtonTitles:nil] autorelease];
	action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[action showInView:self.superview];
}

- (void)startProgress
{
//    DLog(@"");

	[spinner startAnimating];

	if (hidesPoweredBy)
	{
		[UIView beginAnimations:@"show" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView	setAnimationDelay:0.0];
		[self setFrame:CGRectMake(self.frame.origin.x, (y_origin_hidden - self.frame.size.height), self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];
	}
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView	setAnimationDelay:(hidesPoweredBy) ? 0.3 : 0.0];
	spinner.alpha = 1.0;
	loadingLabel.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)stopProgress
{
//    DLog(@"");

	[spinner stopAnimating];
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView	setAnimationDelay:0.1];
	spinner.alpha = 0.0;
	loadingLabel.alpha = 0.0;
	[UIView commitAnimations];
	
	if (hidesPoweredBy)
	{
		[UIView beginAnimations:@"show" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView	setAnimationDelay:0.9];
		[self setFrame:CGRectMake(self.frame.origin.x, y_origin_hidden, self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];
	}
}	

- (void)fadeIn
{
    DLog(@"");

	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView	setAnimationDelay:0.0];
	poweredByLabel.alpha = 1.0;
	infoButton.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)fadeOut
{
    DLog(@"");
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView	setAnimationDelay:0.0];
	poweredByLabel.alpha = 0.0;
	infoButton.alpha = 0.0;
	spinner.alpha = 0.0;
	loadingLabel.alpha = 0.0;
	[UIView commitAnimations];
}

/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	// return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)dealloc 
{
    DLog(@"");

	[barImage release];
	[poweredByLabel release];
	[spinner release];
	[loadingLabel release];
    
	[super dealloc];
}

@end
