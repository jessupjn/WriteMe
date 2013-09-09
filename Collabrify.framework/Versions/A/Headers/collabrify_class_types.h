//
//  collabrify_class_types.h
//  Collabrify
//
//  Created by Brandon Knope on 9/3/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

/**
 * Represents the type of class where an error occurred.
 */
typedef NS_ENUM(NSInteger, CollabrifyClassType)
{
    CollabrifyClassTypeNotSet,
    CollabrifyClassTypeCollabrifyClient,
    CollabrifyClassTypeCreateSession,
    CollabrifyClassTypeCreateSessionWithBaseFile,
    CollabrifyClassTypeAddToBaseFile,
    CollabrifyClassTypeJoinSession,
    CollabrifyClassTypeGetParticipant,
    CollabrifyClassTypeLeaveSession,
    CollabrifyClassTypeEndSession,
    CollabrifyClassTypeGetBaseFileChunk,
    CollabrifyClassTypeAddEvent,
    CollabrifyClassTypeGetEvent,
    CollabrifyClassTypeListSessions,
    CollabrifyClassTypeGetCurrentOrderID,
    CollabrifyClassTypeGetSession,
    CollabrifyClassTypeWarmup
};
