//
//  FeedReaderDetail.h
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedReader.h"

@interface FeedReaderDetail : UIViewController 
{
    Story *story;
    
//    IBOutlet UILabel *title;
//    IBOutlet UITextView *description;
//    IBOutlet UIImageView *media;

    UILabel *storyTitle;
    UITextView *storyDescription;
    UIImageView *storyMedia;
    
}
@property (nonatomic, retain) IBOutlet UILabel *storyTitle;
@property (nonatomic, retain) IBOutlet UITextView *storyDescription;
@property (nonatomic, retain) IBOutlet UIImageView *storyMedia;
@end
