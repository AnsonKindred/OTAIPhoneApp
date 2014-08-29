#import <Foundation/Foundation.h>

@interface OTARSSEntry : NSObject {
    NSString *_title;
    NSString *_url;
    NSString *_date;
	NSString *_description;
	NSString *_thumbnail;
    NSString *_artistTag;
    NSString *_videoUrl;
    NSString *_youtubeVideoID;
    NSInteger _numPosts;
    NSString *_artist;
    NSString *_song;
}

@property (copy) NSString *title;
@property (copy) NSString *url;
@property (copy) NSString *date;
@property (copy) NSString *description;
@property (copy) NSString *thumbnail;
@property (copy) NSString *artistTag;
@property (copy) NSString *videoUrl;
@property (copy) NSString *youtubeVideoID;
@property NSInteger numPosts;
@property (copy) NSString *artist;
@property (copy) NSString *song;

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
      song:(NSString*)song;

- (id)init:(NSString*)title
      song:(NSString*)song
  videoUrl:(NSString*)videoUrl
youtubeVideoID:(NSString*)youtubeVideoID;

- (id)init:(NSDictionary*)item;

@end