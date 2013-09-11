//
//  joinSession.m
//  EECS441-1
//
//  Created by Jackson on 9/8/13.
//
//

#import "joinSession.h"

@interface joinSession ()

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
  [client setDelegate:(id)self];
  [client setDataSource:(id)self];
  
  [infoBackground.layer setBorderWidth:3];
  [infoBackground.layer setCornerRadius:10];
  
  [sessionName setDelegate:(id)self];
  [password setDelegate:(id)self];
}

- (void)viewWillAppear:(BOOL)animated{
  [password setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"joinTheSession"]){
    chat *nextScreen = [segue destinationViewController];
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


-(IBAction) back:(id) sender{
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"Back Completed");
  }];
}

-(IBAction) join:(id) sender{
  [self.view endEditing:YES];
  if ( [[sessionName text] isEqualToString:@""]){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please make sure all necessary fields are filled!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
  }
  else{
    [client joinSessionWithID:atoll([[sessionName text] UTF8String]) password:[password text] completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error) {
      if(!error) [self performSegueWithIdentifier:@"joinTheSession" sender:self];
      else NSLog(@"%@", error);
    }];
  }
}

@end
