//
//  DirectoryTableViewCell.swift
//  SortonsEventsIncludedPageCell
//
//  Created by Brian Henry on 16/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import AlamofireImage

class DirectoryTableViewCell: UITableViewCell {
 
//    let placeholderImage = UIImage(named: "PagePlaceholder")!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var pageImage: UIImageView!
    
    func setDirectorySourcePage(directoryPage: Directory.TableViewCellModel) {
//        pageImage.image = placeholderImage
        nameLabel.text = directoryPage.name
        detailsLabel.text = directoryPage.details
        pageImage.af_setImage(withURL: directoryPage.imageUrl)
    }
}
