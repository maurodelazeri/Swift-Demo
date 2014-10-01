//
//  NeoKrNewsParser.swift
//  Swift Demo
//
//  Created by macbook on 14-10-1.
//  Copyright (c) 2014年 wjw. All rights reserved.
//

import UIKit
protocol NeoKrNewsParserDelegate{
    func NeoKrNewsParserFinished(list:NSMutableArray!,success:Bool)->Void
}
class NeoKrNewsParser: NSObject, NSXMLParserDelegate {
    var newsList: NSMutableArray?
    var model: NeoKrNewsModel?
    var delegate: NeoKrNewsParserDelegate?
    var tempString: String?
    
    func parserKrNewsData(data: NSData) -> Void{
        //        var xml: String = NSString(data: data, encoding: 4)
        //        print("==========" + xml)
        //xml解析
        
        let xmlParser: NSXMLParser = NSXMLParser(data: data)
        //设置一下属性不然xml解析会崩溃,参考http://stackoverflow.com/questions/24468338/how-do-you-make-a-rss-reader-using-swift
        xmlParser.shouldResolveExternalEntities = true
        xmlParser.shouldProcessNamespaces = true
        xmlParser.shouldReportNamespacePrefixes = true
        xmlParser.shouldResolveExternalEntities = true
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String, qualifiedName qName: String, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "channel"{
            newsList = NSMutableArray()
        }else if elementName == "item"{
            model = NeoKrNewsModel()
        }else if elementName == "img" {
            //获取标签里的属性
            print("attributeDict",attributeDict)
            model?.imgUrl = (attributeDict as NSDictionary).objectForKey("src") as String
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        println(string)
        
        if tempString == nil{
            tempString = ""
        }
        tempString = string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String, qualifiedName qName: String) {
        if elementName == "title"{
            model?.title = tempString;
        }else if elementName == "author"{
            model?.author = tempString
        }else if elementName == "pubDate"{
            model?.date = tempString
        }else if elementName == "link"{
            model?.detailUrl = tempString
        }else if elementName == "item"{
            newsList!.addObject(model!)
        }
    }
    
    func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {
        self.delegate?.NeoKrNewsParserFinished(self.newsList, success: true)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        println(parseError)
    }
    
}

