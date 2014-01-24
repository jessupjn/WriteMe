//
//  CollabrifySession.h
//  CollabrifyProtocolBuffer
//
//  Created by Brandon Knope on 3/14/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CollabrifyParticipant;
@class CollabrifySessionInformation;

/**
 * An object representing a session. When listing sessions,
 * some of these fields will be nil.
 */
@interface CollabrifySession : NSObject

/** The session id. (read-only) */
@property (readonly, assign, nonatomic) int64_t sessionID;

/** The session name. (read-only) */
@property (readonly, copy, nonatomic) NSString *sessionName;

/** Indicates if the session is password protected. (read-only) */
@property (readonly, assign, getter = isPasswordProtected, nonatomic) BOOL passwordProtected;

/** The owner's participant id. (read-only) */
@property (readonly, assign, nonatomic) int64_t ownerID;

/** An array of participant ids that are currently in this session. (read-only) */
@property (readonly, strong, nonatomic) NSArray *participantIDs;

/** The session's current order id. (read-only) */
@property (readonly, assign, nonatomic) int64_t currentOrderID;

/** Indicates whether the session has a base file. (read-only) */
@property (readonly, assign, nonatomic) BOOL hasBaseFile;

/** The session's base file size. (read-only) */
@property (readonly, assign, nonatomic) NSInteger baseFileSize;

/** Indicates whether the session has ended. (read-only) */
@property (readonly, assign, getter = sessionHasEnded, nonatomic) BOOL sessionEnded;

/** The number of participants that can be in the session. 0 indicates no limit. (read-only) */
@property (readonly, assign, nonatomic) NSInteger participantLimit;

/** The number of participants in this session. (read-only) */
@property (readonly, assign, nonatomic) NSUInteger participantCount;

/** The tags representing this session. (read-only) */
@property (readonly, copy, nonatomic) NSArray *tags;

// These are nil when listing sessions, use ownerID and participantIDs when listing

/** 
 * Returns the session owner. This returns nil when getting a session from listSessions. (read-only)
 * @see CollabrifyParticipant
 */
@property (readonly, strong, nonatomic) CollabrifyParticipant *owner;

/** Returns an array of CollabrifyParticipants. Returns nil when getting a session from listSessions. (read-only) */
@property (readonly, copy, nonatomic) NSArray *participants;

@end
