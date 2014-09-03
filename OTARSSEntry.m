#import "OTARSSEntry.h"

@implementation OTARSSEntry
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize ID = _ID;
@synthesize artistID = _artistID;
@synthesize numPosts = _numPosts;

- (id)init:(NSDictionary*)item
{
    if ((self = [super init])) {
        _ID = [[item objectForKey:@"id"] intValue];
        int artistID = [[item objectForKey:@"artistID"] intValue];
        _artistID = artistID;
        _title = [item objectForKey:@"song"];
        _subTitle = [item objectForKey:@"artist"];
    }
    return self;
}

@end