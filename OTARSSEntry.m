#import "OTARSSEntry.h"

@implementation OTARSSEntry
@synthesize song = _song;
@synthesize artist = _artist;
@synthesize ID = _ID;
@synthesize artistID = _artistID;
@synthesize count = _count;

- (id)init:(NSDictionary*)item
{
    if ((self = [super init])) {
        _ID = [[item objectForKey:@"id"] intValue];
        int artistID = [[item objectForKey:@"artistID"] intValue];
        _artistID = artistID;
        _song = [item objectForKey:@"song"];
        _artist = [item objectForKey:@"artist"];
        int count = [[item objectForKey:@"count"] intValue];
        _count = count;
    }
    return self;
}

@end