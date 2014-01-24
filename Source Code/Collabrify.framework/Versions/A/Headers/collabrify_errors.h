//
//  collabrify_errors.h
//  Collabrify
//
//  Created by Brandon Knope on 8/9/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * Represents server errors. Use CollabrifyErrorType.
 * @see CollabrifyErrorType
 */
typedef NS_ENUM(NSInteger, CollabrifyServerErrorType)
{
    CollabrifyErrorType_NOT_SET = 0,
    CollabrifyErrorType_GENERAL_ERROR = 1,
    CollabrifyErrorType_IO_EXCEPTION = 2,
    CollabrifyErrorType_INVALID_PROTOCOL_BUFFER_EXCEPTION = 3,
    CollabrifyErrorType_NOT_IMPLEMENTED_YET = 4,
    CollabrifyErrorType_OPERATION_NOT_PERMITTED = 5,
    CollabrifyErrorType_INVALID_SETTINGS_FOR_OPERATION = 6,
    CollabrifyErrorType_CLIENT_SIDE_ERROR = 7,
    CollabrifyErrorType_SERVER_SIDE_ERROR = 8,
    // ----------
    CollabrifyErrorType_ACCOUNT_ALREADY_EXISTS = 10,
    CollabrifyErrorType_ACCOUNT_PASSWORD_MISSING = 11,
    CollabrifyErrorType_ACCOUNT_GMAIL_MISSING = 12,
    CollabrifyErrorType_ACCOUNT_NAME_MISSING = 13,
    CollabrifyErrorType_ACCOUNT_REF_MISSING = 14,
    CollabrifyErrorType_ACCOUNT_ACCESS_TOKEN_MISSING = 15,
    CollabrifyErrorType_INVALID_ACCOUNT_GMAIL = 16,
    CollabrifyErrorType_INVALID_ACCESS_TOKEN = 17,
    CollabrifyErrorType_INVALID_ACCOUNT_GMAIL_OR_ACCESS_TOKEN = 18,
    CollabrifyErrorType_INVALID_ACCOUNT_GMAIL_OR_PASSWORD = 19,
    // ----------
    CollabrifyErrorType_SESSION_ALREADY_EXISTS = 20,
    CollabrifyErrorType_SESSION_ID_MISSING = 21,
    CollabrifyErrorType_SESSION_NAME_MISSING = 22,
    CollabrifyErrorType_SESSION_PASSWORD_MISSING = 23,
    CollabrifyErrorType_SESSION_REF_MISSING = 24,
    CollabrifyErrorType_INVALID_SESSION_ID = 25,
    CollabrifyErrorType_INVALID_SESSION_KEY = 26,
    CollabrifyErrorType_INVALID_SESSION_PASSWORD = 27,
    CollabrifyErrorType_INVALID_SESSION_ID_OR_PASSWORD = 28,
    CollabrifyErrorType_SESSION_TAGS_MISSING = 29,
    CollabrifyErrorType_TOO_MANY_SESSION_TAGS = 30,
    CollabrifyErrorType_TOO_FEW_SESSION_TAGS = 31,
    CollabrifyErrorType_SESSION_TAG_IS_NULL_OR_EMPTY = 32,
    // ----------
    CollabrifyErrorType_INVALID_BASE_FILE_KEY = 40,
    CollabrifyErrorType_BASE_FILE_DATA_MISSING = 41,
    CollabrifyErrorType_BASE_FILE_DATA_TOO_LARGE = 42,
    CollabrifyErrorType_NO_BASE_FILE_FOR_SESSION = 43,
    CollabrifyErrorType_BASE_FILE_NOT_COMPLETE_YET = 44,
    CollabrifyErrorType_BASE_FILE_ALREADY_COMPLETE = 45,
    CollabrifyErrorType_FILE_REF_IS_MISSING = 50,
    CollabrifyErrorType_BYTE_DATA_IS_MISSING = 51,
    CollabrifyErrorType_BYTE_DATA_TOO_LARGE = 52,
    CollabrifyErrorType_BYTE_DATA_TOO_LARGE_FOR_REQUEST = 53,
    CollabrifyErrorType_BYTE_DATA_TOO_LARGE_FOR_RESPONSE = 54,
    CollabrifyErrorType_INVALID_START_POSITION_OR_LENGTH = 55,
    
    // ----------
    CollabrifyErrorType_OWNER_GMAIL_MISSING = 70,
    CollabrifyErrorType_OWNER_DISPLAY_NAME_MISSING = 71,
    CollabrifyErrorType_OWNER_NOTIFICATION_ID_MISSING = 72,
    CollabrifyErrorType_OWNER_NOTIFICATION_TYPE_MISSING = 73,
    CollabrifyErrorType_OWNER_REF_MISSING = 74,
    CollabrifyErrorType_OWNER_PARTICIPANT_ID_IS_ZERO = 75,
    // ----------
    CollabrifyErrorType_PARTICIPANT_GMAIL_MISSING = 80,
    CollabrifyErrorType_PARTICIPANT_DISPLAY_NAME_MISSING = 81,
    CollabrifyErrorType_PARTICIPANT_NOTIFICATION_ID_MISSING = 82,
    CollabrifyErrorType_PARTICIPANT_NOTIFICATION_TYPE_MISSING = 83,
    CollabrifyErrorType_PARTICIPANT_REF_MISSING = 84,
    CollabrifyErrorType_PARTICIPANT_ID_IS_ZERO = 85,
    // ----------
    CollabrifyErrorType_PARTICIPANT_NOT_IN_SESSION = 86,
    CollabrifyErrorType_PARTICIPANT_ALREADY_IN_SESSION = 87,
    
    // ----------
    CollabrifyErrorType_INVALID_ORDER_ID = 100,
    CollabrifyErrorType_NO_EVENT_WITH_ORDER_ID = 101,
    CollabrifyErrorType_EVENT_DATA_MISSING = 102,
    CollabrifyErrorType_EVENT_DATA_TOO_LARGE = 103,
};


