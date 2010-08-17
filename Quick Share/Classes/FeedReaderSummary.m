//
//  RootViewController.m
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FeedReaderSummary.h"

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation FeedReaderSummary


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated 
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.title = @"Janrain Blog";
    
    reader = [FeedReader initFeedReader];
//    [reader addFeedForUrl:@"http://rss.slashdot.org/Slashdot/slashdot"];

    //        [stories release];
    //        stories = [[NSDictionary alloc] initWithDictionary:[reader allStories] copyItems:YES];
    
    [sortedStories release];
    sortedStories = [[NSArray alloc] initWithArray:[reader allStories]];// copyItems:YES];//[stories allKeys];//[[stories allKeys] filteredArrayUsingPredicate:[NSPredicate ]]        
    
    newsTable.backgroundColor = [UIColor colorWithRed:(101.0/255.0) green:(196.0/255.0) blue:(234.0/255.0) alpha:1.0];//[UIColor whiteColor];
//    newsTable.separatorColor = [UIColor clearColor];
    [newsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    newsTable.sectionFooterHeight = 0.0;
    newsTable.sectionHeaderHeight = 10.0;
}


- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
 
    [newsTable reloadData];
}


/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
    return [sortedStories count];// + 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{	
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [sortedStories count])
        return 40;
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"cachedCellForSection_%d", indexPath.section];
    static NSInteger imageTag       = 10;
    static NSInteger spinnerTag     = 20;
    static NSInteger titleTag       = 30;
    static NSInteger descriptionTag = 40;
    static NSInteger dateTag        = 50;
    
    NSInteger log = 0;
    
    Story *story = [[sortedStories objectAtIndex:indexPath.section] retain];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

        if (indexPath.section < [sortedStories count])
        {
            NSInteger imageWidth = 42; 
            UIImageView *documentImage = [[[UIImageView alloc] initWithFrame:CGRectMake(8, 27, imageWidth - 6, 36)] autorelease];
            UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] 
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
            [spinner setFrame:CGRectMake(18, 37, 16, 16)];
            
            documentImage.backgroundColor = [UIColor grayColor];
            documentImage.clipsToBounds = YES;
            
            [spinner setHidesWhenStopped:YES];
            [spinner startAnimating];
            
            BOOL imageAvailable = NO;
            
            if ([story.storyImages count] > 0)
            {
                StoryImage *storyImage = [story.storyImages objectAtIndex:0];
                imageAvailable = YES;
                
                if (storyImage.imageData)
                {
                    [spinner stopAnimating];
                    documentImage.backgroundColor = [UIColor clearColor];
                    documentImage.image = [UIImage imageWithData:storyImage.imageData];
                }
                else
                {
                    [spinner startAnimating];
                }
            }
            
            if (!imageAvailable && story.feed.image)
            {
                // TODO
            }
            
            if (!imageAvailable)
            {
                [documentImage setHidden:YES];
                [spinner stopAnimating];
                imageWidth = 0;
            }

            UILabel *documentTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8, 6, 284, 16)] autorelease];
            documentTitle.font = [UIFont boldSystemFontOfSize:15.0];
            documentTitle.textColor = [UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0];
            documentTitle.backgroundColor = [UIColor clearColor];
            documentTitle.text = story.title;
            
            UILabel *documentDescription = [[[UILabel alloc] initWithFrame:CGRectMake(8 + imageWidth, 25, 270   - imageWidth, 36)] autorelease];
            documentDescription.font = [UIFont systemFontOfSize:14.0];
            documentDescription.textColor = [UIColor darkGrayColor];
//            documentDescription.lineBreakMode = UILineBreakModeWordWrap;
            documentDescription.numberOfLines = 2;
            documentDescription.backgroundColor = [UIColor clearColor];
            documentDescription.text = story.plainText;//story.description;
            
            UILabel *documentDate = [[[UILabel alloc] initWithFrame:CGRectMake(10, 63, 280, 13)] autorelease];
            documentDate.font = [UIFont systemFontOfSize:11.0];
            documentDate.textColor = [UIColor darkGrayColor];
            documentDate.textAlignment = UITextAlignmentRight;
            documentDate.backgroundColor = [UIColor clearColor];
            documentDate.text = story.pubDate;
            
            [documentImage setTag:imageTag];
            [spinner setTag:spinnerTag];
            [documentTitle setTag:titleTag];
            [documentDescription setTag:descriptionTag];
            [documentDate setTag:dateTag];
            
            [cell.contentView addSubview:documentImage];
            [cell.contentView addSubview:spinner];
            [cell.contentView addSubview:documentTitle];
            [cell.contentView addSubview:documentDescription];
            [cell.contentView addSubview:documentDate];
            
            UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background.png"]] autorelease];
            cell.backgroundView = background;

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            [story release];
        }
        else if (indexPath.section == [sortedStories count])
        {
            cell.textLabel.text = @"Reload Stories";
        }
    }
    else
    {
        UIImageView *documentImage = (UIImageView*)[cell.contentView viewWithTag:imageTag];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[cell.contentView viewWithTag:spinnerTag];
        
        if (![spinner isHidden])
        {
            BOOL imageAvailable = NO;
            
            if ([story.storyImages count] > 0)
            {
                StoryImage *storyImage = [story.storyImages objectAtIndex:0];
                imageAvailable = YES;
                
                if (storyImage.imageData)
                {
                    [spinner stopAnimating];
                    documentImage.image = [UIImage imageWithData:storyImage.imageData];
                }
            }
            
            if (!imageAvailable && story.feed.image)
            {                
                // TODO
            }
        }
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == [sortedStories count])
    {
//        [stories release];
//        stories = [[NSDictionary alloc] initWithDictionary:[reader allStories] copyItems:YES];
        
        [sortedStories release];
        sortedStories = [[NSArray alloc] initWithArray:[reader allStories]];// copyItems:YES];//[stories allKeys];//[[stories allKeys] filteredArrayUsingPredicate:[NSPredicate ]]        
    }
    else
    {
        reader.selectedStory = [sortedStories objectAtIndex:indexPath.section];
        FeedReaderDetail *detailViewController = [[FeedReaderDetail alloc] initWithNibName:@"FeedReaderDetail" bundle:[NSBundle mainBundle]];

//        detailViewController.story = [sortedStories objectAtIndex:indexPath.row];

        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	[stories release];
    
    [super dealloc];
}


@end

 