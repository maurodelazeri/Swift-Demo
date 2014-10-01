//
//  ViewController.swift
//  Swift Demo
//
//  Created by macbook on 14-10-1.
//  Copyright (c) 2014年 wjw. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,NeoKrNewsParserDelegate,UITableViewDataSource,UITableViewDelegate {
    var tempQueue=NSOperationQueue()
    var krFeedurl="http://www.36kr.com/feed/";
    var newList:NSMutableArray=NSMutableArray()
    var krPr:NeoKrNewsParser = NeoKrNewsParser()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
         loadNewDataSource()
        

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        tableView.separatorInset=UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    func loadNewDataSource(){
     var newsURL = NSURL(string: krFeedurl)
      var request = NSURLRequest(URL: newsURL)
        var loadDataQueue: NSOperationQueue = NSOperationQueue()
     //   response, data, error
        NSURLConnection.sendAsynchronousRequest(request, queue: loadDataQueue) { (response, data, error) -> Void in
            if error != nil
            {
            
            } else {
                self.krPr.delegate=self
                
                self.krPr.parserKrNewsData(data)
            }
        }
    }
    func NeoKrNewsParserFinished(list: NSMutableArray!, success: Bool) {
        self.newList=list
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView .reloadData()
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newList.count > 0 ? self.newList.count : 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as UITableViewCell
        var model = self.newList.objectAtIndex(indexPath.row) as NeoKrNewsModel
        cell.textLabel?.text = model.title
       
       // var model = self.newsList.objectAtIndex(indexPath.row) as NeoKrNewsModel
       // cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = "作者:" + model.author + "   " + model.date
        // var cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }


}

