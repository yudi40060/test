//
//  UZKeSongFangVC.swift
//  UZai5.2
//
//  Created by uzai on 15/6/12.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit

class UZKeSongFangVC: UZBaseVC {

    var shareURL: String!
    var shareContent: String!
    @IBOutlet weak var txtContent: UITextView!
    var service: UZHomeService!
    var imageCenter:UZBaseImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "全民优惠"
        self.view.backgroundColor=UIColor.whiteColor()
        self.loadData()
        
        let btnShare = UIButton(frame: CGRectMake(0, 0, 40, 44))
        btnShare.setImage(UIImage(named: "btn_share.png"), forState: UIControlState.Normal)
        btnShare.addTarget(self, action: #selector(self.share), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: btnShare)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func share()
    {
        self.shareWithText(self.shareContent, andImage: imageCenter == nil ? nil : imageCenter.image, andURL: self.shareURL, andGACategory:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initView(model:UZKeSongFangConfigModel)
    {
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, getAPPWdith(), getAPPHeight()-64))
        self.view.addSubview(scrollView)
        
        var y:CGFloat = 0
        let imageTop = UZBaseImageView(frame: CGRectMake(0, y, getAPPWdith(), getAPPWdith()*1/2))
        imageTop.setImageWithUrlStr(model.bannerPic, withplaceholder: nil)
        scrollView.addSubview(imageTop)
         y = imageTop.bounds.height + 30
        if model.prizePicPic != nil
        {
            imageCenter = UZBaseImageView(frame: CGRectMake(getAPPWdith()*1/4, y, getAPPWdith()/2, getAPPWdith()/2))
            imageCenter.setImageWithUrlStr(model.prizePicPic, withplaceholder: nil)
            scrollView.addSubview(imageCenter)
             y += imageCenter.bounds.height + 20
        }
        
        let txtContent = UITextView(frame: CGRectMake(20, y, getAPPWdith()-40, 10))
        txtContent.userInteractionEnabled = false
        txtContent.text = model.intro
        
        scrollView.addSubview(txtContent)
        txtContent.sizeToFit()
        y += txtContent.bounds.height + 20
 
        let btnGetCode = UIButton(frame: CGRectMake(getAPPWdith()/4, y, getAPPWdith()/2, 36))
        btnGetCode.backgroundColor = UIColor(RGBWithString: bgWithTextColor)
        btnGetCode.setTitle(model.buttonText, forState: UIControlState.Normal)
        btnGetCode.addTarget(self, action: #selector(self.onclickGetCode(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(btnGetCode)
        
        scrollView.contentSize = CGSizeMake(getAPPWdith(), y+80)
    }
    
    func loadData()
    {
        self.showLoadingWithMessage(nil)
        self.service.getKeSongFangConfig({ (model) -> Void in
            self.hideLoading()
            self.initView(model)
        }, filedBlock: { (msg, code) -> Void in
            self.hideLoading()
            self.showLoadFailedWithBlock({ () -> Void in
                self.loadData()
            })
        })
    }
    func onclickGetCode(sender: AnyObject) {
        if UZClient.shareInstance().UserID == nil
        {
            
            UZLoginNewVC.showWithController(self, success: { () -> Void in
                 self.loadQRCodeData()
            }, cancle: { () -> Void in
                
            })
        }
        else
        {
            self.loadQRCodeData()
        }
    }
    func loadQRCodeData()
    {
        self.showLoadingWithMessage(nil)
        self.service.getQRCode({ (model) -> Void in
            self.hideLoading()
            self.getCode(model)
            }, filedBlock: { (msg, code) -> Void in
                self.hideLoading()
        })
    }
    
    func getCode(model: UZQRModel)
    {
        //领取且已用 = 1,
        //领取且可用 = 2,
        //领取且过期 = 3,
        //领取成功 = 4,
        //活动已结束 = 5,
        //老用户不可领取=6
        if model.state.integerValue() == 2 || model.state.integerValue() == 4
        {
            //跳转二维码
            let ksfQRVC = UZKeSongFangQRCodeVC(nibName:"UZKeSongFangQRCodeVC",bundle:nil)
            ksfQRVC.model = model
            self.navigationController?.pushViewController(ksfQRVC, animated: true)
        }else
        {
            //跳转说明页
            let ksfExplanVC = UZKeSongFangExplainVC(nibName:"UZKeSongFangExplainVC",bundle:nil)
            ksfExplanVC.model = model
            self.navigationController?.pushViewController(ksfExplanVC, animated: true)
        }
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
