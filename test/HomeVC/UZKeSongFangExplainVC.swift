//
//  UZKeSongFangExplainVC.swift
//  UZai5.2
//
//  Created by uzai on 15/6/17.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit

class UZKeSongFangExplainVC: UZBaseVC {
    @IBOutlet weak var imageViewExplain: UZBaseImageView!
    @IBOutlet weak var btnNext: UIButton!
    var model: UZQRModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "全民优惠"
        self.imageViewExplain.setImageWithUrlStr(model.coverUrl, withplaceholder: nil)
        self.btnNext.setTitle(model.buttonText, forState: UIControlState.Normal)
        if model.state.integerValue() == 3 || model.state.integerValue() == 5 || model.state.integerValue() == 7
        {
            self.view.backgroundColor = UIColor(RGBWithString:"#f2f2f2")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onclickNext(sender: AnyObject) {
        let productService:UZProductService = UZProductService()
        let webVC = UZHomeActivityVC(productService: productService)
        productService.infoStr = self.model.buttonLink
        webVC.title = "全民优惠"
        self.navigationController?.pushViewController(webVC, animated: true)
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
