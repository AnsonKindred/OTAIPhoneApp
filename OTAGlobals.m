//
//  OTAGlobals.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/7/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAGlobals.h"

@implementation OTAGlobals
@synthesize username;
@synthesize likePlaylistID;
@synthesize CHANNEL_ID;
@synthesize wordpressDomain;

static OTAGlobals *instance = nil;

+ (OTAGlobals *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [OTAGlobals new];
            instance.CHANNEL_ID = @"UCJ0MDVTDD_8ryFEleEiZwsw";
            instance.wordpressDomain = @"http://ota.zebadiah.me";
        }
    }
    return instance;
}
@end
