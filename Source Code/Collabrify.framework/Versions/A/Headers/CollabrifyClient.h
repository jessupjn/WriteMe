//
//  CollabrifyClient.h
//  Collabrify
//
//  Created by Brandon Knope on 3/5/13.
//  Copyright (c) 2013 IMLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//Used when creating a session. Pass NSNumber indicating a limit (default 0)
extern NSString *const CollabrifyOptionsParticipantLimitKey;

//Collabrify Network Reachability
typedef NS_ENUM(NSInteger, CollabrifyClientNetworkStatus)
{
    CollabrifyClientNetworkNotReachable,
    CollabrifyClientNetworkReachableViaWiFi,
    CollabrifyClientNetworkReachableViaWWAN
};
extern NSString *const CollabrifyClientNetworkReachabilityChangedNotification;
extern NSString *const CollabrifyClientNetworkStatusKey; //NSNumber representing CollabrifyClientNetworkStatus

@class CollabrifyError;
@class CollabrifyClient;
@class CollabrifySession;
@class CollabrifyParticipant;

/**
 * The client delegate methods. Your application should implement these methods after setting
 * an appropriate class as the delegate.
 */
@protocol CollabrifyClientDelegate <NSObject>

@optional

/**
 * Receive data from the session along with its orderID. Decode the data in an app-specific way
 *
 * @param client The client informing the delegate that it has received an event.
 * @param orderID The orderID of the event.
 * @param submissionRegistrationID The submission registration id of the event if the event originated from the client. If the event 
 * originated on a remote client, this parameter will be -1.
 * @param eventType A string representing the type of the event. May be nil if the type is not set.
 * @param data The data representing the event.
 * @discussion CollabrifyClientReceivedEventNotification is posted with CollabrifyClientOrderIDKey and CollabrifyClientEventDataKey.
 *
 * If the incoming event did not originate from this client, submissionRegistrationID will be -1
 *
 * @warning This method is not called on the main thread. Any UI interaction needs to be done on the main thread
 */
- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data;

/**
 * Called when the a chunk of base file is received or when all of the chunks have been received.
 * When all data has been received, data is nil.
 *
 * @param client The client informing the delegate that it has received a base file chunk.
 * @param data The base file chunk in data form.
 * @warning This method is not called on the main thread.
 */
- (void)client:(CollabrifyClient *)client receivedBaseFileChunk:(NSData *)data;

/**
 * Received upon successfully uploading a chunk of the base file
 *
 * @param client The client informing the delegate that the base file has been uploaded.
 * @param baseFileSize The size of the completed base file.
 * @discussion CollabrifyClientUploadedBaseFileNotification is posted with CollabrifyClientBaseFileSizeKey.
 * @warning This method is called on the main thread.
 */
- (void)client:(CollabrifyClient *)client uploadedBaseFileWithSize:(NSInteger)baseFileSize;

/**
 * Called when the session has been ended by its owner. You may still receive events, but you cannot broadcast.
 * Once you leave, you will be unable to rejoin the session.
 *
 * @param client The client informing the delegate that the session has ended.
 * @param sessionID The session id of the just ended session
 * @discussion CollabrifyClientSessionEnded notification is posted with CollabrifyClientSessionIDKey.
 * @warning Called on the main thread.
 */
- (void)client:(CollabrifyClient *)client endedSession:(int64_t)sessionID;

/**
 * Called when a participant has joined the session
 *
 * @param client The client informing the delegate that a participant has joined.
 * @param participant The participant that has just joined session.
 * @discussion CollabrifyClientParticipantJoinedNotification is posted with CollabrifyClientParticipantKey.
 * @warning Called on the main thread
 * @see CollabrifyParticipant
 */
- (void)client:(CollabrifyClient *)client participantJoined:(CollabrifyParticipant *)participant;

/**
 * Called when a participant has left the session
 *
 * @param client The client informing the delegate that a participant has left.
 * @param participant The participant that has just left the session.
 * @discussion CollabrifyClientParticipantLeftNotification is posted with CollabrifyClientParticipantKey.
 * @warning Called on the main thread
 * @see CollabrifyParticipant
 */
