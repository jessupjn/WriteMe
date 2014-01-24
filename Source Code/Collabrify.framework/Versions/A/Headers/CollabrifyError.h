//
//  CollabrifyError.h
//  Collabrify
//
//  Created by Brandon Knope on 8/9/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/collabrify_errors.h>
#import <Collabrify/collabrify_class_types.h>

//Error domains for Collabrify
extern NSString *const CollabrifyNetworkConnectionErrorDomain;
extern NSString *const CollabrifyServerSideErrorDomain;
extern NSString *const CollabrifyClientSideErrorDomain;
extern NSString *const CollabrifyBackgroundServicesErrorDomain;

extern NSString *const CollabrifySubmissionRegistrationIDKey;
extern NSString *const CollabrifyDataKey;

/** A type that indicates what kind of error occurred. */
typedef NS_ENUM(NSInteger, CollabrifyErrorType)
{
    CollabrifyServerSideErrorNotSet = CollabrifyErrorType_NOT_SET,
    CollabrifyServerSideErrorGeneralError = CollabrifyErrorType_GENERAL_ERROR,
    CollabrifyServerSideErrorIOException = CollabrifyErrorType_IO_EXCEPTION,
    CollabrifyServerSideErrorInvalidProtocolBufferException = CollabrifyErrorType_INVALID_PROTOCOL_BUFFER_EXCEPTION,
    CollabrifyServerSideErrorNotImplementedYet = CollabrifyErrorType_NOT_IMPLEMENTED_YET,
    CollabrifyServerSideErrorOperationNotPermitted = CollabrifyErrorType_OPERATION_NOT_PERMITTED,
    CollabrifyServerSideErrorInvalidSettingsForOperation = CollabrifyErrorType_INVALID_SETTINGS_FOR_OPERATION,
    CollabrifyServerSideErrorClientSideError = CollabrifyErrorType_CLIENT_SIDE_ERROR,
    CollabrifyServerSideErrorServerSideError = CollabrifyErrorType_SERVER_SIDE_ERROR,
    //
    CollabrifyServerSideErrorAccountAlreadyExists = CollabrifyErrorType_ACCOUNT_ALREADY_EXISTS,
    CollabrifyServerSideErrorAccountPasswordMissing = CollabrifyErrorType_ACCOUNT_PASSWORD_MISSING,
    CollabrifyServerSideErrorAccountGmailMissing = CollabrifyErrorType_ACCOUNT_GMAIL_MISSING,
    CollabrifyServerSideErrorAccountNameMissing = CollabrifyErrorType_ACCOUNT_NAME_MISSING,
    CollabrifyServerSideErrorAccountReferenceMissing = CollabrifyErrorType_ACCOUNT_REF_MISSING,
    CollabrifyServerSideErrorInvalidAccountGmail = CollabrifyErrorType_INVALID_ACCOUNT_GMAIL,
    CollabrifyServerSideErrorInvalidAccessToken = CollabrifyErrorType_INVALID_ACCESS_TOKEN,
    CollabrifyServerSideErrorInvalidAccountGmailOrAccessToken = CollabrifyErrorType_INVALID_ACCOUNT_GMAIL_OR_ACCESS_TOKEN,
    CollabrifyServerSideErrorInvalidAccountGmailOrPassword = CollabrifyErrorType_INVALID_ACCOUNT_GMAIL_OR_PASSWORD,
    //
    CollabrifyServerSideErrorSessionAlreadyExists = CollabrifyErrorType_SESSION_ALREADY_EXISTS,
    CollabrifyServerSideErrorSessionIDMissing = CollabrifyErrorType_SESSION_ID_MISSING,
    CollabrifyServerSideErrorSessionNameMissing = CollabrifyErrorType_SESSION_NAME_MISSING,
    CollabrifyServerSideErrorSessionPasswordMissing = CollabrifyErrorType_SESSION_PASSWORD_MISSING,
    CollabrifyServerSideErrorSessionReferenceMissing = CollabrifyErrorType_SESSION_REF_MISSING,
    CollabrifyServerSideErrorInvalidSessionID = CollabrifyErrorType_INVALID_SESSION_ID,
    CollabrifyServerSideErrorInvalidSessionKey = CollabrifyErrorType_INVALID_SESSION_KEY,
    CollabrifyServerSideErrorInvalidSessionPassword = CollabrifyErrorType_INVALID_SESSION_PASSWORD,
    CollabrifyServerSideErrorInvalidSessionIDOrPasswrd = CollabrifyErrorType_INVALID_SESSION_ID_OR_PASSWORD,
    CollabrifyServerSideErrorSessionTagsMissing = CollabrifyErrorType_SESSION_TAGS_MISSING,
    CollabrifyServerSideErrorTooManySessionTags = CollabrifyErrorType_TOO_MANY_SESSION_TAGS,
    CollabrifyServerSideErrorTooFewSessionTags = CollabrifyErrorType_TOO_FEW_SESSION_TAGS,
    CollabrifyServerSideErrorSessionTagIsNilOrEmpty = CollabrifyErrorType_SESSION_TAG_IS_NULL_OR_EMPTY,
    //
    CollabrifyServerSideErrorInvalidBaseFileKey = CollabrifyErrorType_INVALID_BASE_FILE_KEY,
    CollabrifyServerSideErrorBaseFileDataMissing = CollabrifyErrorType_BASE_FILE_DATA_MISSING,
    CollabrifyServerSideErrorBaseFileDataTooLarge = CollabrifyErrorType_BASE_FILE_DATA_TOO_LARGE,
    CollabrifyServerSideErrorNoBaseFileForSession = CollabrifyErrorType_NO_BASE_FILE_FOR_SESSION,
    CollabrifyServerSideErrorBaseFileNotCompleteYet = CollabrifyErrorType_BASE_FILE_NOT_COMPLETE_YET,
    CollabrifyServerSideErrorBaseFileAlreadyComplete = CollabrifyErrorType_BASE_FILE_ALREADY_COMPLETE,
    CollabrifyServerSideErrorFileReferenceIsMissing = CollabrifyErrorType_FILE_REF_IS_MISSING,
    CollabrifyServerSideErrorByeDataIsMissing = CollabrifyErrorType_BYTE_DATA_IS_MISSING,
    CollabrifyServerSideErrorByteDataTooLarge = CollabrifyErrorType_BYTE_DATA_TOO_LARGE,
    CollabrifyServerSideErrorByteDataTooLargeForRequest = CollabrifyErrorType_BYTE_DATA_TOO_LARGE_FOR_REQUEST,
    CollabrifyServerSideErrorByteDataTooLargeForResponse = CollabrifyErrorType_BYTE_DATA_TOO_LARGE_FOR_RESPONSE,
    CollabrifyServerSideErrorInvalidStartPositionOrLength = CollabrifyErrorType_INVALID_START_POSITION_OR_LENGTH,
    //
    CollabrifyServerSideErrorOwnerGmailMissing = CollabrifyErrorType_OWNER_GMAIL_MISSING,
    CollabrifyServerSideErrorOwnerDisplayNameMissing = CollabrifyErrorType_OWNER_DISPLAY_NAME_MISSING,
    CollabrifyServerSideErrorOwnerNotificationIDMissing = CollabrifyErrorType_OWNER_NOTIFICATION_ID_MISSING,
    CollabrifyServerSideErrorOwnerNotificationTypeMissing = CollabrifyErrorType_OWNER_NOTIFICATION_TYPE_MISSING,
    CollabrifyServerSideErrorOwnerReferenceMissing = CollabrifyErrorType_OWNER_REF_MISSING,
    CollabrifyServerSideErrorOwnerParticipantIDIsZero = CollabrifyErrorType_OWNER_PARTICIPANT_ID_IS_ZERO,
    //
    CollabrifyServerSideErrorParticipantGmailMissing = CollabrifyErrorType_PARTICIPANT_GMAIL_MISSING,
    CollabrifyServerSideErrorParticipantDisplayNameMissing = CollabrifyErrorType_PARTICIPANT_DISPLAY_NAME_MISSING,
    CollabrifyServerSideErrorParticipantNotificationIDMissing = CollabrifyErrorType_PARTICIPANT_NOTIFICATION_ID_MISSING,
    CollabrifyServerSideErrorParticipantNotificationTypeMissing = CollabrifyErrorType_PARTICIPANT_NOTIFICATION_TYPE_MISSING,
    CollabrifyServerSideErrorParticipantReferenceMissing = CollabrifyErrorType_PARTICIPANT_REF_MISSING,
    CollabrifyServerSideErrorParticipantIDIsZero = CollabrifyErrorType_PARTICIPANT_ID_IS_ZERO,    
    CollabrifyServerSideErrorParticipantNotInSession = CollabrifyErrorType_PARTICIPANT_NOT_IN_SESSION,
    CollabrifyServerSideErrorParticipantAlreadyInSession = CollabrifyErrorType_PARTICIPANT_ALREADY_IN_SESSION,
    //
    CollabrifyServerSideErrorInvalidOrderID = CollabrifyErrorType_INVALID_ORDER_ID,
    CollabrifyServerSideErrorNoEventWithOrderID = CollabrifyErrorType_NO_EVENT_WITH_ORDER_ID,
    CollabrifyServerSideErrorEventDataMissing = CollabrifyErrorType_EVENT_DATA_MISSING,
    CollabrifyServerSideErrorEventDataTooLarge = CollabrifyErrorType_EVENT_DATA_TOO_LARGE,
    //
    CollabrifyClientSideErrorNoNetworkConnection = 200,
    CollabrifyClientSideErrorAlreadyConnectedToASession,
    CollabrifyClientSideErrorNotConnectedToAnySession,
    CollabrifyClientSideErrorCurrentSessionHasEnded,
    CollabrifyClientSideErrorAlreadyPendingSessionAction,
    //
    CollabrifyNetworkConnectionErrorNoNetworkConnectionOrServerNotReachable,
    //
    CollabrifyBackgroundServicesErrorUnknownErrorOccured,
    CollabrifyBackgroundServicesErrorBackgroundingDisabled,
};


