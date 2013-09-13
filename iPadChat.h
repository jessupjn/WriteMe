//
//  iPadChat.h
//  EECS441-1
//
//  Created by Jackson on 9/12/13.
//
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>

@interface iPadChat : UIViewController{
  

  IBOutlet UITableView *listUsers;
  IBOutlet UITextView *noteData;
  IBOutlet UIView *contentView;
  IBOutlet UINavigationBar *iPadUsersBar;
  IBOutlet UINavigationItem *iPadBar;
  UIToolbar *keyboardbuttons;
  NSString *iPadUsersTitle;


  CollabrifyClient *client;

  NSUInteger numUsers;
  NSArray *currentUsers;

}

@property (nonatomic, retain)  CollabrifyClient *client;
@property (nonatomic, retain)  UITableView *listUsers;

-(IBAction)reloadButton:(id)sender;
-(void) reloadTable;

@end