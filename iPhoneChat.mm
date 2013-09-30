//
//  iPhoneChatViewController.m
//  EECS441-1
//
//  Created by Jackson on 9/29/13.
//
//

#import "iPhoneChat.h"
#import "eventKind.pb.h"

@interface iPhoneChat () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CollabrifyClientDataSource, CollabrifyClientDelegate>

@property (nonatomic) chalkBoard *theEvent;

@end

@implementation iPhoneChat

@synthesize client;
@synthesize listUsers;
@synthesize theEvent;



// UPDATES THE TEXT IF THE CLIENT DETECTS AN EVENT
- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistationID eventType:(NSString *)eventType data:(NSData *)data
{
  chalkBoard *newEvent = new chalkBoard;
  newEvent->ParseFromArray([data bytes], [data length]);
  std::string string = newEvent->changes();
  NSString *objcString = [NSString stringWithCString:string.c_str() encoding:[NSString defaultCStringEncoding]];
  int loc = newEvent->where();
  
  if ( loc > [noteData.text length] ) loc = [noteData.text length] - 1;
  if ( ![list count] || [[list objectAtIndex:0] intValue] != submissionRegistationID ) {
    dispatch_async(dispatch_get_main_queue(),^{
      
      // delete key was pressed.
      if ( [objcString isEqualToString:@"backPressed"] ) {
        NSLog(@"Delete Was Pressed");
        
        return;
      }
      // another key was pressed
      else {
        [noteData setScrollEnabled:NO];
        NSLog(@"%i %@", loc, objcString);
        NSString *firstHalf = [noteData.text substringToIndex:loc];
        NSString *secondHalf = [noteData.text substringFromIndex:loc];
        [noteData setText:[NSString stringWithFormat:@"%@%@%@", firstHalf, objcString, secondHalf]];
        [noteData setScrollEnabled:YES];
        return;
      }
    });
  }
  else {
    [list removeObjectAtIndex:0];
    NSLog(@"Detected your event");
    return;
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
//------------------------------------------------------
//------------------------------------------------------




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
  
  addedString = [[NSMutableString alloc] init];
  keepCount = formerSize = 0;
  
  participantsTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                       target:self
                                                     selector:@selector(onTheClock)
                                                     userInfo:nil
                                                      repeats:YES];
  theEvent = new chalkBoard;
  list = [[NSMutableArray alloc] init];
  
}

-(void)viewWillAppear:(BOOL)animated{
  
  [[self navigationItem] setPrompt:[NSString stringWithFormat:@"Session ID: %lli", [client currentSessionID]]];
  [self buildButtons];
  [self reloadTable];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(doneButton)];
  [[self view] addGestureRecognizer:tap];
  
  [noteData.undoManager setGroupsByEvent:NO];
  [noteData.undoManager beginUndoGrouping];
  [noteData.undoManager endUndoGrouping];
  [noteData.undoManager beginUndoGrouping];
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

// function called by the timer
- (void) onTheClock{
  
  if ( keepCount++ == 12 ) [self reloadTable], keepCount=0;
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
  
  keyboardbuttons.frame = CGRectMake(0, DEVICEHEIGHT-44, DEVICEWIDTH, 44);
  
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
// undo button
-(void)undoButton{
  if( [noteData.undoManager canUndo] )
    [noteData.undoManager endUndoGrouping], [noteData.undoManager undoNestedGroup];
  else NSLog(@"CANT UNDO");
}
// done button
-(void)doneButton{
  [noteData resignFirstResponder];
}
// redo button
-(void)redoButton{
  if( [noteData.undoManager canRedo] && ![noteData.undoManager isUndoing] )
    [noteData.undoManager endUndoGrouping], [noteData.undoManager redo];
  else NSLog(@"CANT REDO");
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


// --------------------------------------------------------------- //
// -                    KEEP TRACK OF CHANGES                    - //
// --------------------------------------------------------------- //
-(void) textViewDidChange:(UITextView *)textView{
  
  if ( [noteData.text length]%10 == 0 ) [noteData.undoManager beginUndoGrouping];
  
  
  // current position of the cursor
  NSUInteger cursorPosition = textView.selectedRange.location;
  // Defines the start position of the string to be added into the DATA!
  
  // Defines the string to be added to the text of all users
  NSData* data;
  NSRange range = NSMakeRange(cursorPosition-1, 1);
  addedString = [NSMutableString stringWithString:[noteData.text substringWithRange:range]];
  
  // delete key was pressed
  if ( formerSize > [noteData.text length] )
    addedString = [NSMutableString stringWithFormat:@"backPressed"];
  
    theEvent->set_changes( [addedString UTF8String] );
    theEvent->set_where( noteData.selectedRange.location - 1);
  
    std::string dataData = theEvent->SerializeAsString();
    data = [NSData dataWithBytes:dataData.c_str() length:dataData.size()];
  int eventId = [client broadcast:data eventType:@"update"];
  [list addObject:[NSString stringWithFormat:@"%i", eventId]];
  formerSize = [noteData.text length];
}

@end
