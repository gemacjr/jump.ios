//
//  FeedReaderFeeds.h
//  QuickShare
//
//  Created by lilli on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedReaderSummary.h"

@interface FeedReaderFeeds : UIViewController 
{
    IBOutlet UIButton *feedButton;
    IBOutlet UIButton *janrainLink;
    
    FeedReaderSummary *summaryViewController;
}

- (IBAction)janrainBlogSelected:(id)sender;
- (IBAction)janrainLinkClicked:(id)sender;
@end
