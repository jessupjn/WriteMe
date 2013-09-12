//
//  joinSession.h
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>
#import "chat.h"

@interface joinSession : UIViewController{
  IBOutlet UIView *infoBackground;
  IBOutlet UITextField *sessionName;
  IBOutlet UITextField *password;
  CollabrifyClient *client;
  NSString *userName;
  
  // hold user while creating session.
  UIView *wholeScreen;
  UIView *visableObj;
  UIActivityIndicatorView *spinner;
  
}
@property (nonatomic, retain) CollabrifyClient *client;


-(IBAction) back:(id) sender;
-(IBAction) join:(id) sender;

@end
