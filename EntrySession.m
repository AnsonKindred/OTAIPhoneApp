#import "EntrySession.h"

@implementation EntrySession
@synthesize song = _song;
@synthesize artist = _artist;
@synthesize artistID = _artistID;
@synthesize videoID = _videoID;
@synthesize count = _count;

- (id)init:(NSDictionary*)item
{
    if ((self = [super init:item])) {
        int artistID = [[item objectForKey:@"artistID"] intValue];
        _artistID = artistID;
        _song = [item objectForKey:@"song"];
        _artist = [item objectForKey:@"artist"];
        _videoID = [item objectForKey:@"videoID"];
        int count = [[item objectForKey:@"count"] intValue];
        _count = count;
    }
    return self;
}

@end