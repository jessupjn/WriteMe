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
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
  [usersToggle setTitle:@"Show Users"];
  [noteData setFrame:CGRectMake(0, 94, 320, 474)];
  [noteData setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
  
  showUsersBackground = [[UIView alloc] initWithFrame:CGRectMake(320, 94, 320, 474)];
  [showUsersBackground setBackgroundColor:[UIColor blackColor]];
  [showUsersBackground setAlpha:0.7];
  listUsers = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 474)];
  [listUsers setCenter:[showUsersBackground center]];
  [[self view] addSubview:showUsersBackground];
  [[self view] addSubview:listUsers];
  
  [listUsers.layer setBorderWidth:1];
  [noteData.layer setBorderWidth:1];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeUp:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeDown:) name:UIKeyboardDidShowNotification object:nil];
  [listUsers setDelegate:self];
  [listUsers setDataSource:self];
  [client setDelegate:self];
  [client setDataSource:self];
  [noteData setDelegate:self];
  
  placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
  [placeHolder setText:@" Begin typing here..."];
  [placeHolder setTextColor:[UIColor lightGrayColor]];
  [noteData addSubview:placeHolder];
}

-(void)viewWillAppear:(BOOL)animated{
  if( [noteData hasText]) [placeHolder setHidden:YES];
  else [placeHolder setHidden:NO];
  
  [[self navigationItem] setPrompt:[NSString stringWithFormat:@"Session ID: %lli", [client currentSessionID]]];
  [self buildButtons];
  [self reloadTable];
  keepCount = 0;
  participantsTimer = [NSTimer scheduledTimerWithTimeInterval:0.20
                                                       target:self
                                                     selector:@selector(onTheClock)
                                                     userInfo:nil
                                                      repeats:YES];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(doneButton)];
  [[self view] addGestureRecognizer:tap];
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
    [self reloadTable];

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


- (void) onTheClock{
  
  if ( keepCount++ == 12 ) [self reloadTable], keepCount=0;
  
  if ( numUsers == 1 ) {
//    NSData* data=[[noteData text] dataUsingEncoding:NSUTF8StringEncoding];
//    [client broadcast:data eventType:@"update"];
  }
  else;
  
  
}

- (void) reloadTable{
  currentUsers = [client currentSessionParticipants];
  numUsers = [client currentSessionParticipantCount];
  
  if (numUsers == 1)
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d User", numUsers]];
  else
    iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d Users", numUsers]];
  [listUsers reloadData];
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
-(void)undoButton{
  [noteData.undoManager undo];
}
-(void)doneButton{
  [noteData resignFirstResponder];
}
-(void)redoButton{
  [noteData.undoManager redo];
}
- (void)notepadSizeDown:(NSNotification*)notification{
  int keyboardHeight = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  [noteData setFrame:CGRectMake(0, 0, noteData.frame.size.width, noteData.frame.size.height - keyboardHeight)];
  [listUsers setFrame:CGRectMake(listUsers.frame.origin.x, listUsers.frame.origin.y, listUsers.frame.size.width, listUsers.frame.size.height - keyboardHeight)];
}
- (void)notepadSizeUp:(NSNotification*)notification{
  int keyboardHeight = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  [noteData setFrame:CGRectMake(0, 0, noteData.frame.size.width, noteData.frame.size.height + keyboardHeight)];
  [listUsers setFrame:CGRectMake(listUsers.frame.origin.x, listUsers.frame.origin.y, listUsers.frame.size.width, listUsers.frame.size.height + keyboardHeight)];
}
// ---------------------------------------------------------------
// ---------------------------------------------------------------


@end
