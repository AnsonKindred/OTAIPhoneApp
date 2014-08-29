#import "OTARSSEntry.h"

@implementation OTARSSEntry
@synthesize title = _title;
@synthesize url = _url;
@synthesize date = _date;
@synthesize description = _description;
@synthesize thumbnail = _thumbnail;
@synthesize artistTag = _artistTag;
@synthesize videoUrl = _videoUrl;
@synthesize youtubeVideoID = _youtubeVideoID;
@synthesize numPosts = _numPosts;
@synthesize artist = _artist;
@synthesize song = _song;

- (id)init:(NSString*)title
       url:(NSString*)url
      date:(NSString*)date
description:(NSString*)description
 thumbnail:(NSString*)thumbnail
 artistTag:(NSString*)artistTag
  videoUrl:(NSString*)videoUrl
youtubeVideoID:(NSString*)youtubeVideoID
  numPosts:(NSInteger)numPosts
    artist:(NSString*)artist
      song:(NSString*)song
{
    if ((self = [super init])) {
        _title = [title copy];
        _url = [url copy];
        _date = [date copy];
		_description = [description copy];
		_thumbnail = [thumbnail copy];
        _artistTag = [artistTag copy];
        _videoUrl = [videoUrl copy];
        _youtubeVideoID = [youtubeVideoID copy];
        _numPosts = numPosts;
        _artist = [artist copy];
        _song = [song copy];
    }
    return self;
}

- (id)init:(NSString*)artist
      song:(NSString*)song
  videoUrl:(NSString*)videoUrl
youtubeVideoID:(NSString*)youtubeVideoID
{
    return [self init:@""
                  url:@""
                 date:@""
          description:@""
            thumbnail:@""
            artistTag:@""
             videoUrl:videoUrl
       youtubeVideoID:youtubeVideoID
             numPosts:0
               artist:artist
                 song:song];
}

- (id)init:(NSDictionary*)item
{
    return [self init:@""
                  url:@""
                 date:@""
          description:@""
            thumbnail:@""
            artistTag:@""
             videoUrl:@""
       youtubeVideoID:@""
             numPosts:0
               artist:[item valueForKey:@"artist"]
                 song:[item valueForKey:@"song"]];
}

@end