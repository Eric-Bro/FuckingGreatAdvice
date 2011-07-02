//
//  EBRPopoverView.h
//  Fucking Great Advice
//
//  Created by Eric Bro on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface EBRPopoverView : NSView
{
    IBOutlet id delegate;
}

@end

@interface EBRTextFeild : NSTextField 
{
    IBOutlet id _delegate_;
}
@end