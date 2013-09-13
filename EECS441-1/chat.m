//
//  chat.m
//  EECS441-1
//
//  Created by Jackson on 9/9/13.
//
//

#import "chat.h"

@interface chat () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CollabrifyClientDataSource, CollabrifyClientDelegate>

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
  NSLog(@"%@", [currentUsers[indexPath.row] displayName]);
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
  [listUsers.layer setBorderWidth:1];
  
  [self performSelector:@selector(reloadTable)];
  [noteData setDelegate:(id)self];
  [self buildButtons];
  
  [noteData setFrame:CGRectMake(0, 94, 320, 474)];
  [noteData setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
  
  showUsersBackground = [[UIView alloc] initWithFrame:CGRectMake(320, 94, 320, 474)];
  [showUsersBackground setBackgroundColor:[UIColor blackColor]];
  [showUsersBackground setAlpha:0.7];
  listUsers = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 474)];
  [listUsers setCenter:[showUsersBackground center]];
  [[self view] addSubview:showUsersBackground];
  [[self view] addSubview:listUsers];
  [listUsers setDelegate:(id)self];
  [listUsers setDataSource:(id)self];
  NSLog(@"---------------------");
  NSLog(@"%lu", (unsigned long)[client currentSessionParticipantCount]);
  NSLog(@"%@", [client currentSessionParticipants]);
  NSLog(@"---------------------");

  [noteData.layer setBorderWidth:1];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeUp:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeDown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
  [client leaveAndDeleteSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
    if(success){
      NSLog(@"Was it a success??     %hhd", success);
    }
    else NSLog(@"ERROR: %@", error);
  }];
  [noteData resignFirstResponder];

}

-(IBAction) showUsers:(id) sender{
  [noteData resignFirstResponder];
  if([[usersToggle title] isEqualToString:@"Show Users"]){
    [self performSelector:@selector(reloadTable)];

    [[self navigationItem] setTitle:iPadUsersTitle];
    [UIView animateWithDuration:0.3 animations:^(void){
      [showUsersBackground setFrame:CGRectMake(0, 94, 320, 474)];
      [listUsers setFrame:CGRectMake(60, 94, 200, 474)];
      [usersToggle setTitle:@"Hide Users"];
    }];
  }
  else{
    [[self navigationItem] setTitle:@"Notepad"];
      [UIView animateWithDuration:0.2 animations:^(void){
      [showUsersBackground setFrame:CGRectMake(320, 94, 320, 474)];
      [listUsers setFrame:CGRectMake(380, 94, 200, 474)];
      [usersToggle setTitle:@"Show Users"];
    }];
  }
}

-(void) reloadTable{
  
  dispatch_async( dispatch_get_main_queue(), ^{
    // Add code here to update the UI/send notifications based on the
    // results of the background processing
    currentUsers = [client currentSessionParticipants];
    numUsers = [client currentSessionParticipantCount];
    
    NSLog(@"%@ users currently in chat", currentUsers);
    if (numUsers <= 1)
      iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d User", numUsers]];
    else
      iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d Users", numUsers]];
    [listUsers reloadData];
  });
}

//                    KEYBOARD MOVEMENTS/LOGISTICS
// ---------------------------------------------------------------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  textView.inputAccessoryView = keyboardbuttons;
  return YES;
}
- (void)buildButtons{
  keyboardbuttons = [[UIToolbar alloc] init];
  keyboardbuttons.barStyle = UIBarStyleDefault;
  [keyboardbuttons sizeToFit];
  
  keyboardbuttons.frame = CGRectMake(0,self.view.frame.size.height - 44, self.view.frame.size.width, 44);
  
  //Use this to put space in between your toolbox buttons
  UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithTitle:@"Undo"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:nil];
  UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
  UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(doneButton)];
  UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
  UIBarButtonItem *redoItem = [[UIBarButtonItem alloc] initWithTitle:@"Redo"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:nil];
  
  NSArray *items = [NSArray arrayWithObjects:undoItem, flexItem, doneItem, flexItem2, redoItem, nil];
  [keyboardbuttons setItems:items animated:YES];
}
-(void)doneButton{
  [noteData resignFirstResponder];
}
- (void)notepadSizeDown:(NSNotification*)notification{
  int keyboardHeight = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  [noteData setFrame:CGRectMake(0, 0, noteData.frame.size.width, noteData.frame.size.height - keyboardHeight)];
}

- (void)notepadSizeUp:(NSNotification*)notification{
  int keyboardHeight = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  [noteData setFrame:CGRectMake(0, 0, noteData.frame.size.width, noteData.frame.size.height + keyboardHeight)];
}
// ---------------------------------------------------------------
// ---------------------------------------------------------------


@end
