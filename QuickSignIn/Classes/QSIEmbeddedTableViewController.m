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

 File:   QSIEmbeddedTableViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "QSIEmbeddedTableViewController.h"

@implementation InfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    linkButton.titleLabel.textAlignment = UITextAlignmentCenter;

    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                      target:[UserModel getUserModel]
                                      action:@selector(triggerAuthenticationDidCancel:)] autorelease];

    self.navigationItem.rightBarButtonItem = cancelButton;

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}

- (IBAction)janrainLinkClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.janrain.com"]];
}
@end


@implementation EmbeddedTableViewController

- (void)loadView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)
                                               style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [button setFrame:CGRectMake(10, 2, 300, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"button_janrain_280x40.png"]
                      forState:UIControlStateNormal];

    [button setTitle:@"Sign In" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];

    [button addTarget:self
               action:@selector(signInButtonTouchUpInside:)
     forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    [footerView addSubview:button];

    myTableView.tableFooterView = footerView;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;

    self.view = myTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [myTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Example native login";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITextField *textField;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        textField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 7, 280, 26)] autorelease];

        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;

        [cell.contentView addSubview:textField];

        if (indexPath.row == 0)
        {
            textField.placeholder = @"enter your email";
        }
        else
        {
            textField.placeholder = @"enter your password";
            textField.secureTextEntry = YES;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return YES;
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
    InfoViewController *info = [[[InfoViewController alloc] initWithNibName:@"QSIInfoViewController"
                                                                     bundle:[NSBundle mainBundle]] autorelease];

    [[UserModel getUserModel].navigationController pushViewController:info animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [myTableView release];
    [super dealloc];
}
@end

