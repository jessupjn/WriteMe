//
//  chat.m
//  EECS441-1
//
//  Created by Jackson on 9/9/13.
//
//

#import "chat.h"

@interface chat ()

@end

@implementation chat

@synthesize client;
@synthesize listUsers;

//    TableView (populated with users)
//------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [currentUsers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
  }
  
  // Set up the cell...
  NSLog(@"%@", currentUsers[indexPath.row]);
  [[cell textLabel] setText: [currentUsers[indexPath.row] displayName]];
  [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
  return cell;
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
  
  sessionID = [NSString stringWithFormat:@"Session ID: %lli", [client currentSessionID]];
  [[self navigationItem] setPrompt:sessionID];
  [usersToggle setTitle:@"Show Users"];
  
  currentUsers = [client currentSessionParticipants];
  numUsers = [client currentSessionParticipantCount];
  if (numUsers <= 1)
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d User", numUsers]];
  else
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d Users", numUsers]];
  [iPadUsersBar setTitle:iPadUsersTitle];
  
  [listUsers.layer setBorderWidth:1];
  [client currentSessionParticipantCount];
  currentUsers = [client currentSessionParticipants];

  [listUsers setDataSource:(id)self];
  [listUsers setDelegate:(id)self];
  [listUsers reloadData];

}

-(void)viewWillDisappear:(BOOL)animated
{
  [client leaveAndDeleteSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
    if(success) NSLog(@"Was it a success??     %hhd", success);
    else NSLog(@"ERROR: %@", error);
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) showUsers:(id) sender{
  if([[usersToggle title] isEqualToString:@"Show Users"]){
    [self performSelector:@selector(reloadTable)];
    
    [[self navigationItem] setTitle:iPadUsersTitle];
    [UIView animateWithDuration:0.3 animations:^(void){
      [showUsersBackground setFrame:CGRectMake(0, 95, 320, 505)];
      [listUsers setFrame:CGRectMake(83, 95, 200, 505)];
      [usersToggle setTitle:@"Hide Users"];
    }];
  }
  else{
    [[self navigationItem] setTitle:@"Notepad"];
    [UIView animateWithDuration:0.3 animations:^(void){
      [showUsersBackground setFrame:CGRectMake(320, 95, 320, 505)];
      [listUsers setFrame:CGRectMake(403, 95, 200, 505)];
      [usersToggle setTitle:@"Show Users"];
    }];
  }
}

-(IBAction) reloadButton:(id) sender{
  [self performSelector:@selector(reloadTable)];
}
-(void) reloadTable{
  currentUsers = [client currentSessionParticipants];
  numUsers = [client currentSessionParticipantCount];
  if (numUsers <= 1)
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d User", numUsers]];
  else
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d Users", numUsers]];
  [iPadUsersBar setTitle:iPadUsersTitle];
  [listUsers reloadData];
}

@end
