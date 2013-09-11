//
//  chat.h
//  EECS441-1
//
//  Created by Jackson on 9/9/13.
//
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>

@interface chat : UIViewController <CollabrifyClientDelegate, CollabrifyClientDataSource, UITableViewDelegate, UITableViewDataSource>{
  IBOutlet UIBarButtonItem *usersToggle;
  IBOutlet UIView *showUsersBackground;
  IBOutlet UITableView *listUsers;
  
  CollabrifyClient *client;
  
  NSUInteger numUsers;
  NSArray *currentUsers;
  NSString *sessionID;
  
  // USED ONLY ON IPAD
  // --------------------------------------------------------------
  IBOutlet UINavigationItem *iPadUsersBar;
  NSString *iPadUsersTitle;

}

@property (nonatomic, retain)  CollabrifyClient *client;
@property (nonatomic, retain)  UITableView *listUsers;


-(IBAction) showUsers:(id) sender;
-(IBAction) reloadButton:(id) sender;


@end
