//
//  iPadChat.h
//  EECS441-1
//
//  Created by Jackson on 9/12/13.
//
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <Collabrify/Collabrify.h>
#import "eventKind.pb.h"

@interface iPadChat : UIViewController{
  

  UITableView *userList;
  IBOutlet UITextView *noteData;
  IBOutlet UIView *contentView;
  IBOutlet UINavigationBar *iPadUsersBar;
  IBOutlet UINavigationItem *iPadBar;
  UIToolbar *keyboardbuttons;
  NSString *iPadUsersTitle;

  NSUndoManager *undoManager;
  
  CollabrifyClient *client;

  NSUInteger numUsers;
  NSArray *currentUsers;
  
  NSTimer *participantsTimer;
  int keepCount, formerCursorPos, startPos, formerSize;
  NSMutableString *addedString;
  NSMutableArray *list;
  
  UILabel *placeHolder;
  
  chalkBoard *theEvent;
  
}

@property (nonatomic,retain) NSUndoManager *undoManager;
@property (nonatomic, retain)  CollabrifyClient *client;
@property (nonatomic, retain)  UITableView *listUsers;

-(void) reloadTable;

@end