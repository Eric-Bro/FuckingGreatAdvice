//
//  Fucking_Great_AdviceAppDelegate.h
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverViewController.h"
#import "MAAttachedWindow.h"
#import "JSONKit.h"


@interface Fucking_Great_AdviceAppDelegate : NSObject <NSApplicationDelegate> {
    
    /* Settings window */
    NSWindow *_settingsWindow;
    IBOutlet NSButton *_autoStart;                // Do we need to start app at system startup
    IBOutlet NSButton *_showAdviceOnStartup;      // Do we need to show advice on start
    IBOutlet NSButton *_autoShowAdvice;           // Do we need to automatically show new advice after closing old one.
    IBOutlet NSPopUpButton *_showTimeInterval;    // Set the time interval for showing new advice.
    IBOutlet NSButton *_playSound;                // Play sound with advice
    IBOutlet NSButton *_autoHideAdvice;           // Do we need to automatically hide advice
    IBOutlet NSPopUpButton *_hideTimeInterval;    // Set the time interval for hiding advice
    
    /* Status bar menu */
    IBOutlet NSMenu *_menu;
    NSStatusItem *_mainStatusItem;
    MAAttachedWindow *_attachedWindow;
    PopoverViewController *_controller;
    NSPoint _point;
    
    /* Download an advice */
    NSURLRequest *_request;
    NSData *_data;
    JSONDecoder *_decoder;
    NSDictionary *_jsonDict;
    
    /* Timer for auto_actions */
    NSTimer *_timer;
}

// Yeah, we have not a main window at this app. Only settings window.
@property (strong) IBOutlet NSWindow *settingsWindow;

/* Outlets for menu items */
- (IBAction)giveAdvice:(id)sender; // Show new advice. Its method will be celled by PopoverViewController also.
- (IBAction)showSettings:(id)sender; // Show settings window (at front of other user's window)

/*Outlet for settings window's buttons */
- (IBAction)updateSettings:(id)sender; // It's replace current preferences with selected by user.
@end
