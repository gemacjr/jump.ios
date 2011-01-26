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
 
 File:	 FeedReaderSummary.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "FeedReaderSummary.h"

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation FeedReaderSummary

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;
    
    reader = [FeedReader feedReader];
    stories = [[reader allStories] retain];
}

- (void)viewWillAppear:(BOOL)animated 
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.title = @"Blog";
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    titleLabel.text = NSLocalizedString(@"Janrain Blog", @"");    
    
    myTable.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    myTable.sectionFooterHeight = 0.0;
    myTable.sectionHeaderHeight = 10.0;
    [myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
 
    [myTable reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (UIImage*)zoomAndCropImage:(UIImage*)image
{
    if (image.size.width < 72 || image.size.height < 72)
        return image;

    NSInteger leftCrop;
    NSInteger topCrop;
    
    if (image.size.width < 144)
        leftCrop = 10;//((image.size.width - 72) / 2);
    else
        leftCrop = 10;//((image.size.width - 72) / 2) - 36;

    if (image.size.height < 180)
        topCrop = ((image.size.height - 72) / 4);//2);
    else
        topCrop = ((image.size.height - 72) / 4) - 18;//2) - 36;
    
    CGRect croppedRect = CGRectMake(leftCrop, topCrop, 72, 72);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croppedRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
    return [stories count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{	
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (iPad)
        return 22.0;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPad)
        return 95;
    else
        return 80;
}

#define PLUS(a,b) a + b 
#define MINUS(a,b) a - b

#define TITLE_FRAME_PHONE 			8,          6,  284,          16
#define IMAGE_FRAME_PHONE           8,          27, 36,           36
#define SPINNER_FRAME_PHONE         18,         37, 16,           16
#define DESCRIPTION_FRAME_PHONE(x)  PLUS(8,x),  25, MINUS(268,x), 36
#define DATE_FRAME_PHONE(x)         PLUS(8,x),  63, MINUS(268,x), 13

#define TITLE_FRAME_PAD 			15,         10, 525,          18
#define DATE_FRAME_PAD              550,        12, 115,          14
#define DESCRIPTION_FRAME_PAD(x)    PLUS(20,x), 34, MINUS(600,x), 51
#define IMAGE_FRAME_PAD				15,         36, 36,           36
#define SPINNER_FRAME_PAD			25,         46, 16,           16

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

//    NSInteger iPadMult = iPad ? 2 : 1;
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

        if (indexPath.section < [stories count])
        {
            NSInteger imageWidth = 42; 

            UIImageView *documentImage = 
                                [[[UIImageView alloc] 
                                        initWithFrame:(iPad ? 
                                               CGRectMake(IMAGE_FRAME_PAD) : 
                                               CGRectMake(IMAGE_FRAME_PHONE))] autorelease];
//                                                                                        /*iPadMult * */8,
//                                                                                        /*iPadMult * */27,
//                                                                                        /*iPadMult * */(imageWidth - 6),
//                                                                                        /*iPadMult * */36)] autorelease];

            
            UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                 /*(iPad) ? UIActivityIndicatorViewStyleWhiteLarge : */UIActivityIndicatorViewStyleWhite] autorelease];
//            if (iPad)
//                [spinner setFrame:CGRectMake(34, 72, 37, 37)];
//            else                
            [spinner setFrame:(iPad ? CGRectMake(SPINNER_FRAME_PAD) : CGRectMake(SPINNER_FRAME_PHONE))];//(18, 37, 16, 16)];
            
            documentImage.backgroundColor = [UIColor grayColor];
            documentImage.clipsToBounds = YES;
            documentImage.contentMode = UIViewContentModeScaleAspectFill;
            
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
                    documentImage.image = [self zoomAndCropImage:storyImage.image];
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

            UILabel *documentTitle = 
                        [[[UILabel alloc] 
                                    initWithFrame:(iPad ? 
                                               CGRectMake(TITLE_FRAME_PAD) : 
                                               CGRectMake(TITLE_FRAME_PHONE))] autorelease];
//                                                                                /*iPadMult * */8, 
//                                                                                /*iPadMult * */6, 
//                                                                                /*iPadMult * */284 /*+ ((iPadMult - 1) * 40)*/, 
//                                                                                /*iPadMult * */16)] autorelease];
            documentTitle.font = [UIFont boldSystemFontOfSize:/*(iPad) ? 28 : */15.0];
            documentTitle.textColor = [UIColor colorWithRed:0.05 green:0.19 blue:0.27 alpha:1.0];
            documentTitle.backgroundColor = [UIColor clearColor];
            documentTitle.text = story.title;
            
            UILabel *documentDescription = 
                        [[[UILabel alloc] 
                                    initWithFrame:(iPad ? 
                                                   CGRectMake(DESCRIPTION_FRAME_PAD(imageWidth)) : 
                                                   CGRectMake(DESCRIPTION_FRAME_PHONE(imageWidth)))] autorelease];
//                                                                                      /*iPadMult * */(8 + imageWidth),
//                                                                                      /*iPadMult *  */25,
//                                                                                      /*iPadMult * */(268 - imageWidth)/* + ((iPadMult - 1) * 40)*/, 
//                                                                                      /*iPadMult *  */36)] autorelease];
            documentDescription.font = [UIFont systemFontOfSize:/*(iPad) ? 24 : */14.0];
            documentDescription.textColor = [UIColor darkGrayColor];
            documentDescription.numberOfLines = iPad ? 3 : 2;
            documentDescription.backgroundColor = [UIColor clearColor];
            documentDescription.text = story.plainText;
            
            UILabel *documentDate = 
                        [[[UILabel alloc] 
                                    initWithFrame:(iPad ? 
                                                   CGRectMake(DATE_FRAME_PAD) : 
                                                   CGRectMake(DATE_FRAME_PHONE(imageWidth)))] autorelease];
//                                                                               /*iPadMult * */(8 + imageWidth),
//                                                                               /*iPadMult *  */63,
//                                                                               /*iPadMult * */(268 - imageWidth),
//                                                                               /*iPadMult *  */13)] autorelease];
            documentDate.font = [UIFont systemFontOfSize:/*iPadMult * */11.0];
            documentDate.textColor = [UIColor darkGrayColor];
            documentDate.textAlignment = iPad ? UITextAlignmentRight : UITextAlignmentLeft;
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
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
//            cell.contentView.backgroundColor = [UIColor redColor];
            
            UIView *arr[6] = { cell.contentView, documentImage, spinner, documentTitle, documentDescription, documentDate };
            NSString *strs[6] = {@"content", @"image", @"spinner", @"title", @"descrip", @"date" };
            
            for (int i = 0; i < 6; i++)
                NSLog (@"%@ frame: %f, %f, %f, %f", strs[i], arr[i].frame.origin.x, arr[i].frame.origin.y, arr[i].frame.size.width, arr[i].frame.size.height);
                       
            NSLog(@"\n");
        }
    }
    else
    {
        UIImageView *documentImage = (UIImageView*)[cell.contentView viewWithTag:imageTag];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[cell.contentView viewWithTag:spinnerTag];
        UILabel *documentDescription = (UILabel*)[cell.contentView viewWithTag:descriptionTag];
        UILabel *documentDate = (UILabel*)[cell.contentView viewWithTag:dateTag];
                
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
                    documentImage.image = [self zoomAndCropImage:storyImage.image];
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
                [documentDescription setFrame:(iPad ? 
                                               CGRectMake(DESCRIPTION_FRAME_PAD(0)) : 
                                               CGRectMake(DESCRIPTION_FRAME_PHONE(0)))];///*iPadMult * */8, /*iPadMult * */25, /*iPadMult * */268 /*+ ((iPadMult - 1) * 40)*/, /*iPadMult * */36)];
                [documentDate setFrame:(iPad ? 
                                        CGRectMake(DATE_FRAME_PAD) : 
                                        CGRectMake(DATE_FRAME_PHONE(0)))];///*iPadMult * */8, /*iPadMult * */63, /*iPadMult * */268, /*iPadMult * */13)];
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    reader.selectedStory = [stories objectAtIndex:indexPath.section];

    if (!detailViewController)
    {
        if (iPad)
            detailViewController = [[FeedReaderDetail alloc] initWithNibName:@"FeedReaderDetail-iPad" 
                                                                      bundle:[NSBundle mainBundle]];
        else
            detailViewController = [[FeedReaderDetail alloc] initWithNibName:@"FeedReaderDetail" 
                                                                      bundle:[NSBundle mainBundle]];
    }
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
    
    [detailViewController release];
    [stories release];
    
    [super dealloc];
}


@end

 