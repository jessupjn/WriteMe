//
//  CollabrifyParticipant.h
//  CollabrifyProtocolBuffer
//
//  Created by Brandon Knope on 3/14/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/types.h>

extern NSString *const CollabrifyParticipantUpdatingMessage;

/**
 * Represents a user in a session
 */
@interface CollabrifyParticipant : NSObject < NSCopying >

/** A user's participant id. (read-only) */
@property (readonly, assign, nonatomic) int64_t participantID;

/** A user's gmail account. (read-only) */
@property (readonly, copy, nonatomic) NSString *gmail;

/** A user's display name. (read-only) */
@property (readonly, copy, nonatomic) NSString *displayName;

@end
