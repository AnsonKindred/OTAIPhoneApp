#import <Foundation/Foundation.h>
#import "Entry.h"

@interface EntrySession : Entry {
    NSInteger _artistID;
    NSInteger _count;
    NSString *_song;
    NSString *_artist;
}

@property NSInteger artistID;
@property NSInteger count;
@property (copy) NSString *song;
@property (copy) NSString *artist;

@end