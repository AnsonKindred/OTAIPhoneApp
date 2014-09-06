#import <Foundation/Foundation.h>
#import "Entry.h"

@interface EntryGenre : Entry {
    NSInteger _count;
    NSString *_title;
}

@property NSInteger count;
@property (copy) NSString *title;

@end