//
//  RubbishCell.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 15/09/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit

class RubbishCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    // 1
    var isInEditingMode: Bool = false {
        didSet {
            checkMarkLabel.isHidden = !isInEditingMode
        }
    }

    // 2
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkMarkLabel.text = isSelected ? "✓" : ""
            }
        }
    }
}
