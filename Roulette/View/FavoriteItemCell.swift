//
//  FavoriteItemCell.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/08/07.
//

import UIKit

class FavoriteItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        // AutoLayout
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setValue(indexPath:IndexPath, rouletteItemDataSet: RouletteItemDataSet) {
        self.titleLabel.text = rouletteItemDataSet.title
    }
    
}
