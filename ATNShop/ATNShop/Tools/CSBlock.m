//
//  CSBlock.m
//  IOS-Categories
//
//  Created by csw on 15/5/4.
//  Copyright (c) 2015年 www.csw.com All rights reserved.
//

#import "CSBlock.h"
#import <objc/runtime.h>
#import <dispatch/dispatch.h>

@implementation UIControl (BUIControl)
static char OperationKey;

- (void)removeHandlerForEvent:(UIControlEvents)event
{
    
    NSString *methodName = [UIControl eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(opreations == nil)
    {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block {
    
    NSString *methodName = [UIControl eventName:event];
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(opreations == nil)
    {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:block forKey:methodName];
    
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}


- (void)UIControlEventTouchDown{[self callActionBlock:UIControlEventTouchDown];}
- (void)UIControlEventTouchDownRepeat{[self callActionBlock:UIControlEventTouchDownRepeat];}
- (void)UIControlEventTouchDragInside{[self callActionBlock:UIControlEventTouchDragInside];}
- (void)UIControlEventTouchDragOutside{[self callActionBlock:UIControlEventTouchDragOutside];}
- (void)UIControlEventTouchDragEnter{[self callActionBlock:UIControlEventTouchDragEnter];}
- (void)UIControlEventTouchDragExit{[self callActionBlock:UIControlEventTouchDragExit];}
- (void)UIControlEventTouchUpInside{[self callActionBlock:UIControlEventTouchUpInside];}
- (void)UIControlEventTouchUpOutside{[self callActionBlock:UIControlEventTouchUpOutside];}
- (void)UIControlEventTouchCancel{[self callActionBlock:UIControlEventTouchCancel];}
- (void)UIControlEventValueChanged{[self callActionBlock:UIControlEventValueChanged];}
- (void)UIControlEventEditingDidBegin{[self callActionBlock:UIControlEventEditingDidBegin];}
- (void)UIControlEventEditingChanged{[self callActionBlock:UIControlEventEditingChanged];}
- (void)UIControlEventEditingDidEnd{[self callActionBlock:UIControlEventEditingDidEnd];}
- (void)UIControlEventEditingDidEndOnExit{[self callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)UIControlEventAllTouchEvents{[self callActionBlock:UIControlEventAllTouchEvents];}
- (void)UIControlEventAllEditingEvents{[self callActionBlock:UIControlEventAllEditingEvents];}
- (void)UIControlEventApplicationReserved{[self callActionBlock:UIControlEventApplicationReserved];}
- (void)UIControlEventSystemReserved{[self callActionBlock:UIControlEventSystemReserved];}
- (void)UIControlEventAllEvents{[self callActionBlock:UIControlEventAllEvents];}


- (void)callActionBlock:(UIControlEvents)event {
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(opreations == nil) return;
    void(^block)(id sender) = [opreations objectForKey:[UIControl eventName:event]];
    
    if (block) block(self);
    
}
+(NSString *)eventName:(UIControlEvents)event
{
    switch (event) {
        case UIControlEventTouchDown:          return @"UIControlEventTouchDown";
        case UIControlEventTouchDownRepeat:    return @"UIControlEventTouchDownRepeat";
        case UIControlEventTouchDragInside:    return @"UIControlEventTouchDragInside";
        case UIControlEventTouchDragOutside:   return @"UIControlEventTouchDragOutside";
        case UIControlEventTouchDragEnter:     return @"UIControlEventTouchDragEnter";
        case UIControlEventTouchDragExit:      return @"UIControlEventTouchDragExit";
        case UIControlEventTouchUpInside:      return @"UIControlEventTouchUpInside";
        case UIControlEventTouchUpOutside:     return @"UIControlEventTouchUpOutside";
        case UIControlEventTouchCancel:        return @"UIControlEventTouchCancel";
        case UIControlEventValueChanged:       return @"UIControlEventValueChanged";
        case UIControlEventEditingDidBegin:    return @"UIControlEventEditingDidBegin";
        case UIControlEventEditingChanged:     return @"UIControlEventEditingChanged";
        case UIControlEventEditingDidEnd:      return @"UIControlEventEditingDidEnd";
        case UIControlEventEditingDidEndOnExit:return @"UIControlEventEditingDidEndOnExit";
        case UIControlEventAllTouchEvents:     return @"UIControlEventAllTouchEvents";
        case UIControlEventAllEditingEvents:   return @"UIControlEventAllEditingEvents";
        case UIControlEventApplicationReserved:return @"UIControlEventApplicationReserved";
        case UIControlEventSystemReserved:     return @"UIControlEventSystemReserved";
        case UIControlEventAllEvents:          return @"UIControlEventAllEvents";
        default:
            return @"description";
    }
    return @"description";
}
+(UIControlEvents)eventWithName:(NSString *)name
{
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventTouchDownRepeat"])     return UIControlEventTouchDownRepeat;
    if([name isEqualToString:@"UIControlEventTouchDragInside"])     return UIControlEventTouchDragInside;
    if([name isEqualToString:@"UIControlEventTouchDragOutside"])    return UIControlEventTouchDragOutside;
    if([name isEqualToString:@"UIControlEventTouchDragEnter"])      return UIControlEventTouchDragEnter;
    if([name isEqualToString:@"UIControlEventTouchDragExit"])       return UIControlEventTouchDragExit;
    if([name isEqualToString:@"UIControlEventTouchUpInside"])       return UIControlEventTouchUpInside;
    if([name isEqualToString:@"UIControlEventTouchUpOutside"])      return UIControlEventTouchUpOutside;
    if([name isEqualToString:@"UIControlEventTouchCancel"])         return UIControlEventTouchCancel;
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventValueChanged"])        return UIControlEventValueChanged;
    if([name isEqualToString:@"UIControlEventEditingDidBegin"])     return UIControlEventEditingDidBegin;
    if([name isEqualToString:@"UIControlEventEditingChanged"])      return UIControlEventEditingChanged;
    if([name isEqualToString:@"UIControlEventEditingDidEnd"])       return UIControlEventEditingDidEnd;
    if([name isEqualToString:@"UIControlEventEditingDidEndOnExit"]) return UIControlEventEditingDidEndOnExit;
    if([name isEqualToString:@"UIControlEventAllTouchEvents"])      return UIControlEventAllTouchEvents;
    if([name isEqualToString:@"UIControlEventAllEditingEvents"])    return UIControlEventAllEditingEvents;
    if([name isEqualToString:@"UIControlEventApplicationReserved"]) return UIControlEventApplicationReserved;
    if([name isEqualToString:@"UIControlEventSystemReserved"])      return UIControlEventSystemReserved;
    if([name isEqualToString:@"UIControlEventAllEvents"])           return UIControlEventAllEvents;
    return UIControlEventAllEvents;
}

@end




@implementation UIView(BUIView)

const char oldDelegateKey;
const char completionHandlerKey;

#pragma -mark UIAlerView

-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIAlertView *alert = (UIAlertView *)self;
    if(completionHandler != nil)
    {
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        //oldDelegate = alert.delegate;
        alert.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    alert.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}



#pragma -mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    UIActionSheet *sheet = (UIActionSheet *)self;
    
    sheet.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}


-(void)config:(void(^)(NSInteger buttonIndex))completionHandler
{
    if(completionHandler != nil)
    {
        
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        UIActionSheet *sheet = (UIActionSheet *)self;
        //oldDelegate = sheet.delegate;
        sheet.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
}
-(void)showInView:(UIView *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showInView:view];
}

-(void)showFromToolbar:(UIToolbar *)view
 withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromToolbar:view];
}

-(void)showFromTabBar:(UITabBar *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromTabBar:view];
}

