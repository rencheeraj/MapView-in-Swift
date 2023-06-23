//
//  MapOverlayCollectionViewCell.swift
//  MapViewSwift
//
//  Created by Sachin George on 22/06/23.
//

import UIKit

class MapOverlayCollectionViewCell : UICollectionViewCell{
    static let identifier = "MapOverlayCollectionViewCell"
    public let nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.clipsToBounds = true
        nameLabel.contentMode = .scaleAspectFill
        return nameLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = contentView.bounds
    }
}
