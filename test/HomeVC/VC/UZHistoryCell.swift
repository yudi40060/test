//
//  UZHistoryCell.swift
//  UZai5.2
//
//  Created by Uzai-macMini on 15/8/20.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit
typealias tapCacleButtonBlock=(tag:Int)->Void
class UZHistoryCell: UITableViewCell {
    @IBOutlet var historyLabel: UILabel!
    var tagNum:Int!
    var cacleButton=tapCacleButtonBlock?()

    @IBOutlet var cancleBu: UIButton!
    @IBAction func cacleClick(sender: UIButton) {
        let num:Int=sender.tag
        self.cacleButton!(tag:num)
        
    }
    
    func setButtonSelectIndex(index:NSIndexPath,cacleButtonBlock:tapCacleButtonBlock){
        cancleBu.tag=index.row
        self.cacleButton=cacleButtonBlock
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
