//
//  FeedReaderDetail.h
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedReader.h"
#import "FeedReaderWebView.h"
#import "JRActivityObject.h"

@class Story;
@interface FeedReaderDetail : UIViewController <UIWebViewDelegate>
{
    Story *story;
    
    FeedReaderWebView *feedReaderWebview;
    IBOutlet UIWebView *webview;
    
//    IBOutlet UILabel *title;
//    IBOutlet UITextView *description;
//    IBOutlet UIImageView *media;
//    IBOutlet UIScrollView *scrollView;
//    IBOutlet UIView       *contentView;
//    
//    
//    IBOutlet UILabel *storyTitle;
//    IBOutlet UILabel *storyDate;
//    IBOutlet UIWebView *storyContent;
    
//    IBOutlet UILabel *storySection1;
//    IBOutlet UILabel *storySection2;
//    IBOutlet UILabel *storySection3;
//    IBOutlet UIImageView *storyThumbnail;
    
}

- (void)authenticationFailed:(NSError*)error;
@end
