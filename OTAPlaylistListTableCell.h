//
//  OTAPlaylistListTableCell.h
//  Off The Ave
//
//  Created by Zeb Long on 2/16/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryGenre.h"

@interface OTAPlaylistListTableCell : UITableViewCell
{
    UINavigationController* navigationController;
    
    EntryGenre* entry;
}
- (void) playAllClicked:(id)sender;
@property (strong) UINavigationController* navigationController;
@property (strong) EntryGenre* entry;

@end
