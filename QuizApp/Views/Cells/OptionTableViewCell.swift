//
//  OptionTableViewCell.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import UIKit

class OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: CustomView!
    @IBOutlet weak var optionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
