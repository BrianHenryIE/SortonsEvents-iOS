//
//  InludedPageCell.h
//  Belfield
//
//  Created by Brian Henry on 13/07/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncludedPageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@end
