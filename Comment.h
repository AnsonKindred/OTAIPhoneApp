//
//  OTAComment.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/5/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{
    NSString* _text;
    NSString* _author;
}
@property (copy) NSString *text;
@property (copy) NSString *author;

- (id)init:(NSString*)text
       author:(NSString*)author;
@end
