//
//  OTAPlaylistListTableCell.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/16/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistListTableCell.h"
#import "OTAPlaylistVideoViewController.h"

@implementation OTAPlaylistListTableCell
@synthesize navigationController, entry;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIButton* playAllBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        playAllBtn.frame = CGRectMake(self.frame.size.width-60, 5, 55, 35);
        playAllBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [playAllBtn setBackgroundColor:[UIColor whiteColor]];
        [playAllBtn setImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        [playAllBtn addTarget:self action:@selector(playAllClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:playAllBtn];
        // Initialization code
    }
    return self;
}

- (void) playAllClicked:(id)sender
{
    OTAPlaylistVideoViewController* playAllView = [[OTAPlaylistVideoViewController alloc] initWithNibName:@"OTAPlaylistVideoViewController" bundle:[NSBundle mainBundle]];
	playAllView.playlistEntry = entry;
	[navigationController pushViewController:playAllView animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.frame.size.width-70, self.textLabel.frame.size.height);
}

@end
