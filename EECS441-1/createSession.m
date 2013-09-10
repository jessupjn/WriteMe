//
//  createSession.m
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import "createSession.h"

@interface createSession ()

@end

@implementation createSession

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
  NSError *error;
  client = [[CollabrifyClient alloc] initWithGmail:@"jessupjn@umich.edu"
                                       displayName:@"Jack"
                                      accountGmail:@"441fall2013@umich.edu"
                                       accessToken:@"XY3721425NoScOpE"
                                    getLatestEvent:NO
                                             error:&error];
  [client setDelegate:(id)self];
  [client setDataSource:(id)self];
  if(error) NSLog(@"GET THIS:/n%@", error);

  [infoBackground.layer setBorderWidth:3];
  [infoBackground.layer setCornerRadius:10];
  
  [sessionName setDelegate:(id)self];
  [userName setDelegate:(id)self];
  [password setDelegate:(id)self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"Back Completed");
  }];
}

-(IBAction) create:(id) sender{
  [self.view endEditing:YES];
  if ( [[userName text] isEqualToString:@""] || [[sessionName text] isEqualToString:@""]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please make sure all required fields are filled!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
  }
  else{
    NSArray *tags = [[NSArray alloc] initWithObjects:@"Some Tags", nil];
    [client createSessionWithBaseFileWithName:[sessionName text]
                                          tags:tags
                                      password:[password text]
                                   startPaused:NO
                             completionHandler:^(int64_t sessionID, CollabrifyError *error){
                              
                               if(!error){
                                NSLog(@"Session Successfully Created");
                                [self performSegueWithIdentifier:@"createTheSession" sender:self];
                               }
                               else NSLog(@"%@", error);
                              
                              }];
  }
}
@end