- (void)client:(CollabrifyClient *)client participantLeft:(CollabrifyParticipant *)participant;

/**
 * Pull the NSLocalizedDescriptionKey from the error's userInfo to understand the error.
 * Check CollabrifyError.h for domains and specific error codes
 *
 * @param client The client informing an object that an error occurred.
 * @param error An error object if an error occurrs. Otherwise this is nil. 
 * @discussion CollabrifyClientEncounteredErrorNotification is posted with CollabrifyClientErrorKey.
 * @warning Always called on the main thread.
 * @see CollabrifyError
 */
- (void)client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error;

/**
 * Use Background Service methods from below here. 
 * Always called after the AppDelegate methods and before the client has handled them
 *
 * @param client The client informing the delegate that it has entered the background.
 * @warning This is experimental and may cause strange behavior.
 */
- (void)clientDidEnterBackground:(CollabrifyClient *)client;

@end

/** 
 * A protocol that requests base file chunks from a data source for the client
 */
@protocol CollabrifyClientDataSource <NSObject>

@optional

/**
 * Return the data offset by baseFilSize or nil if the size matches your base file's size
 *
 * @param client The client requesting the data source for a base file chunk.
 * @param baseFileSize The current size of the base file that has been uploaded
 * @return The base file chunk that the data source wants uploaded.
 * @warning Never returning nil from this method can result in an invite loop of uploading data and 
 * receiving a request to continue uploading.
 * @warning Data is not requested on the main thread.
 */
- (NSData *)client:(CollabrifyClient *)client requestsBaseFileChunkForCurrentBaseFileSize:(NSInteger)baseFileSize;

@end

/** The main class to interact with the Collabrify service. Used to manage sessions */
@interface CollabrifyClient : NSObject

/** The delegate that the client should inform of important events */
@property (weak, nonatomic) id<CollabrifyClientDelegate> delegate;
/** The data source that the client requests base file data from */
@property (weak, nonatomic) id<CollabrifyClientDataSource> dataSource;

/** The gmail of the user. (read-only) */
@property (readonly, copy, nonatomic) NSString *gmail;
/** The display name of the user. (read-only) */
@property (readonly, copy, nonatomic) NSString *displayName;
/** The account gmail of the user. (read-only) */
@property (readonly, copy, nonatomic) NSString *accountGmail;

/** The participantID of this user. Value is -1 if not in a session. (read-only) */
@property (readonly, assign, nonatomic) int64_t participantID;

/** Indicates whether events are currently paused. (read-only) */
@property (readonly, assign, nonatomic) BOOL eventsArePaused;

/** The number of events that are currently being paused. (read-only) */
@property (readonly, assign, nonatomic) NSUInteger numberOfPendingEvents;

/**
 * Pauses the client from sending events to its delegate
 * Does not stop an event that is in the middle of being processed.
 */
- (void)pauseEvents;

/**
 * Resumes the client in sending events to its delegate
 */
- (void)resumeEvents;

/**
 * Get the current client network status
 */
- (CollabrifyClientNetworkStatus)currentNetworkStatus;

/**
 * Initializes the client. The client cannot be used if this method is not called.
 * @param gmail The gmail of the user.
 * @param displayName The display name of the user.
 * @param accountGmail The account gmail of the user. Needs to be valid.
 * @param accessToken The access token of the user. Needs to be valid.
 * @param getLatestEvent Determines whether to always receive the latest event. Useful for when joining a session that may
 * have many events.
 * @param error An error object passed by reference, indicating if an error has occurred.
 * @return Returns an initialized client object.
 */
- (id)initWithGmail:(NSString *)gmail displayName:(NSString *)displayName accountGmail:(NSString *)accountGmail accessToken:(NSString *)accessToken getLatestEvent:(BOOL)getLatestEvent error:(NSError **)error;

