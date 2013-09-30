//
//  joinSession.m
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import "joinSession.h"

@interface joinSession () <UITextFieldDelegate, CollabrifyClientDelegate, CollabrifyClientDataSource>

@end

@implementation joinSession

@synthesize client;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  NSLog(@"joinSession");
  int w = self.view.frame.size.width;
  int h = self.view.frame.size.height;
  NSLog(@"%i %i", w, h);
  wholeScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*w, 2*h)];
  [wholeScreen setBackgroundColor:[UIColor clearColor]];
  [wholeScreen setAlpha:1];
  [wholeScreen setCenter: self.view.center];
  visableObj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*w/3, 2*w/3)];
  [visableObj setCenter:CGPointMake(w/2, h/2)];
  [visableObj setBackgroundColor:[UIColor blackColor]];
  [visableObj setAlpha:0.7];
  [visableObj.layer setCornerRadius:20];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner setCenter:[visableObj center]];
  [spinner setHidesWhenStopped:YES];
  [[self view] addSubview:wholeScreen];
  [[self view] addSubview:visableObj];
  [[self view] addSubview:spinner];
  
  [client setDelegate:self];
  [client setDataSource:self];
  
  [infoBackground.layer setBorderWidth:3];
  [infoBackground.layer setCornerRadius:10];
  
  [sessionName setDelegate:(id)self];
  [password setDelegate:(id)self];
}

- (void)viewWillAppear:(BOOL)animated{
  [password setText:@""];
  [visableObj setHidden:YES];
  [wholeScreen setHidden:YES];
  [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"joinTheSession"]){
    iPhoneChat *nextScreen = [segue destinationViewController];
    [nextScreen setClient:client];
    NSLog(@"COPIED");
  }
}

//                    KEYBOARD MOVEMENTS/LOGISTICS
// ---------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
  const int movementDistance = 80; // tweak as needed
  const float movementDuration = 0.3f; // tweak as needed
  
  int movement = (up ? -movementDistance : movementDistance);
  
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}
// ---------------------------------------------------------------
// ---------------------------------------------------------------


-(IBAction) back:(id) sender{
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:^{
  }];
}

-(IBAction) join:(id) sender{
  [wholeScreen setHidden:NO];
  [visableObj setHidden:NO];
  [spinner startAnimating];
  [self.view endEditing:YES];
  if ( [[sessionName text] isEqualToString:@""]){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please make sure all necessary fields are filled!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [wholeScreen setHidden:YES];
    [visableObj setHidden:YES];
    [spinner stopAnimating];
  }
  else{
    [client joinSessionWithID:atoll([[sessionName text] UTF8String]) password:[password text] completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error) {
      if(!error){
        NSLog(@"Session Successfully Joined");
        [self performSegueWithIdentifier:@"joinTheSession" sender:self];
      }
      else{
        NSLog(@"%@", error);
        [wholeScreen setHidden:YES];
        [visableObj setHidden:YES];
        [spinner stopAnimating];
        NSLog(@"%d", error.type);
        NSLog(@"%d", CollabrifyServerSideErrorSessionAlreadyExists);
        if (error.type == 205){
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Session could not be found! Please check your ID number and try again!"
                                                              message:nil delegate:self
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil];
          [alertView show];
        }
      }
    }];
  }
}

@end
