//
//  Fucking_Great_AdviceAppDelegate.m
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fucking_Great_AdviceAppDelegate.h"
#import "BCStatusItemView.h"
#import "NSStatusItem+BCStatusItem.h"

// UserDefaults keys
#define EBFAutoStartKey @"ebf_autostart"
#define EBFShowAdviceOnStartup @"ebf_showadviceonstartup"
#define EBFAutoShowAdvice @"ebf_autoshowadvice"
#define EBFShowTimeInterval @"ebf_showtimeinterval"
#define EBFPlaySound @"ebf_playsound"
#define EBFAutoHideAdvice @"ebf_autohideadvice"
#define EBFHideTimeInterval  @"ebf_hidetimeinterval"

// API 
#define FGA_API_RANDOM @"http://fucking-great-advice.ru/api/random"
#define FGA_API_LATEST @"http://fucking-great-advice.ru/api/latest"


@implementation Fucking_Great_AdviceAppDelegate

@synthesize settingsWindow = _settingsWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib
{
    /* Compose menubar */
    _mainStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    [_mainStatusItem setupView];
    
    [_mainStatusItem setMenu: _menu];
    [_mainStatusItem setImage:[NSImage imageNamed:@"FGAIcon.png"]];
    [_mainStatusItem setHighlightMode: NO];
    
    /* Compose popover */
    _controller = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" 
                                                          bundle:nil];
    [_controller setController: self];
    NSRect frame = [[[_mainStatusItem view] window] frame];
    _point = NSMakePoint(NSMidX(frame), NSMinY(frame));
    
    /* Init the main request to API */
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: FGA_API_RANDOM]];
    
    /* - - - - - - - - - -- - - - - - -
     * In this section we check users defaults and (if app is running first time) write into them prefs by default.
     *- - - - - - - - - -- - - - - - - */
    NSUserDefaults *uDef = [NSUserDefaults standardUserDefaults];
    if (![uDef objectForKey:@"ebfga"]) {
        [uDef setBool:YES forKey:@"ebfga"];

        // Ok, by default we add our app into the 'Login Items'
        [uDef setBool:YES forKey:EBFAutoStartKey];
        [self regiserApplicationAsLoginItem: YES];
        
        [uDef setBool:YES forKey:EBFShowAdviceOnStartup];
        [uDef setBool: NO forKey: EBFAutoShowAdvice];
        [uDef setInteger:[_showTimeInterval indexOfSelectedItem] forKey:EBFShowTimeInterval];
        [uDef setBool: YES forKey: EBFPlaySound];
        [uDef setBool: YES forKey: EBFAutoHideAdvice];
        [uDef setInteger:[_hideTimeInterval indexOfSelectedItem] forKey: EBFHideTimeInterval];
        [uDef synchronize];
    }
    /* Read prefs from user defaults to settings window's controls */
    [_autoStart setState:[uDef boolForKey: EBFAutoStartKey]];
    [_showAdviceOnStartup setState:[uDef boolForKey: EBFShowAdviceOnStartup]];
    [_showAdviceOnStartup setEnabled:[_autoStart state]];
    
    [_autoShowAdvice setState:[uDef boolForKey: EBFAutoShowAdvice]];
    [_showTimeInterval setEnabled: [_autoShowAdvice state]];
    [_playSound setEnabled: [_autoShowAdvice state]];
    [_showTimeInterval selectItemAtIndex:[uDef integerForKey:EBFShowTimeInterval]];
    [_playSound setState:[uDef boolForKey:EBFPlaySound]];
    
    [_autoHideAdvice setState:[uDef boolForKey:EBFAutoHideAdvice]];
    [_hideTimeInterval setEnabled: [_autoHideAdvice state]];
    [_hideTimeInterval selectItemAtIndex:[uDef integerForKey:EBFHideTimeInterval]];
    
    if ([_showAdviceOnStartup state] && [_showAdviceOnStartup isEnabled]) {
        [self giveAdvice: nil];
    }
}

#pragma mark Aplication Settings

/*
 * Add/delete app from user's 'Login Items'
 *
 * @params(1)  $add (if YES - add app to, if NO - delete from)
 * @return     [void]
 */
- (void)regiserApplicationAsLoginItem:(BOOL)add
{
    /* Compose path to our app and Login Item's list */
    CFURLRef appURL = (CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];    
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, 
                                                            NULL);
    if (loginItems) {
        /* If we adding app in Login Items list - insert an item($item) to the list($loginItems). */
        if (add) {
            
            LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                         kLSSharedFileListItemLast,
                                                                         NULL, 
                                                                         NULL, appURL, NULL, NULL);
            if (item) {CFRelease(item);}
        } else {
            /* Another way - delete our app from list. 
             * At first - add all items in one array($loginItemsArray) and search app by path($appURL). */
            NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, NULL);
            for(int i =0; i < [loginItemsArray count]; i++){
                LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)[loginItemsArray
                                                                            objectAtIndex:i];
                if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &appURL, NULL) == noErr) {
                    if ([[(NSURL*)appURL path] isEqualToString:[[NSBundle mainBundle] bundlePath]]) {
                        LSSharedFileListItemRemove(loginItems,itemRef);
                    }
                }
            }
            [loginItemsArray release];
        }
    }
}

