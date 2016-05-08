//
//  UZCityListVC.swift
//  UzaiLYHD
//
//  Created by Uzai on 15/6/5.
//  Copyright (c) 2015年 UzaiLY. All rights reserved.
//

import UIKit

class UZCityListVC: UZBaseVC,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var heightHeaderConstraints: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchField:UITextField!
    var keyList:NSMutableArray!
    var service:UZRecommendService!
    var cityKeyValueList:NSMutableDictionary!
    var isSearchState:Bool!
    var searchList:NSMutableArray!
    var cityListData:NSMutableArray!
    var historyList:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="选择出发城市"
        initData()//初始化data
        // Do any additional setup after loading the view.
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.backgroundView=nil
        self.tableView.allowsSelection=true
        self.tableView.showsHorizontalScrollIndicator=false
        self.tableView.showsVerticalScrollIndicator=false
        self.tableView.sectionIndexColor=rgbStringColor("#e4006e")
        self.tableView.backgroundColor=rgbStringColor("#f6f6f6")
        self.tableView.sectionIndexBackgroundColor=rgbStringColor("#f6f6f6")
        self.headerView.backgroundColor=rgbStringColor("#f6f6f6")
        self.searchBar.delegate=self
        
        let viewList = self.searchBar.subviews as NSArray
        if self.searchBar.respondsToSelector(Selector("barTintColor"))
        {
            if self.service.check7_1Later()
            {
                self.searchBar.backgroundColor=rgbStringColor("#f6f6f6")
                let subView=viewList.objectAtIndex(0) as! UIView
                let subViewList=subView.subviews as NSArray
                subViewList.objectAtIndex(0).removeFromSuperview()
            }
            else
            {
                self.searchBar.barTintColor=rgbStringColor("#f6f6f6")
                self.searchBar.backgroundColor=rgbStringColor("#f6f6f6")
            }
        }
        else
        {
           viewList.objectAtIndex(0).removeFromSuperview()
            self.searchBar.backgroundColor=bgF5Color
        }
        var selectedImage:UIImage
        selectedImage = UIImage(named: "btn_productInfos_Close")!
        let leftItem = UIBarButtonItem(image: selectedImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("close"))
        self.navigationItem.setLeftBarButtonItem(leftItem)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        // 改变导航条的两个图标颜色
        self.navigationController!.navigationBar.tintColor = UIColor.yellowColor()
        //隐藏多余的线条
        setExtraCellLineHidden(self.tableView)
        self.navigationController?.navigationBar.backgroundColor=rgbStringColor("#f6f6f6")
        self.navigationController?.navigationBar.shadowImage=UIColor.clearColor().colorTransformToImage()
        //设置当前的 城市的样式
        if UZClient.shareInstance().isEquelToEmpty(UZClient.shareInstance().cityName)==false
        {
            self.currentCityLabel.attributedText=NSString.changeCityStrAttbutedTextColorWithStr("当前城市 : ", changeStr: ( UZClient.shareInstance().cityName as NSString).stringByReplacingOccurrencesOfString("市", withString: ""), colorStr: rgbStringColor("#e4006e"))
            self.activity.stopAnimating()
            self.activity.hidden=true
        }else
        {
            self.currentCityLabel.text="当前城市:"
            self.activity.startAnimating()
            let delegate=UIApplication.sharedApplication().delegate as! AppDelegate;
            delegate.service .locationByTheWay()
            delegate.service .setCurrentCityBlock({ () -> Void in
                self.currentCityLabel.attributedText=NSString.changeCityStrAttbutedTextColorWithStr("当前城市 : ", changeStr: ( UZClient.shareInstance().cityName as NSString).stringByReplacingOccurrencesOfString("市", withString: ""), colorStr: rgbStringColor("#e4006e"))
                self.activity.stopAnimating()
                self.activity.hidden=true
            })
        }
        self.headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapHeaderView")))
    }
    //单机headerView的时候
    func tapHeaderView()
    {
        var city=UZCity()
        for  city1 in UZSqliteCache.QueryCityList()
        {
            if (city1 as! UZCity).CityName == (UZClient.shareInstance().cityName as NSString).stringByReplacingOccurrencesOfString("市", withString: ""){
                city=city1 as! UZCity
            }
        }
        city.IsHistory=1;
        UZSqliteCache.UpdateIsHittoryState(city)
        UZSqliteCache.deleteStartCity()//删除出发城市
        UZSqliteCache.insertStartCity(city)//插入出发城市
        UZClient.shareInstance().city=city
        NSNotificationCenter.defaultCenter().postNotificationName(ReloadStartCityListData, object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //关闭
    func close()
    {
        self .dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    //初始化data
    func initData()
    {
        if service == nil
        {
            service = UZRecommendService();
        }
        //获取缓存的数据
        self.cityListData=UZSqliteCache.QueryCityList()
        if self.cityListData.count>0
        {
            let hotCityList=UZSqliteCache.QueryHotCityList()
            self.historyList=UZSqliteCache.QueryHistoryCityList()
            self.cityKeyValueList=self.service.valueForKeyWithDataList(self.cityListData as [AnyObject], withHotCityList: hotCityList as [AnyObject], andHistoryCityList:  self.historyList as [AnyObject])
            self.keyList=self.service.allKeysWithDataList(self.cityListData as [AnyObject], andHistoryCityList:  self.historyList as [AnyObject])
        }
        else
        {
            self.historyList=NSMutableArray()
            self.cityKeyValueList=NSMutableDictionary()
            self.keyList=NSMutableArray()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 self.loadData()
            });
        }
        self.isSearchState=false
        self.searchList=NSMutableArray()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK ::tableView DataSource 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.isSearchState==true
        {
            return 1;
        }
        return self.keyList.count;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cityListCell") as! UZCityListCell
        if self.isSearchState==true
        {
            cell.DataSource(self.searchList, tapCity1: { (city:UZCity) -> Void in
                city.IsHistory=1;
                UZSqliteCache.UpdateIsHittoryState(city)
                UZSqliteCache.deleteStartCity()//删除出发城市
                UZSqliteCache.insertStartCity(city)//插入出发城市
                UZClient.shareInstance().city=city
                self.sendEventWithName("城市切换-\(city.CityName)", andScreenName: "选择出发城市")
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadStartCityListData, object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        else
        {
            let valueList:NSArray =  self.cityKeyValueList.objectForKey(self.keyList[indexPath.section]) as! NSArray
            cell.DataSource(valueList, tapCity1: { (city) -> Void in
                city.IsHistory=1;
                UZSqliteCache.UpdateIsHittoryState(city)
                UZSqliteCache.deleteStartCity()//删除出发城市
                UZSqliteCache.insertStartCity(city)//插入出发城市
                UZClient.shareInstance().city=city
                self.sendEventWithName("城市切换-\(city.CityName)", andScreenName: "选择出发城市")
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadStartCityListData, object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        cell.backgroundColor=UIColor(RGBWithString: "#f6f6f6")
        return cell
      
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.isSearchState==true{
            return UZCityListCell.heightForRow(self.searchList)
        }
        else
         {
            let valueList:NSArray =  self.cityKeyValueList.objectForKey(self.keyList[indexPath.section]) as! NSArray
            return UZCityListCell.heightForRow(valueList)
        }
    }
    //索引
     func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        if self.isSearchState==true
        {
            return nil
        }
       
        return  NSArray(array: self.keyList) as? [String]
    }
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        tableView .scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: UITableViewScrollPosition.Top, animated: true);
        return index;
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerView=UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        let label=UILabel(frame: CGRectMake(20, 0, headerView.frame.size.width-40, headerView.frame.size.height))
        headerView.backgroundColor=rgbStringColor("#f0eff5")
        label.textColor=bg33Color
        label.backgroundColor=UIColor.clearColor()
        if self.isSearchState==true{
             if self.searchList.count>0{
                label.text="搜索结果"
                headerView.hidden=false
            }else{
                headerView.hidden=true
            }
        }
        else{
            if self.keyList.objectAtIndex(section) as! String == "历史"
            {
                label.text="历史选择"
            }
            else if self.keyList.objectAtIndex(section)  as! String == "热门"
            {
                 label.text="热门出发城市"
            }
            else
            {
                 label.text=self.keyList.objectAtIndex(section) as? String
            }
        }
        label.font=UIFont(name: "Heiti SC", size: 16.0)
        headerView .addSubview(label)
        return headerView
    }
    func  tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //MARK:: searchBar的delegate的代理
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        UIView.animateWithDuration(0.45, animations: { () -> Void in
            self.heightHeaderConstraints.constant=0
             self.headerView.hidden=true
        })
        self.isSearchState=true
         searchBar .setShowsCancelButton(true, animated: true)
        self.tableView.reloadData()
        return true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.isSearchState=false
        self.searchBar.text=""
        searchBar .setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.tableView.reloadData()//刷新数据
    }
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let searchText="\(searchBar.text!)\(text)"
        self.searchList=NSMutableArray(array: self.service.searchDataList(searchText, withDataList: self.cityListData) as [AnyObject])
        UIView.animateWithDuration(0.45, animations: { () -> Void in
            self.heightHeaderConstraints.constant=0
            self.headerView.hidden=true
        })
        self.isSearchState=true
        self.tableView .reloadData()
        return true
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
       let text=searchBar.text!
        self.searchList=NSMutableArray(array: self.service.searchDataList(text, withDataList: self.cityListData) as [AnyObject])
        UIView.animateWithDuration(0.45, animations: { () -> Void in
            self.heightHeaderConstraints.constant=0
            self.headerView.hidden=true
        })
        self.isSearchState=true
        self.tableView .reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let text=searchBar.text!
        self.searchList=NSMutableArray(array: self.service.searchDataList(text, withDataList: self.cityListData) as [AnyObject])
        self.isSearchState=true
        self.tableView .reloadData()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.isSearchState=false
        UIView.animateWithDuration(0.45, animations: { () -> Void in
            self.heightHeaderConstraints.constant=40
            self.headerView.hidden=false
        })
        tableView.reloadData()
    }
    /**
    加载数据
    */
    func  loadData()
    {
        self .showLoadingWithMessage("")
        self.service .CityListSuccessBlock({ (cityList, hotDataList) -> Void in
            self.hideLoading()
            self.cityListData=NSMutableArray(array: cityList as [AnyObject])
            self.cityKeyValueList = self.service.valueForKeyWithDataList(cityList  as [AnyObject], withHotCityList: hotDataList as [AnyObject], andHistoryCityList: self.historyList as [AnyObject])
            self.keyList=self.service.allKeysWithDataList(cityList  as [AnyObject], andHistoryCityList: self.historyList as [AnyObject])
            self.tableView.reloadData();//刷新数据
        }, withFiledBlock: { (code, msg) -> Void in
              self.hideLoading()
        })
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
