#import <Foundation/Foundation.h>

@interface OTARSSEntry : NSObject {
    NSInteger _ID;
    NSInteger _artistID;
    NSInteger _numPosts;
    NSString *_title;
    NSString *_subTitle;
}

@property NSInteger ID;
@property NSInteger artistID;
@property NSInteger numPosts;
@property (copy) NSString *title;
@property (copy) NSString *subTitle;

- (id)init:(NSDictionary*)item;

@end