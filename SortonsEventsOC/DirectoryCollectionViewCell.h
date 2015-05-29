//
//  DirectoryCollectionViewCell.h
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface DirectoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *cellImage;

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;

@end
