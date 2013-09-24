//
//  TitleScreen.h
//  EECS441-1
//
//  Created by Jackson on 9/6/13.
//
//

#import <UIKit/UIKit.h>
#import "createSession.h"
#import "joinSession.h"
#import "Constant.h"

@interface TitleScreen : UIViewController {
  
  IBOutlet UIImageView *logo;
  IBOutlet UIButton *CreateButton;
  IBOutlet UIButton *JoinButton;
  IBOutlet UIButton *HelpButton;
  IBOutlet UITextField *userName;
  CollabrifyClient *client;

}

- (IBAction)editingChanged;

@end