/*
 * A base class object for an error.
 * @see CollabrifyErrorRecoverable, CollabrifyErrorUnrecoverable
 */
@interface CollabrifyError : NSObject

/** The class type where the error happened. (read-only) */
@property (readonly, assign, nonatomic) CollabrifyClassType classType;

/** A dictionary containing useful information about the error */
@property (readonly, copy, nonatomic) NSDictionary *userInfo;

/**  
 * The type of error that occured.
 * @return The type of error that has occurred.
 * @see CollabrifyErrorType
 */
- (CollabrifyErrorType)type;

/**
 * The domain where the error has occurred 
 * @return The domain where the error has occurred.
 */
- (NSString *)domain;

/*
 * A description of the error that has occurred.
 * @return A string describing the error that has occurred.
 */
- (NSString *)localizedDescription;

+ (id)errorWithDomain:(NSString *)errorDomain type:(CollabrifyErrorType)type;
+ (id)errorWithDomain:(NSString *)errorDomain type:(CollabrifyErrorType)type userInfo:(NSDictionary *)userInfo;

@end

/** Represents an error that the client can recover from */
@interface CollabrifyRecoverableError : CollabrifyError

@end

/** Represents an error that the client cannot recover from */
@interface CollabrifyUnrecoverableError : CollabrifyError

@end


