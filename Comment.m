//
//  OTAComment.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/5/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize text = _text;
@synthesize author = _author;
- (id)init:(NSString*)text
       author:(NSString*)author
{
    if ((self = [super init]))
    {
        _text = [text copy];
        _author = [author copy];
    }
    return self;
}
@end