- (IBAction)updateSettings:(id)sender {
    
    BOOL state = [sender state];
    switch ([sender tag]) {
        case 91: 
            [[NSUserDefaults standardUserDefaults] setBool: state
                                                    forKey: EBFAutoStartKey];
            [self regiserApplicationAsLoginItem: state];
            [_showAdviceOnStartup setEnabled: state];
            break;
        case 911:
            [[NSUserDefaults standardUserDefaults] setBool: state
                                                    forKey: EBFShowAdviceOnStartup];
            break;
        case 92:
            [[NSUserDefaults standardUserDefaults] setBool: state 
                                                    forKey: EBFAutoShowAdvice];
            [_showTimeInterval setEnabled: state];
            [_playSound setEnabled: state];
            break;
        case 93:
            [[NSUserDefaults standardUserDefaults] setInteger: [(NSPopUpButton*)sender indexOfSelectedItem] 
                                                       forKey: EBFShowTimeInterval];
            break;
        case 94:
            [[NSUserDefaults standardUserDefaults] setBool: state
                                                    forKey: EBFPlaySound];
            break;
        case 95:
            [[NSUserDefaults standardUserDefaults] setBool: state
                                                    forKey: EBFAutoHideAdvice];
            [_hideTimeInterval setEnabled: state];
            break;
        case 96:
            [[NSUserDefaults standardUserDefaults] setInteger: [(NSPopUpButton*)sender indexOfSelectedItem] 
                                                       forKey: EBFHideTimeInterval];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Advices and popover
- (void)showPopoverWithAdvice:(NSString*)anAdvice ID:(NSString*)anID reopen:(BOOL)aReopen
{
    anAdvice = [anAdvice stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    anAdvice = [anAdvice stringByReplacingOccurrencesOfString:@"&#151;" withString:@"-"];
    anAdvice = [anAdvice stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"'"];
    anAdvice = [anAdvice stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"'"];
    
    [_controller updateWithAdvice: anAdvice atID:anID];
    
    if (aReopen) {
        _attachedWindow = [[MAAttachedWindow alloc] initWithView: [_controller view] 
                                                 attachedToPoint: _point
                                                        inWindow: nil 
                                                          onSide: MAPositionBottom 
                                                      atDistance: /*2.7*/19];
        [_attachedWindow makeKeyAndOrderFront:self];
        [_attachedWindow orderFrontRegardless];
    }
    // If user set 'auto hide' mode - setup timer for hiding advice
    if ([_autoHideAdvice state] && [_autoHideAdvice isEnabled]) {
        NSInteger timerIntervalForHide = [[NSUserDefaults standardUserDefaults] integerForKey:EBFHideTimeInterval]+1;
        timerIntervalForHide *= 5;
        _timer = [NSTimer scheduledTimerWithTimeInterval: (float)timerIntervalForHide 
                                                  target: self 
                                                selector: @selector(hideTimerTickTack:) 
                                                userInfo: nil 
                                                 repeats: NO];
    }
}

- (void)hidePopover
{
    if (_timer) {
        [_timer invalidate], _timer = nil; 
    }
    [_attachedWindow orderOut:self];
    [_attachedWindow release];
    _attachedWindow = nil;
    
    // If user set 'auto show new one' mode - setup timer for showing new advice
    if ([_autoShowAdvice state] && [_autoShowAdvice isEnabled]) {
        NSInteger showTimeinterval = [[NSUserDefaults standardUserDefaults] integerForKey:EBFShowTimeInterval]+1;
        showTimeinterval = (showTimeinterval == 3) ? 60*4*15 : 60*showTimeinterval*15;
        _timer = [NSTimer scheduledTimerWithTimeInterval: showTimeinterval 
                                                  target: self
                                                selector: @selector(showTimerTickTack:) 
                                                userInfo: nil    
                                                 repeats: NO];
        
    }
}

- (void)showTimerTickTack:(NSTimer*)aTimer
{
    [_timer invalidate], _timer = nil;
    [self giveAdvice: self];
    if ([_playSound state] && [_playSound isEnabled]) NSBeep();
}
- (void)hideTimerTickTack:(NSTimer*)aTimer
{
    [_timer invalidate], _timer = nil;
    [self hidePopover];
}

#pragma mark IBActions

-(IBAction)giveAdvice:(id)sender
{
    if (_timer) {
        [_timer invalidate], _timer = nil; 
    }
    BOOL reopenPopover;
    if ([sender isKindOfClass:[PopoverViewController class]]) {
        reopenPopover = NO;
    } else{
        reopenPopover = YES;
        [self hidePopover];
    }
    _data = [NSURLConnection sendSynchronousRequest: _request
                                  returningResponse: NULL 
                                              error: NULL];
    _decoder = [JSONDecoder decoder];
    _jsonDict = [_decoder objectWithData: _data];
    [self showPopoverWithAdvice: [_jsonDict objectForKey:@"text"] ID: [_jsonDict objectForKey:@"id"] reopen: reopenPopover];
    _jsonDict = nil, _decoder = nil,_data = nil;  
}

-(IBAction)showSettings:(id)sender
{
    [_settingsWindow setOrderedIndex:0];
    [_settingsWindow makeMainWindow];
    [_settingsWindow makeKeyAndOrderFront:self];
    [_settingsWindow orderFrontRegardless];
}


@end
