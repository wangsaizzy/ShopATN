//
//  CSBlock.h

//  Created by csw on 15/5/4.
//  Copyright (c) 2015年 www.csw.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - UIBlock

@interface UIControl (BUIControl)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
- (void)removeHandlerForEvent:(UIControlEvents)event;

@end

@interface UIView(BUIView)<UIAlertViewDelegate,UIActionSheetDelegate>

//UIAlertView
-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

//UIActionSheet
-(void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromToolbar:(UIToolbar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromTabBar:(UITabBar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end


#pragma mark - NSObjectBlock

@interface NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end


@interface NSObject (Blocks)

+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
+ (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;
- (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;

+ (void)cancelBlock:(id)block;
+ (void)cancelPreviousPerformBlock:(id)aWrappingBlockHandle __attribute__ ((deprecated));

@end


@interface NSObject (GCD)

- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;
- (void)performAsynchronous:(void(^)(void))block;
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

@end


