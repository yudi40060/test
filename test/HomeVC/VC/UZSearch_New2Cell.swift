//
//  UZSearch_New2Cell.swift
//  UZai5.2
//
//  Created by Uzai-macMini on 15/8/18.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit

class UZSearch_New2Cell: UICollectionViewCell {

    @IBOutlet var likeLabelWidthLayout: NSLayoutConstraint!
    @IBOutlet var LikeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBorderRadius(LikeLabel, Radius: 20, Width: 0.8, Color: UIColor(RGBWithString: "#d9d9d9"))
        LikeLabel.backgroundColor=UIColor.whiteColor()
    }
    
    func dataSource(dataList:NSMutableArray,index:NSIndexPath){
        if dataList.count != 0{
//            var hotDetail:UZHotPoint5_3!
//            hotDetail=dataList[index.row] as! UZHotPoint5_3
//            LikeLabel.text=hotDetail.keyWord
//            var size:CGSize!
//            size=hotDetail.keyWord.sizeofWithFont(LikeLabel.font, size: CGSize(width: 1000, height: 10000))
            var hotWordStr:NSString!
            hotWordStr = dataList[index.row] as! NSString
            LikeLabel.text=hotWordStr! as String
            var size:CGSize!
            size = hotWordStr.sizeofWithFont(LikeLabel.font, size: CGSize(width: 1000, height: 10000))
            if size.width+20<80{
                likeLabelWidthLayout.constant=80
            }
            else{
                if size.width+20>130{
                    likeLabelWidthLayout.constant=130
                }
                likeLabelWidthLayout.constant=size.width+20
            }
        }
    }
}