-(void)showFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromRect:rect inView:view animated:animated];
}

-(void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromBarButtonItem:item animated:animated];
}

@end






@implementation NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end







static inline dispatch_time_t dTimeDelay(NSTimeInterval time) {
    int64_t delta = (int64_t)(NSEC_PER_SEC * time);
    return dispatch_time(DISPATCH_TIME_NOW, delta);
}

@implementation NSObject (Blocks)

+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled)block();
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO); });
    
    return wrappingBlock;
}

+ (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL, id) = ^(BOOL cancel, id arg) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block(arg);
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO, anObject); });
    
    return wrappingBlock;
}

- (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO); });
    
    return wrappingBlock;
}

- (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL, id) = ^(BOOL cancel, id arg) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block(arg);
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO, anObject); });
    
    return wrappingBlock;
}

+ (void)cancelBlock:(id)block {
    if (!block) return;
    void (^aWrappingBlock)(BOOL) = (void(^)(BOOL))block;
    aWrappingBlock(YES);
}

+ (void)cancelPreviousPerformBlock:(id)aWrappingBlockHandle {
    [self cancelBlock:aWrappingBlockHandle];
}

@end


@implementation NSObject (GCD)
- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)shouldWait {
    if (shouldWait) {
        // Synchronous
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    else {
        // Asynchronous
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
- (void)performAsynchronous:(void(^)(void))block {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
@end
