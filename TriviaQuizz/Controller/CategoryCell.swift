//
//  CategoryCell.swift
//  TriviaQuizz
//
//  Created by God on 25/8/24.
//

import UIKit
import SDWebImage

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(imageURL: String, category: String) {
        if let imageURL = URL(string: imageURL){
            categoryImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            categoryImage.sd_imageIndicator?.startAnimatingIndicator()
            categoryImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "empty-image"), options: .continueInBackground, completed: nil)
            categoryImage.contentMode = .scaleToFill
            categoryName.font = UIFont(name: "Blueberry-Regular", size: 20)
            categoryName.text = category
        } else {
            print("Invalid URL")
            categoryImage.image = UIImage(named: "empty-image")
        }
    }

}
