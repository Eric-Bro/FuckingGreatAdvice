//
//  PopoverViewController.h
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Fucking_Great_AdviceAppDelegate;
@interface PopoverViewController : NSViewController
{
    Fucking_Great_AdviceAppDelegate *controller;
    IBOutlet NSTextField *_adviceField;
    IBOutlet NSTextField *_idField;
    IBOutlet NSButton *close;

    NSString *anAdvice;
    NSString *anID;
}


@property (nonatomic, assign) Fucking_Great_AdviceAppDelegate *controller;
@property (nonatomic, retain) NSString *anAdvice;
@property (nonatomic, retain) NSString *anID;

- (void)updateWithAdvice:(NSString*)_advice atID:(NSString*)_id;
- (IBAction)close:(id)sender;
@end
