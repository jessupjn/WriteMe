//
//  createSession.m
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import "createSession.h"

@interface createSession () <UITextFieldDelegate, CollabrifyClientDelegate, CollabrifyClientDataSource>

@end

@implementation createSession

@synthesize client;

- (NSData *)client:(CollabrifyClient *)client requestsBaseFileChunkForCurrentBaseFileSize:(NSInteger)baseFileSize{
  return nil;
}

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
  NSLog(@"createSession");
  int w = self.view.frame.size.width;
  int h = self.view.frame.size.height;
  wholeScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w , h)];
  visableObj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w/2, w/2)];
  [wholeScreen setBackgroundColor:[UIColor clearColor]];
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
  
  [sessionName setDelegate:self];
  [password setDelegate:self];
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
  if([[segue identifier] isEqualToString:@"createTheSession"]){
    iPhoneChat *nextScreen = [segue destinationViewController];
    [nextScreen setClient:client];
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



//                      BACK/FORWARD BUTTONS
// ---------------------------------------------------------------
-(IBAction) back:(id) sender{
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:^{
  }];
}

-(IBAction) create:(id) sender{
  [wholeScreen setHidden:NO];
  [visableObj setHidden:NO];
  [spinner startAnimating];
  [self.view endEditing:YES];
  if ( [[sessionName text] isEqualToString:@""]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please make sure all required fields are filled!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
    [wholeScreen setHidden:YES];
    [visableObj setHidden:YES];
    [spinner stopAnimating];
  }
  else{
    NSArray *tags = [[NSArray alloc] initWithObjects:@"Some Tags", nil];
    [client createSessionWithName:[sessionName text]
                             tags:tags
                         password:[password text]
                      startPaused:NO
                completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                              
                               if(!error){
                                NSLog(@"Session Successfully Created");
                                [self performSegueWithIdentifier:@"createTheSession" sender:self];
                               }
                               else{
                                 NSLog(@"THIS IS THE ERROR");
                                 NSLog(@"%@", error);
                                 [wholeScreen setHidden:YES];
                                 [visableObj setHidden:YES];
                                 [spinner stopAnimating];
                                 if (error.type == 205){
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"A session with this name already exists!"
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
