//
//  OTAGlobals.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/7/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "Globals.h"

@implementation Globals
@synthesize username;
@synthesize likePlaylistID;
@synthesize CHANNEL_ID;
@synthesize wordpressDomain;

static Globals *instance = nil;

+ (Globals *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [Globals new];
            instance.CHANNEL_ID = @"UCJ0MDVTDD_8ryFEleEiZwsw";
            instance.wordpressDomain = @"http://ota.zebadiah.me/services/";
        }
    }
    return instance;
}
@end
