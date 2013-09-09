//
//  Header.h
//  Collabrify
//
//  Created by Brandon Knope on 3/13/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CollabrifyError;

/** List Accounts Completion Handler */
typedef void (^ListAccountsCompletionHandler)(NSArray *accounts, CollabrifyError *error);
typedef void (^ListSessionsCompletionHandler)(NSArray *sessionList, CollabrifyError *error);

typedef void (^CreateSessionCompletionHandler)(int64_t sessionID, CollabrifyError *error);

/**
 * baseFileSize is 0 if there is no base file
 */
typedef void (^JoinSessionCompletionHandler)(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error);
typedef void (^LeaveSessionCompletionHandler)(BOOL success, CollabrifyError *error);
