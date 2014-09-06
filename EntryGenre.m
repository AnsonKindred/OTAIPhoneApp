#import "EntryGenre.h"

@implementation EntryGenre

@synthesize title = _title;
@synthesize count = _count;

- (id)init:(NSDictionary*)item
{
    if ((self = [super init:item])) {
        _ID = [[item objectForKey:@"id"] intValue];
        _title = [item objectForKey:@"category"];
        _count = [[item objectForKey:@"count"] intValue];
    }
    return self;
}

@end