//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchBar: UISearchBar = UISearchBar()
    
    var searching = false
    var isMoreDataLoading = false
    var loadingMoreView : InfiniteScrollActivityView?
    
    var defaultSearch = "Food"
    var currentTotal = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 120
        
        searchBar.delegate = self;
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 203/255.0, green: 49/255.0, blue: 8/255.0, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        search(defaultSearch)
    }
    
    func search(term: String)
    {
        currentTotal = 15
        Business.searchWithTerm(term, sort: YelpSortMode.Distance, categories: nil, deals:nil, limit: currentTotal, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if let businesses = businesses{
                self.businesses = businesses
                self.tableView.reloadData()
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            } else {
                let alertController = UIAlertController(title: "Whoops!", message: "Nothing came up!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated:true, completion: nil)
            }
        })
    }
    
    func loadMoreData(){
        currentTotal += 15
        Business.searchWithTerm(defaultSearch, sort:YelpSortMode.Distance , categories: nil, deals: nil,limit: currentTotal) {  (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses == nil){
                if !self.searchBar.text!.isEmpty {
                    self.search(self.searchBar.text!)
                }else{
                    self.search(self.defaultSearch)
                }
            }else {
                self.businesses = businesses
                self.tableView.reloadData()
            }
            self.loadingMoreView!.stopAnimating()
            self.isMoreDataLoading = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if businesses != nil{
            return businesses!.count
        } else {
            return 0
        }
    }
    
//    func search(s:String){
//        let currentLimit = 10;
//        Business.searchWithTerm(s, sort:YelpSortMode.Distance , categories: nil, deals: nil,location: myLocation.getCurrentLocationAsString(),limit: currentLimit) {  (businesses: [Business]!, error: NSError!) -> Void in
//            if (businesses.count == 0 || error != nil){
//                self.view.bringSubviewToFront(self.errorView)
//            }else {
//                self.businesses = businesses
//                self.view.sendSubviewToBack(self.errorView)
//                self.tableView.reloadData()
//                self.userData.setObject(s, forKey: "recentSearch")
//                self.userData.synchronize()
//                self.defaultSearch = s
//            }
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    @IBAction func SearchPressed(sender: AnyObject) {
        if searching == false {
            print("I'm here")
            //searchBar.setValue("Done", forKey:"_cancelButtonText")
            navigationItem.titleView = searchBar
            searching = true
            searchBar.becomeFirstResponder()
            searchButton.setTitle("Cancel", forState: .Normal)
        }
        else {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            navigationItem.titleView = nil
            searching = false
            searchBar.resignFirstResponder()
            searchButton.setTitle("Search", forState: .Normal)
        }
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        navigationItem.titleView = nil
        searching = false;
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        tableView.setContentOffset(CGPointZero, animated:true)
        search(searchBar.text!)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                loadMoreData()
            }
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