/**
 * Create a session without a base file and no participant limit.
 *
 * @param sessionName The name of the session being created. Needs to be unique.
 * @param tags The tags that represent the session being created.
 * @param password A password to protect the session being created. Pass nil if the session does not need a password
 * @param startPaused Tells the client whether or not to immediately pause all events upon creation.
 * @param completionHandler A completion block that passes back information after a session has been created.
 *
 * @discussion This creates a session with no participant limit.
 * @warning CreateSessionCompletionHanler is called on the main thread
 */
- (void)createSessionWithName:(NSString *)sessionName tags:(NSArray *)tags password:(NSString *)password startPaused:(BOOL)startPaused completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Create a session without a base file but with a participant limit.
 *
 * @param sessionName The name of the session being created. Needs to be unique.
 * @param tags The tags that represent the session being created.
 * @param password A password to protect the session being created. Pass nil if the session does not need a password
 * @param participantLimit Limits the number of participants that a session can have. 0 is the default, indicating no limit
 * @param startPaused Tells the client whether or not to immediately pause all events upon creation.
 * @param completionHandler A completion block that passes back information after a session has been created.
 *
 * @warning CreateSessionCompletionHanler is called on the main thread
 */
- (void)createSessionWithName:(NSString *)sessionName tags:(NSArray *)tags password:(NSString *)password participantLimit:(NSInteger)participantLimit startPaused:(BOOL)startPaused completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Create a session with a base file and with no participant limit
 *
 * @param sessionName The name of the session being created. Needs to be unique.
 * @param tags The tags that represent the session being created.
 * @param password A password to protect the session being created. Pass nil if the session does not need a password
 * @param startPaused Tells the client whether or not to immediately pause all events upon creation.
 * @param completionHandler A completion block that passes back information after a session has been created.
 *
 * @warning CreateSessionCompletionHanler is called on the main thread
 * @discussion The client will request base file chunks from its data source. This method also creates a session 
 * with no participant limit.
 * @see CollabrifyClientDataSource
 */
- (void)createSessionWithBaseFileWithName:(NSString *)sessionName tags:(NSArray *)tags password:(NSString *)password startPaused:(BOOL)startPaused completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Create a session with a base file and a participant limit.
 *
 * @param sessionName The name of the session being created. Needs to be unique.
 * @param tags The tags that represent the session being created.
 * @param password A password to protect the session being created. Pass nil if the session does not need a password
 * @param participantLimit Limits the number of participants that a session can have. 0 is the default, indicating no limit
 * @param startPaused Tells the client whether or not to immediately pause all events upon creation.
 * @param completionHandler A completion block that passes back information after a session has been created.
 *
 * @warning CreateSessionCompletionHanler is called on the main thread
 */
- (void)createSessionWithBaseFileWithName:(NSString *)sessionName tags:(NSArray *)tags password:(NSString *)password participantLimit:(NSInteger)participantLimit startPaused:(BOOL)startPaused completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Join a given session.
 *
 * @param sessionID The session id of the session you are trying to join.
 * @param password The password of the session you are trying to join. If there is no password, pass nil.
 * @param completionHandler A completion block that passes back information after joining a session.
 * @discussion The completionHandler is called on the main thread.
 */
- (void)joinSessionWithID:(int64_t)sessionID password:(NSString *)password completionHandler:(JoinSessionCompletionHandler)completionHandler;

/**
 * Join a given session.
 *
 * @param sessionID The session id of the session you are trying to join.
 * @param password The password of the session you are trying to join. If there is no password, pass nil.
 * @param startPaused Tells the client to pause events immediately upon joining a session.
 * @param completionHandler A completion block that passes back information after joining a session.
 * @discussion The completionHandler is called on the main thread.
 */
- (void)joinSessionWithID:(int64_t)sessionID password:(NSString *)password startPaused:(BOOL)startPaused completionHandler:(JoinSessionCompletionHandler)completionHandler;

/**
 * Leave a session
 *
 * @param deleteSession A flag that tells the client to delete the session. This flag is only used if you are the session owner
 * @param completionHandler A completion block that passes back information after leaving a session
 * @discussion The completionHandler is called on the main thread.
 */
