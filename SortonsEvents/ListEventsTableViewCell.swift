//
//  DiscoveredEventTableViewCell.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import UIKit
import AlamofireImage

class ListEventsTableViewCell: UITableViewCell {

    let placeholderImage = UIImage(named: "EventPlaceholder")

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!

    func setDiscoveredEvent(_ event: ListEventsCellViewModel) {
        eventImage.image = placeholderImage
        nameLabel.text = event.name
        startTimeLabel.text = event.startTime
        locationLabel.text = event.location
        if let imageUrl = event.imageUrl {
            eventImage.af_setImage(withURL: imageUrl)
        }
    }
}
