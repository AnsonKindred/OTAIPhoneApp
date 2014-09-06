#import "Entry.h"

@implementation Entry

@synthesize ID = _ID;

- (id)init:(NSDictionary*)item
{
    if(self = [super init])
    {
        _ID = [[item objectForKey:@"id"] intValue];
    }
    
    return self;
}

@end
