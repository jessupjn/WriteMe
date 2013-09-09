//
//  joinSession.h
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import <UIKit/UIKit.h>

@interface joinSession : UIViewController{
  IBOutlet UIView *infoBackground;
  IBOutlet UITextField *sessionName;
  IBOutlet UITextField *userName;
  IBOutlet UITextField *password;
  
}

-(IBAction) back:(id) sender;
-(IBAction) join:(id) sender;

@end
