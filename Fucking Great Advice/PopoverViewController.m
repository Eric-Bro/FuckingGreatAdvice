//
//  PopoverViewController.m
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopoverViewController.h"

@implementation PopoverViewController
@synthesize controller, anAdvice, anID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)updateWithAdvice:(NSString *)_advice atID:(NSString *)_id
{
    [self setAnAdvice: _advice];

    if ([_id isEqualToString:@"_"]) {
        [self setAnID:@"Совет дня"];
    } else {
        [self setAnID: [NSString stringWithFormat:@"Совет №%@",_id]];
    }
}
- (void)mouseDown
{
    [controller giveAdvice:self];
}

- (IBAction)close:(id)sender
{
    [sender setState:1];
    [controller hidePopover];
}

@end
