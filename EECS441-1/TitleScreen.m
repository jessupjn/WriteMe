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
  
  [CreateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [CreateButton.layer setBorderWidth:2];
  [CreateButton.layer setBorderColor:[UIColor blackColor].CGColor];
  [CreateButton.layer setCornerRadius:16];
  
  [JoinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [JoinButton.layer setBorderWidth:2];
  [JoinButton.layer setBorderColor:[UIColor blackColor].CGColor];
  [JoinButton.layer setCornerRadius:16];
  
  [HelpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [HelpButton.layer setBorderWidth:2];
  [HelpButton.layer setBorderColor:[UIColor blackColor].CGColor];
  [HelpButton.layer setCornerRadius:16];
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
