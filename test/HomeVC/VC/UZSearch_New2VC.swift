//
//  UZSearch_New2VC.swift
//  UZai5.2
//
//  Created by Uzai-macMini on 15/8/18.
//  Copyright (c) 2015年 悠哉旅游网. All rights reserved.
//

import UIKit

class UZSearch_New2VC: UZBaseVC,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PassValueDelegate,UIScrollViewDelegate,UZSearchBarDelegate{
// 控件
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var scrollerView: UIScrollView!
    var searchBar:UZSearchBar!
    var searchButton=UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width-50, 22, 50, 35))
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var tableHeightLayout: NSLayoutConstraint!
    @IBOutlet var labelViewHeightLabel: NSLayoutConstraint!
    @IBOutlet var collectionHeightLayout: NSLayoutConstraint!
// 数据处理
    var likeList:NSMutableArray!// 热门
    var historyList:NSMutableArray!// 历史
    var keyList:NSMutableArray!// 数据库中key值集合
    var service:UZHomeService!
//    var listVC:UZListPageVC!
//wp
    var resultTable:WPList!
    var resultArray:NSMutableArray!//搜索匹配关键字数组
    var searchStr:NSString!//搜索文本字符串
    var height:CGFloat!//表格高度
// block
    typealias searchSuccessBlock=(searchText:String)->Void
    var successBlock=searchSuccessBlock?()
    typealias searchFailBlock=(Void)->Void
    var failBlock=searchFailBlock?()
 // MARK::类方法
    class func showWithController(controller:UIViewController, sussecc:searchSuccessBlock, fail:searchFailBlock) {
        let vc=UZSearch_New2VC(nibName: "UZSearch_New2VC", bundle: NSBundle.mainBundle()).initWithSuccess(sussecc, fail: fail) as! UZSearch_New2VC
//        vc.GAStr = "\(controller.GAStr)->搜索页"
        let navVC=UINavigationController(rootViewController: vc)
        controller.navigationController?.presentViewController(navVC, animated: true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        // 导航栏引起的错位
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout=UIRectEdge.None
        self.sendViewNameWithName("\(self.GAStr)")
        //去掉nav底部黑线
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.initData()
        
        
    }
    
    // MARK::自定义方法
    func initWithSuccess(success:searchSuccessBlock, fail:searchFailBlock)->AnyObject{
        self.successBlock = success
        self.failBlock = fail
        return self
    }
    func initView(){
        self.collectionView.registerNib(UINib(nibName: "UZSearch_New2Cell", bundle: nil), forCellWithReuseIdentifier: "search_New2Cell")
        
        self.scrollerView.scrollEnabled=false
        self.scrollerView.delegate = self
        //添加触摸手势收起键盘
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PassValueDelegate.searchKeyListScroll))
        //加上这一句才不会影响到其余控件的点击效果
        tapGestureRecognizer.cancelsTouchesInView = false
        self.scrollerView.addGestureRecognizer(tapGestureRecognizer)
        
        //向上滑动收起键盘
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PassValueDelegate.searchKeyListScroll))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.scrollerView.addGestureRecognizer(swipeGestureRecognizer)
        
        
        // searchBar样式调整，设置
        self.searchBar=UZSearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width-60, 35))
        self.searchBar.layer.borderColor=UIColor(RGBWithString:"#AAAAAA").CGColor
        self.searchBar.placeholder="搜索想去的目的地/景点"
        self.searchBar.delegate=self
        self.searchBar.delegate1 = self
        let searchBgView=UIView(frame: CGRectMake(10, 23, UIScreen.mainScreen().bounds.size.width-60, 35))
        viewBorderRadius(searchBgView, Radius: 5, Width: 0.5, Color: UIColor(RGBWithString: "#999999"))
        
        // 取消按钮设置
        self.searchButton.setTitle("取消", forState: UIControlState.Normal)
        self.searchButton.titleLabel?.font=UIFont.systemFontOfSize(14)
        self.searchButton.setTitleColor(UIColor.init(RGBWithString: "#666666"), forState: UIControlState.Normal)
        self.searchButton.userInteractionEnabled=true
        self.searchButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
       
        // navigationBar设置
        let bigView=UIView(frame: CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width, 64))
        searchBgView.addSubview(self.searchBar)
        bigView.addSubview(searchButton)
        bigView.addSubview(searchBgView)
        self.navigationController?.navigationBar.addSubview(bigView)
        
        self.historyTableView.backgroundColor=UIColor.clearColor()
        self.historyTableView.bounces=false
        historyTableView.scrollEnabled=false
        let heardView=UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1))
        self.historyTableView.tableHeaderView=heardView
        self.historyTableView.tableFooterView=heardView
        
        
        //搜索框有内容时的关键字匹配表格
        resultTable = WPList(style: UITableViewStyle.Grouped)
        resultTable.delegate = self
        resultTable.view.hidden = true
        self.view.addSubview(resultTable.view)
        resultTable.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 0)
        
        
        UZTheadCommon.enqueueMainThreadPoolWithDelay({ () -> Void in
            self.searchBar.becomeFirstResponder()
            }, delay: 300)
    }

    //控制搜索关键字匹配列表的显示与否
    func setWPTableHidden(hidden:Bool)
    {
        if hidden
        {
            height = 0
            resultTable.view.hidden = true
        }else
        {
            resultTable.view.hidden = false
            height = self.view.frame.size.height
        }
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        resultTable.view.frame = CGRectMake(0, 0, self.view.frame.size.width, height)
        UIView.commitAnimations()
    }
    
    func initData(){
        self.likeList=NSMutableArray()
        var arr1 = NSMutableArray()
        arr1 = UZSearchPoint.QuerySearchHotCityList()
        self.likeList = NSMutableArray(array: arr1)
        
        self.historyList=NSMutableArray()
        self.keyList=NSMutableArray()
        var arr=NSMutableArray()
        arr=UZSearchPoint.QueryHistoryCityList()
        self.historyList=arr[0] as! NSMutableArray
        self.keyList=arr[1] as! NSMutableArray
        self.service=UZHomeService()
//        self.listVC=UZListPageVC()
        self.collectionView.delegate=self
        self.collectionView.dataSource=self
        self.searchBar.delegate=self
        setExtraCellLineHidden(self.historyTableView)
        self.historyTableView.delegate=self
        self.historyTableView.dataSource=self
        self.loadData()
    }
    // MARK::代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("search_New2Cell", forIndexPath: indexPath) as! UZSearch_New2Cell
        if self.likeList.count != 0{
            cell.dataSource(self.likeList, index: indexPath)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell=collectionView.cellForItemAtIndexPath(indexPath) as! UZSearch_New2Cell
        (successBlock)!(searchText: cell.LikeLabel.text!)
        self.dismiss()
        self.searchBar.resignFirstResponder()
     }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyList.count==0{
            tableHeightLayout.constant=0
            labelViewHeightLabel.constant=0
            collectionHeightLayout.constant=10+55
            return 0
        }else{
            tableHeightLayout.constant=CGFloat(historyList.count*45+2)
            labelViewHeightLabel.constant=CGFloat(historyList.count*45+2)
            collectionHeightLayout.constant=10+10+CGFloat(historyList.count*45+2)+55
                return historyList.count
            }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("historyCell") as? UZHistoryCell
        if cell==nil{
            let xibList = NSBundle.mainBundle().loadNibNamed("UZHistoryCell", owner: self, options: nil) as NSArray
            cell = xibList[0] as? UZHistoryCell
        }
        cell!.historyLabel.text=historyList[indexPath.row] as? String
        cell?.setButtonSelectIndex(indexPath, cacleButtonBlock: { (tag) -> Void in
            if tag==0{
                     self.historyList=(UZSearchPoint.QueryHistoryCityList(indexPath.row))
                self.historyTableView.reloadData()
            }
            if tag==1{
                    self.historyList=(UZSearchPoint.QueryHistoryCityList(indexPath.row))
                self.historyTableView.reloadData()
            }
        })
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let cell=tableView.cellForRowAtIndexPath(indexPath) as! UZHistoryCell
           (successBlock)!(searchText: cell.historyLabel.text!)
           self.dismiss()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    
        (successBlock)!(searchText: self.searchBar.text!)
        self.dismiss()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.scrollerView.scrollEnabled=true
    }
    
    //监听搜索框文本变化
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
        if (searchText.isEmpty || searchText=="")
        {
            self.collectionView.hidden = false
            self.historyTableView.hidden = false
            self.bgView.hidden = false
            //
            self.setWPTableHidden(true)
            
            self.searchBar.textField.rightViewMode = UITextFieldViewMode.Never
            
        }else
        {
            self.searchBar.textField.rightViewMode = UITextFieldViewMode.Always
            
            //输入文本
            self.collectionView.hidden = true
            self.historyTableView.hidden = true
            self.bgView.hidden = true
            //此处讲查询的相关数据数组赋给展示页面
            resultArray = UZSearchPoint.QueryPointList(searchBar.text)
            resultTable.resultArr = resultArray
            resultTable.updateData()
            self.setWPTableHidden(false)
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchKeyListScroll()
    }
    
    //MARK::PassValueDelegate
    func passValue(value: String!) {
        if ((value) != nil) {
            self.searchBar.text = value
            self.searchBarSearchButtonClicked(self.searchBar)
        }
        else {
            
        }
    }
    //滚动关键字列表时关闭键盘
    func searchKeyListScroll() {
        searchBar.endEditing(true)
    }
    //MARK::UZSearchBarDelegate
    func whenClearButnClicked() {
        self.collectionView.hidden = false
        self.historyTableView.hidden = false
        self.bgView.hidden = false
        //
        self.setWPTableHidden(true)
    }
    // MARK::请求数据
    func loadData(){
        self.service.searchHotWordsWithUserID(UZClient.shareInstance().UserID, withSuccessBlock: {
            (userSearchList,hotWordsList) -> Void in
            
            var hotWordsArr:NSArray!
            hotWordsArr=NSArray()
            hotWordsArr=NSArray(array: hotWordsList)
            
            if (hotWordsArr.count > 0){
                
                self.likeList.removeAllObjects()
                self.likeList=NSMutableArray(array: hotWordsArr)
                self.hideLoading()
                self.collectionView.reloadData()
                
                //首先删除本地缓存数据,再添加新数据
                UZSearchPoint.deleteSearchHotCityTable()
                for item in self.likeList
                {
                    UZSearchPoint.insertSearchHotCityList(item as! String)
                }
            }
            }) {(code, msg) -> Void in
                self.hideLoading()
        }
        
    }
    
    // MARK::Button方法
    func back(){
        self.dismiss()
    }
    func dismiss()
    {
        self.historyTableView.delegate = nil
        self.historyTableView.dataSource = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