- (void)leaveAndDeleteSession:(BOOL)deleteSession completionHandler:(LeaveSessionCompletionHandler)completionHandler;

/**
 * Broadcasts data to all participants in the session
 *
 * @param payload The data that is to be sent to all participants
 * @param eventType A string representing the type of the event being sent
 * @return Returns a unique submission registration id representing the event you are broadcasting. If an error occurs, -1 is returned.
 */
- (int32_t)broadcast:(NSData *)payload eventType:(NSString *)eventType;

/**
 * Lists the current sessions as an array of CollabrifySession objects
 *
 * @param tags The tags of the sessions you want to retrieve
 * @param completionHandler A completion block that passes back an array of CollabrifySession objects
 * @discussion The completionHandler is called on the main thread.
 */
- (void)listSessionsWithTags:(NSArray *)tags completionHandler:(ListSessionsCompletionHandler)completionHandler;

/**
 * Returns whether the client is in a session.
 * @return Returns whether the client is in a session.
 */
- (BOOL)isInSession;

/**
 * Returns whether the current session has ended.
 * @return Returns whether the current session has ended and is no longer valid.
 */
- (BOOL)currentSessionHasEnded;

/**
 * Returns whether the current session has a base file.
 * @return Returns whether the current session has a base file.
 */
- (BOOL)currentSessionHasBaseFile;

/**
 * Returns the current session id.
 * @return Returns the session id.
 */
- (int64_t)currentSessionID;

/**
 * Returns whether the current session is password protected.
 * @return Returns whether the current session is password protected.
 */
- (BOOL)currentSessionIsPasswordProtected;

/**
 * Returns the current session name.
 * @return Returns the current session name.
 */
- (NSString *)currentSessionName;

/**
 * Returns the current session order id
 * @return Returns the current session order id
 */
- (int64_t)currentSessionOrderID;

/**
 * Returns the current session owner.
 * @return Returns the current session owner.
 */
- (CollabrifyParticipant *)currentSessionOwner;

/**
 * Returns the current session participant count.
 * @return Returns the current session participant count.
 */
- (NSUInteger)currentSessionParticipantCount;

/**
 * Returns the current session participants.
 * @return Returns the current session participants.
 */
- (NSArray *)currentSessionParticipants;

/**
 * Returns the current session tags.
 * @return Returns the current session tags.
 */
- (NSArray *)currentSessionTags;

/**
 * Returns whether the client has a network connection.
 * @return Returns a boolean indicating whether the client has a network connection.
 */
+ (BOOL)hasNetworkConnection;

@end

@interface CollabrifyClient (BackgroundServices)

/** Returns whether the client is backgrounded. */
@property (readonly, assign, getter = isBackgrounded, nonatomic) BOOL backgrounded;

/**
 * Begin a background task.
 *
 * @param error An error passed by reference if a problem occurs.
 * @return A boolean indicating if the application has begun a background task.
 * @see CollabrifyError
 */
- (BOOL)beginCollabrifyBackgroundTask:(CollabrifyError * __autoreleasing *)error;

/** Ends a background task. */
- (void)endCollabrifyBackgroundTask;

@end

/**
 * Register for these notifications to receive updates from the client
 */
extern NSString *const CollabrifyClientSessionEndedNotification;
extern NSString *const CollabrifyClientReceivedEventNotification;
extern NSString *const CollabrifyClientParticipantJoinedSessionNotification;
extern NSString *const CollabrifyClientParticipantLeftSessionNotification;

extern NSString *const CollabrifyClientUploadedBaseFileNotification;
extern NSString *const CollabrifyClientEncounteredErrorNotification;

extern NSString *const CollabrifyClientSessionIDKey;
extern NSString *const CollabrifyClientLeftSessionKey;
extern NSString *const CollabrifyClientParticipantKey;
extern NSString *const CollabrifyClientEventDataKey;
extern NSString *const CollabrifyClientOrderIDKey;
extern NSString *const CollabrifyClientBaseFileSizeKey;
extern NSString *const CollabrifyClientErrorKey;
