//
//  TitleScreen.m
//  EECS441-1
//
//  Created by Jackson on 9/6/13.
//
//

#import "TitleScreen.h"

@interface TitleScreen ()

@end

@implementation TitleScreen

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

  [logo.layer setBorderWidth:2];
  [logo.layer setCornerRadius:16];
  
  [userName setDelegate:(id)self];

  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"createButton"]){
    UINavigationController *nav = [segue destinationViewController];
    createSession *create = (createSession *)[nav topViewController];
    [create setClient:client];
  }
  else if([[segue identifier] isEqualToString:@"joinButton"]){
    UINavigationController *nav = [segue destinationViewController];
    joinSession *join = (joinSession *)[nav topViewController];
    [join setClient:client];
  }
  
}

- (IBAction)editingChanged{
  NSLog(@"%@", [userName text]);
  if( [[userName text] length] < 1 ){
    [JoinButton setEnabled:NO];
    [CreateButton setEnabled:NO];
  }
  else{
    [JoinButton setEnabled:YES];
    [CreateButton setEnabled:YES];
    NSError *error;
    client = [[CollabrifyClient alloc] initWithGmail:@"jessupjn@umich.edu"
                                         displayName:[userName text]
                                        accountGmail:@"441fall2013@umich.edu"
                                         accessToken:@"XY3721425NoScOpE"
                                      getLatestEvent:NO
                                               error:&error];
    [client setDelegate:(id)self];
    [client setDataSource:(id)self];
  }
}


@end
