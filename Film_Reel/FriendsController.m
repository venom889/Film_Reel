//
//  FriendsController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "FriendsController.h"

@interface FriendsController ()

@end

@implementation FriendsController

@synthesize friendsTable;
@synthesize tableArray;
@synthesize friendRequest;
@synthesize loading;
@synthesize addfriendalert;

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
    tableArray = [[NSMutableArray alloc] init];
    [tableArray addObject:@"Person"];
    
    friendRequest = [[Networking alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@"AddressFailed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@"FailStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@"INVITE_SENT" object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doAddFriend:(id)sender
{
    addfriendalert = [[UIAlertView alloc] initWithTitle:@"Add a Friend" message:@"Enter a username to add: " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    addfriendalert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addfriendalert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSLog(@"%@", [addfriendalert textFieldAtIndex:0].text);
        NSString* req = [self buildAddRequest:[addfriendalert textFieldAtIndex:0].text];
        loading = [[UIAlertView alloc] initWithTitle:nil message:@"Sending request..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [friendRequest startReceive:req withType:@ADD_REQUEST];
        
        if([friendRequest isReceiving])
        {
            [loading show];
        }
        
        
        [tableArray addObject:([addfriendalert textFieldAtIndex:0].text)];
        [self.friendsTable reloadData];
    }
}

// Handles Succussful acount creation
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@"INVITE_SENT"])
    {
        NSLog(@"YAYAYAYAYA!!! It worked\n");
        [loading setMessage:@"Request Sent"];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        [self.friendsTable reloadData];
    }
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@"AddressFailed"])
    {
        NSLog(@"Wrong Address\n");
        
        [loading setMessage:@ADDRESS_FAIL_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@"FailStatus"])
    {
        NSLog(@"Failed to connect\n");
        [loading setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
}

// Dismiss dialogs when done
-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildAddRequest: (NSString*) name
{
    NSMutableString* add = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [add appendString:@"add?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"name=%@" , name];
    
    [add appendString:parameter1];
    
    NSLog(@"Add friend request:: %@", add);
    
    return add;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView.opaque = NO;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.opaque = NO;
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:128 blue:225 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        
        cell.accessoryView=UITableViewCellAccessoryNone;
        
    }
    
    // Set up the cell...
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
