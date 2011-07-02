//
//  EBRPopoverView.m
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EBRPopoverView.h"

@implementation EBRPopoverView

- (void)mouseDown:(NSEvent *)theEvent
{
    [delegate mouseDown];
}
@end

@implementation EBRTextFeild

- (void)mouseDown:(NSEvent *)theEvent
{
    [_delegate_ mouseDown];
}

@end
