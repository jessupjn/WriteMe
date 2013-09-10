//
//  createSession.h
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>

@interface createSession : UIViewController <CollabrifyClientDelegate, CollabrifyClientDataSource>{
  IBOutlet UIView *infoBackground;
  IBOutlet UITextField *sessionName;
  IBOutlet UITextField *userName;
  IBOutlet UITextField *password;
  CollabrifyClient *client;

}

-(IBAction) back:(id) sender;
-(IBAction) create:(id) sender;

@end
