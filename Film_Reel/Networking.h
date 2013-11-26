//
//  UserXMLParser.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "User.h"

#define SERVER_ADDRESS "http://192.168.1.25:8080/filmreel/"

#define LOGIN_REQUEST "Login"
#define FETCH_REQUEST "Fetch"
#define UPDATE_REQUEST "Update"
#define SIGNUP_REQUEST "Signup"
#define REEL_SEND "Reel_Request"

#define ADDRESS_FAIL_ERROR "Server or request address was incorrect"
#define SERVER_CONNECT_ERROR "Failed to connect to the server"

@interface Networking : NSObject <NSXMLParserDelegate>

@property(nonatomic, strong, readwrite) NSURLConnection * connection;
@property(nonatomic, strong) NSMutableData * data;
@property(nonatomic, strong) NSXMLParser* parser;
@property(nonatomic, strong) NSString* requestType;
@property(nonatomic, strong) User* userObject;
@property(nonatomic, strong) NSMutableString* currentObject;
@property(nonatomic, strong) NSMutableDictionary *dataReceived;

- (void) startReceive: (NSString*) defaultURL withType: (NSString*) typeOfRequest;
- (BOOL)isReceiving;
- (void) receiveDidStart;
- (void) receiveDidStopWithStatus: (NSString *) status;
- (void)stopReceiveWithStatus:(NSString *)statusString;

//delegate methods
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData;



@end
