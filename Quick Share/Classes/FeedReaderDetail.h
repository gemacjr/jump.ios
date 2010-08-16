//
//  FeedReaderDetail.h
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedReader.h"

@interface FeedReaderDetail : UIViewController <UIWebViewDelegate>
{
    Story *story;
  
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
//@property (nonatomic, retain) IBOutlet UILabel *storyTitle;
//@property (nonatomic, retain) IBOutlet UITextView *storyDescription;
//@property (nonatomic, retain) IBOutlet UIImageView *storyMedia;
@end
