//
//  QSIEmbeddedTableView.h
//  QuickSignIn
//
//  Created by lilli on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSIUserModel.h"

@interface InfoViewController : UIViewController
{
	IBOutlet UIButton *linkButton;
}
- (IBAction)janrainLinkClicked:(id)sender;
@end

@interface EmbeddedTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *myTableView;
}
@end
