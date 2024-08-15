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
    
    var correctAnswerKey: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        resetState()  
    }
    
    func resetState() {
        cellView.backgroundColor = .clear
    }
    
    func setSelectedState(isCorrect: Bool) {
        cellView.backgroundColor = isCorrect ? UIColor(rgb: 0xCBFCCB) : UIColor(rgb: 0xFF0000)
    }
    
    func highlightAsCorrect() {
        cellView.backgroundColor = UIColor(rgb: 0xCBFCCB)
    }
}
