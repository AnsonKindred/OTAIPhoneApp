//
// Adapted from: http://blog.jayway.com/2009/03/28/adding-sorted-inserts-to-uimutablearray/
// Adaptation copied from: http://www.raywenderlich.com/2636/how-to-make-a-simple-rss-reader-iphone-app-tutorial
//

#import "NSArray+Extras.h"

@implementation NSArray (Extras)

-(NSUInteger)indexForInsertingObject:(id)anObject sortedUsingBlock:(compareBlock)compare {
    NSUInteger index = 0;
    NSUInteger topIndex = [self count];
    while (index < topIndex) {
        NSUInteger midIndex = (index + topIndex) / 2;
        id testObject = [self objectAtIndex:midIndex];
        if (compare(anObject, testObject) < 0) {
            index = midIndex + 1;
        } else {
            topIndex = midIndex;
        }
    }
    return index;
}

@end