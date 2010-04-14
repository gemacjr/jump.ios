/* 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 * Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and the
 following disclaimer in the documentation and/or other materials provided with
 the distribution. 
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
*/

#import "JRInfoBar.h"


@implementation JRInfoBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
		barImage.image = [UIImage imageNamed:@"bottom_bar.png"];
		[self addSubview:barImage];

		poweredByLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 130, 30)];
		poweredByLabel.backgroundColor = [UIColor clearColor];
		poweredByLabel.font = [UIFont italicSystemFontOfSize:13.0];
		poweredByLabel.textColor = [UIColor whiteColor];
		poweredByLabel.textAlignment = UITextAlignmentRight;
		poweredByLabel.text = @"Powered by Janrain";
		[self addSubview:poweredByLabel];
		
		infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		infoButton.frame = CGRectMake(300, 7, 15, 15);
		[infoButton addTarget:self
				 action:@selector(getInfo) 
	   forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:infoButton];
		
		spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[spinner setHidden:YES];
		spinner.hidesWhenStopped = YES;
		[self addSubview:spinner];
		
		loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 130, 30)];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.font = [UIFont systemFontOfSize:13.0];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.textAlignment = UITextAlignmentLeft;
		loadingLabel.text = @"Loading...";
		[loadingLabel setHidden:YES];
		[self addSubview:loadingLabel];

    	poweredByLabel.alpha = 0.0;
		infoButton.alpha = 0.0;
		spinner.alpha = 0.0;
		loadingLabel.alpha = 0.0;
	}
    return self;
}

- (void)getInfo
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Janrain Authenticate Library\nVersion 0.1.5"
														delegate:self
											   cancelButtonTitle:@"OK"  
										  destructiveButtonTitle:nil
											   otherButtonTitles:nil];
	[action showInView:self];
}

- (void)startProgress
{
	[loadingLabel setHidden:NO];
	[spinner setHidden:NO];
	[spinner startAnimating];
	
}

- (void)stopProgress
{
	[loadingLabel setHidden:YES];
	[spinner setHidden:YES];
}	

- (void)fadeIn
{
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView	setAnimationDelay:0.1];
	poweredByLabel.alpha = 1.0;
	infoButton.alpha = 1.0;
	spinner.alpha = 1.0;
	loadingLabel.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)fadeOut
{
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView	setAnimationDelay:0.1];
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

- (void)dealloc 
{
	[barImage release];
	[poweredByLabel release];
	[infoButton release];
	[spinner release];
	[loadingLabel release];
    
	[super dealloc];
}

@end
