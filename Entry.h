@interface Entry : NSObject
{
    NSInteger _ID;
}

@property NSInteger ID;

- (id)init:(NSDictionary*)item;

@end