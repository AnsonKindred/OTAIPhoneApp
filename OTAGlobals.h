//
//  OTAGlobals.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/7/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAGlobals : NSObject
{
    NSString* username;
    NSString* likePlaylistID;
    NSString* CHANNEL_ID;
    NSString* wordpressDomain;
}

@property(nonatomic,retain) NSString* username;
@property(nonatomic,retain) NSString* likePlaylistID;
@property(nonatomic,retain) NSString* CHANNEL_ID;
@property(nonatomic,retain) NSString* wordpressDomain;

+ (OTAGlobals*)getInstance;

@end
