//
//  chat.h
//  EECS441-1
//
//  Created by Jackson on 9/9/13.
//
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <Collabrify/Collabrify.h>
#import "eventKind.pb.h"

@interface chat : UIViewController <CollabrifyClientDelegate, CollabrifyClientDataSource, UITableViewDelegate, UITableViewDataSource>{
  
  IBOutlet UIBarButtonItem *usersToggle;
  UITableView *listUsers;
  IBOutlet UITextView *noteData;
  IBOutlet UIView *contentView;
  UIToolbar *keyboardbuttons;
  NSString *iPadUsersTitle;  
  UIView *showUsersBackground;
  
  CollabrifyClient *client;
  
  NSUInteger numUsers;
  NSArray *currentUsers;
  
  NSTimer *participantsTimer;
  int keepCount, formerCursorPos, startPos, formerSize;
  NSMutableString *addedString;
  NSMutableArray *list;
  
  chalkBoard *theEvent;
  
}

@property (nonatomic, retain)  CollabrifyClient *client;
@property (nonatomic, retain)  UITableView *listUsers;


-(IBAction) showUsers:(id) sender;

-(void) reloadTable;

@end
