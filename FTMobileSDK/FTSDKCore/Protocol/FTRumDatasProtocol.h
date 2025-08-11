//
//  FTRumDatasProtocol.h
//  FTMobileAgent
//
//  Created by hulilei on 2022/6/13.
//  Copyright © 2022 TRUEWATCH. All rights reserved.
//

#ifndef FTAddRumDatasProtocol_h
#define FTAddRumDatasProtocol_h
NS_ASSUME_NONNULL_BEGIN
/// App running state
typedef NS_ENUM(NSUInteger, FTAppState) {
    /// Unknown
    FTAppStateUnknown,
    /// Starting up
    FTAppStateStartUp,
    /// Running
    FTAppStateRun,
};
/// rum data protocol
@protocol FTRumDatasProtocol <NSObject>
/// Create RUM View
///
/// Called before the `-startViewWithName` method, this method is used to record the page loading time. If the loading time cannot be obtained, this method can be omitted.
/// - Parameters:
///   - viewName: RUM View name
///   - loadTime: page loading time
-(void)onCreateView:(NSString *)viewName loadTime:(NSNumber *)loadTime;
/// Starts RUM view
///
/// - Parameters:
///   - viewName: RUM View name
-(void)startViewWithName:(NSString *)viewName;

/// Starts RUM view
/// - Parameters:
///   - viewName: RUM View name
///   - property: event custom properties (optional)
-(void)startViewWithName:(NSString *)viewName property:(nullable NSDictionary *)property;

/// Update view loading time to current RUM view.
/// Must be called between `-startView` and `-stopView` methods to take effect.
/// - Parameters:
///   - duration: loading time duration (nanosecond).
-(void)updateViewLoadingTime:(NSNumber *)duration;

/// Stop RUM View.
-(void)stopView;

/// Stop RUM View.
/// - Parameter property: event custom properties (optional)
-(void)stopViewWithProperty:(nullable NSDictionary *)property;

/// Start RUM Action.
///
/// RUM will bind Resource, Error, and LongTask events that this Action may trigger. Avoid adding multiple times within 0.1s. Only one Action can be associated with the same View at the same time. If the previous Action hasn't ended, new Actions will be discarded.
/// This does not interfere with Actions added by the `addAction:actionType:property` method.
///
/// - Parameters:
///   - actionName: event name
///   - actionType: event type
///   - property: event custom properties (optional)
- (void)startAction:(NSString *)actionName actionType:(NSString *)actionType property:(nullable NSDictionary *)property;

/// Add Action event. No duration, no discard logic
///
/// This does not interfere with RUM Actions started by `startAction:actionType:property:`.
/// - Parameters:
///   - actionName: event name
///   - actionType: event type
///   - property: event custom properties (optional)
- (void)addAction:(NSString *)actionName actionType:(NSString *)actionType property:(nullable NSDictionary *)property;

/// Add Launch Action event.
/// - Parameters:
///   - name: action name
///   - type: action type
///   - time: launch time
///   - duration: launch duration
///   - property: event custom properties (optional)
- (void)addLaunch:(NSString *)name type:(NSString *)type launchTime:(NSDate *)time duration:(NSNumber *)duration property:(nullable NSDictionary *)property;

/// Add Error event
///
/// - Parameters:
///   - type: error type
///   - message: error message
///   - stack: stack information
- (void)addErrorWithType:(NSString *)type message:(NSString *)message stack:(NSString *)stack;
/// Add Error event
/// - Parameters:
///   - type: error type
///   - message: error message
///   - stack: stack information
///   - property: event custom properties (optional)
- (void)addErrorWithType:(NSString *)type message:(NSString *)message stack:(NSString *)stack property:(nullable NSDictionary *)property;

/// Add Error event
/// - Parameters:
///   - type: error type
///   - state: program running state
///   - message: error message
///   - stack: stack information
///   - property: event custom properties (optional)
- (void)addErrorWithType:(NSString *)type state:(FTAppState)state  message:(NSString *)message stack:(NSString *)stack property:(nullable NSDictionary *)property;

/// Add freeze event
///
/// - Parameters:
///   - stack: freeze stack
///   - duration: freeze duration (nanoseconds)
///   - startTime: freeze start time
- (void)addLongTaskWithStack:(NSString *)stack duration:(NSNumber *)duration startTime:(long long)startTime;

/// Add freeze event
/// - Parameters:
///   - stack: freeze stack
///   - duration: freeze duration (nanoseconds)
///   - startTime: freeze start time (nanosecond timestamp)
///   - property: event custom properties (optional)
- (void)addLongTaskWithStack:(NSString *)stack duration:(NSNumber *)duration startTime:(long long)startTime property:(nullable NSDictionary *)property;

@optional
/**
 * Enter page
 * @param viewId          page id
 * @param viewName        page name
 * @param property        event custom properties (optional)
 */
-(void)startViewWithViewID:(NSString *)viewId viewName:(NSString *)viewName property:(nullable NSDictionary *)property;
/**
 * Leave page
 * @param viewId         page id
 * @param property       event custom properties (optional)
 */
-(void)stopViewWithViewID:(nullable NSString *)viewId property:(nullable NSDictionary *)property;
@end
NS_ASSUME_NONNULL_END
#endif 
