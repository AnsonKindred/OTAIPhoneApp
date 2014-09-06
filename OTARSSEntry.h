#import <Foundation/Foundation.h>

@interface OTARSSEntry : NSObject {
    NSInteger _ID;
    NSInteger _artistID;
    NSInteger _count;
    NSString *_song;
    NSString *_artist;
}

@property NSInteger ID;
@property NSInteger artistID;
@property NSInteger count;
@property (copy) NSString *song;
@property (copy) NSString *artist;

- (id)init:(NSDictionary*)item;

@end