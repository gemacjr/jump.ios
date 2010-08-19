//
//  RootViewController.h
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedReaderDetail.h"
#import "FeedReader.h"

@interface FeedReaderSummary : UITableViewController <NSXMLParserDelegate>
{
	IBOutlet UITableView *myTable;
    
	UIActivityIndicatorView *activityIndicator;

    FeedReaderDetail *detailViewController;
    FeedReader *reader;
    
    NSArray *sortedStories;
}
@end