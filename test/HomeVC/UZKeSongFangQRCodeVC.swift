//
//  UZKeSongFangQRCodeVC.swift
//  UZai5.2
//
//  Created by uzai on 15/6/12.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit

class UZKeSongFangQRCodeVC: UZBaseVC {

    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblCode4: UILabel!
    @IBOutlet weak var lblCode3: UILabel!
    @IBOutlet weak var lblCode2: UILabel!
    @IBOutlet weak var lblCode1: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageQR: UZBaseImageView!
    var model: UZQRModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "全民优惠"
        self.imageQR.setImageWithUrlStr(model.QRCodeURL, withplaceholder: nil)
        self.imageQR.contentMode = UIViewContentMode.ScaleAspectFit
        self.lblTime.text = model.expireTime
        
        if model.assistNumber.length == 16
        {
            self.lblCode.hidden = true
            //TODO:需要调试
            let start1 = model.assistNumber.startIndex.advancedBy(0)
            let end1 = model.assistNumber.startIndex.advancedBy(4)
            let range1 = start1..<end1//Range<String.Index>(start: start1,end: end1)
            let start2 = model.assistNumber.startIndex.advancedBy(4)
            let end2 = model.assistNumber.startIndex.advancedBy(8)
            let range2 = start2..<end2//Range<String.Index>(start: start2,end: end2)
            
            let start3 = model.assistNumber.startIndex.advancedBy(8)
            let end3 = model.assistNumber.startIndex.advancedBy(12)
            let range3 = start3..<end3//Range<String.Index>(start: start3,end: end3)
            
            let start4 = model.assistNumber.startIndex.advancedBy(12)
            let end4 = model.assistNumber.startIndex.advancedBy(16)
            let range4 = start4..<end4//Range<String.Index>(start: start4,end: end4)
            
            self.lblCode1.text = model.assistNumber.substringWithRange(range1)
            self.lblCode2.text = model.assistNumber.substringWithRange(range2)
            self.lblCode3.text = model.assistNumber.substringWithRange(range3)
            self.lblCode4.text = model.assistNumber.substringWithRange(range4)
        }else
        {
            self.lblCode.text = model.assistNumber
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onclickSave(sender: AnyObject) {
        let image = Tool.screenshot()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil);
        self.showLoadingWithMessage(nil)
    }
    func image(image: UIImage, didFinishSavingWithError: NSError, contextInfo:UnsafePointer<Void>)
    {
        self.hideLoading()
//        if let error = didFinishSavingWithError as NSError? {
//            alertMessage("保存失败")
//        }
//        else{
//            //this worked do the alert thing
//            alertMessage("保存成功")
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
