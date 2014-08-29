//
// Adapted from: http://blog.jayway.com/2009/03/28/adding-sorted-inserts-to-uimutablearray/
// Adaptation copied from: http://www.raywenderlich.com/2636/how-to-make-a-simple-rss-reader-iphone-app-tutorial
//

#import <Foundation/Foundation.h>

@interface NSArray (Extras)

typedef NSInteger (^compareBlock)(id a, id b);

-(NSUInteger)indexForInsertingObject:(id)anObject sortedUsingBlock:(compareBlock)compare;

@end