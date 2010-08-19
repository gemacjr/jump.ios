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


- (void)viewDidLoad {
    [super viewDidLoad];

    reader = [FeedReader feedReader];
    stories = [[reader allStories] retain];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated 
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.title = @"Janrain Blog";
    
    myTable.backgroundColor = [UIColor lightGrayColor];//[UIColor whiteColor];
                                                       //[UIColor colorWithRed:(101.0/255.0) green:(196.0/255.0) blue:(234.0/255.0) alpha:1.0];
//  myTable.separatorColor = [UIColor clearColor];
    [myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTable.sectionFooterHeight = 0.0;
    myTable.sectionHeaderHeight = 10.0;
}


- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
 
    [myTable reloadData];
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
    return [stories count];// + 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{	
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [stories count])
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
        
    Story *story = [stories objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

        if (indexPath.section < [stories count])
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
            
            /* If storyImages > 2, only check for the first two images (since we are only downloading the first two images).  
               If there are less than 2 storyImages (0 or 1), only check the first or don't check at all. */
            BOOL imageAvailable = NO;
            for (int i = 0; i < (([story.storyImages count] > 2) ? 2 : [story.storyImages count]); i++)
            {
                StoryImage *storyImage = [story.storyImages objectAtIndex:i];
                imageAvailable = YES;
                
                /* If an image has already downloaded, set the image and break. */
                if (storyImage.image)
                {
                    [spinner stopAnimating];
                    documentImage.backgroundColor = [UIColor whiteColor];
                    documentImage.image = storyImage.image;
                    break;
                }
                else if (storyImage.downloadFailed) /* If the image failed to download, check the next image, or don't use an image. */
                {
                    imageAvailable = NO;
                }
                else /* Otherwise, there is an image url but not an image.  It's probably still downloading.  Keep that spinner spinning. */
                {
                    [spinner startAnimating];
                }
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
            
//           UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background.png"]] autorelease];
//           cell.backgroundView = background;

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            [story release];
        }
    }
    else
    {
        UIImageView *documentImage = (UIImageView*)[cell.contentView viewWithTag:imageTag];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[cell.contentView viewWithTag:spinnerTag];
        UILabel *documentDescription = (UILabel*)[cell.contentView viewWithTag:descriptionTag];
                
        if (![spinner isHidden]) /* If we were previously waiting for the image to download. */
        {
            BOOL imageAvailable = NO;
            for (int i = 0; i < (([story.storyImages count] > 2) ? 2 : [story.storyImages count]); i++)
            {
                StoryImage *storyImage = [story.storyImages objectAtIndex:i];
                imageAvailable = YES;
                
                /* If an image has already downloaded, set the image and break. */
                if (storyImage.image)
                {
                    [spinner stopAnimating];
                    documentImage.backgroundColor = [UIColor whiteColor];
                    documentImage.image = storyImage.image;
                    break;
                }
                else if (storyImage.downloadFailed) /* If the image failed to download, check the next image, or don't use an image. */
                {
                    imageAvailable = NO;
                }
                else /* Otherwise, there is an image url but not an image.  It's probably still downloading.  Keep that spinner spinning. */
                {
                    [spinner startAnimating];
                }
            }
            
            if (!imageAvailable)
            {
                [documentImage setHidden:YES];
                [spinner stopAnimating];
                [documentDescription setFrame:CGRectMake(8, 25, 270, 36)];
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
    reader.selectedStory = [stories objectAtIndex:indexPath.section];

    if (!detailViewController)
        detailViewController = [[FeedReaderDetail alloc] initWithNibName:@"FeedReaderDetail" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:detailViewController animated:YES];
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
    [myTable release];
    
//	[activityIndicator release];
    
    [detailViewController release];
    [stories release];
    
    [super dealloc];
}


@end

 