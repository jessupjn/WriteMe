//
//  iPadChat.m
//  EECS441-1
//
//  Created by Jackson on 9/12/13.
//
//

#import "iPadChat.h"

@interface iPadChat () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CollabrifyClientDataSource, CollabrifyClientDelegate>

@end

@implementation iPadChat

@synthesize client;
@synthesize undoManager;

- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistationID eventType:(NSString *)eventType data:(NSData *)data
{
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  if (string)
  {
    dispatch_async(dispatch_get_main_queue(),^{
      [noteData setText:string];
    });
  }
}


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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 0.0;
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
  
  [iPadUsersBar.layer setBorderWidth:1];
  [noteData.layer setBorderWidth:1];
  
  [noteData setDelegate:self];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeUp:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notepadSizeDown:) name:UIKeyboardDidShowNotification object:nil];
  [client setDelegate:self], [client setDataSource:self];
  
  undoManager = [noteData undoManager];
  
  userList = [[UITableView alloc] initWithFrame:CGRectMake(DEVICEWIDTH-225, 138, 225, 886)];
  [userList.layer setBorderWidth:1];
  [userList setDataSource:self], [userList setDelegate:self];
  [self.view addSubview:userList];
  
  placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
  [placeHolder setText:@" Begin typing here..."];
  [placeHolder setTextColor:[UIColor lightGrayColor]];
  [noteData addSubview:placeHolder];

}

-(void)viewWillAppear:(BOOL)animated{
  if( [[noteData text] isEqualToString:@""]){
    if( [noteData hasText]) [placeHolder setHidden:YES];
    else [placeHolder setHidden:NO];
  }
    
  [[self navigationItem] setPrompt:[NSString stringWithFormat:@"Session ID: %lli", [client currentSessionID]]];
  [self buildButtons];
  [self reloadTable];
  keepCount = 0;
  participantsTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
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
}


- (void) onTheClock{
  
  if ( keepCount++ == 12 ) [self reloadTable], keepCount=0;
  
  if ( numUsers == 1 ) {
    NSData* data=[[noteData text] dataUsingEncoding:NSUTF8StringEncoding];
//    [client broadcast:data eventType:@"update"];
  }
  else if ( [addedString length] > 5 ){
    
  }
  
}


- (void) reloadTable{  
    currentUsers = [client currentSessionParticipants];
    numUsers = [client currentSessionParticipantCount];
  
    if (numUsers == 1)
      iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d User", numUsers]];
    else
      iPadUsersTitle = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d Users", numUsers]];
    [iPadBar setTitle:iPadUsersTitle];
    [userList reloadData];

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
                                                              action:@selector(undoButton)];
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
                                                              action:@selector(redoButton)];
  
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
  [userList setFrame:CGRectMake(DEVICEWIDTH-225, 138, userList.frame.size.width, userList.frame.size.height - keyboardHeight)];
}

- (void)notepadSizeUp:(NSNotification*)notification{
  int keyboardHeight = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  [noteData setFrame:CGRectMake(0, 0, noteData.frame.size.width, noteData.frame.size.height + keyboardHeight)];
  [userList setFrame:CGRectMake(DEVICEWIDTH-225, 138, userList.frame.size.width, userList.frame.size.height + keyboardHeight)];
}
// ---------------------------------------------------------------
// ---------------------------------------------------------------

-(void) textViewDidChange:(UITextView *)textView{
  
  if( [noteData hasText] ) [placeHolder setHidden:YES];
  else [placeHolder setHidden:NO];
  
  NSUInteger cursorPosition = textView.selectedRange.location;
  NSLog(@"%i", cursorPosition);

}



@end