//
//  AppDelegate.swift
//  OrganizationChart
//
//  Created by anilkumar thatha. venkatachalapathy on 05/10/16.
//  Copyright © 2016 Anil T V. All rights reserved.
//

import Cocoa
import SwiftyJSON
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, WebFrameLoadDelegate, NSTextFieldDelegate, NSControlTextEditingDelegate{

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayCntrl : NSArrayController!
    @IBOutlet var webView : WebView!
    
    var textChanged : Bool!
    dynamic var dataArray = [Model]()
    
    @IBAction func addButtonClicked(sender: NSButton){
        self.arrayCntrl.addObject(Model())
        DispatchQueue.main.async {
            self.tableView.scrollRowToVisible(self.dataArray.count - 1)
        }
        self.createJSFile()
    }
    
    @IBAction func deleteButtonClicked(sender: NSButton){
        if let selectedModel = self.arrayCntrl.selectedObjects.first as? Model {
            self.arrayCntrl.removeObject(selectedModel)
            self.createJSFile()
        }
    }
    
    @IBAction func loadDefaultChart(sender: NSButton){
        self.dataArray.removeAll()
        self.defaultChart()
        
    }
    func createJSFile() {
        var links: [String: [[String:String]]] = [:]
        var dict : [String: String] = [:]
        var array : [[String: String]] = []
        for model in arrayCntrl.arrangedObjects as! [Model] {
            print("\(model.Source) \(model.Destination) ")
            dict["source"] = model.Source
            dict["dest"] = model.Destination
            array.append(dict)
        }
        links = ["links":array]
        let json = JSON(links)
        let varStr = "var dependencies ="
        let str = varStr.appending(json.description)
        let url = Bundle.main
            .url(forResource: "resources/origin", withExtension: "js")
        let data = str.data(using: String.Encoding.utf8)!
        if let file = FileHandle(forWritingAtPath:(url?.path)!) {
            file.truncateFile(atOffset: 0)
            file.write(data)
            file.closeFile()
        }
        self.loadWebView()
    }

    func loadWebView() {
        let url = Bundle.main
            .url(forResource: "resources/index", withExtension: "html")
        let request = URLRequest(url: url!)
        self.webView.frameLoadDelegate = self
        self.webView.mainFrame.load(
            request
        )
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if self.textChanged == true{
            self.createJSFile()
        }
        self.textChanged = false
        
    }
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        return true
    }
    
    func textDidChange(notification: NSNotification) {
        self.textChanged = true
    }
    
    func defaultChart(){
        self.dataArray.append(Model(Source: "My Company", Destination: "CEO"))
        self.dataArray.append(Model(Source: "CEO", Destination: "VP1"))
        self.dataArray.append(Model(Source: "CEO", Destination: "VP2"))
        self.dataArray.append(Model(Source: "CEO", Destination: "VP3"))
        self.dataArray.append(Model(Source: "CEO", Destination: "VP4"))
        self.dataArray.append(Model(Source: "VP1", Destination: "Manager1"))
        self.dataArray.append(Model(Source: "VP2", Destination: "Manager2"))
        self.dataArray.append(Model(Source: "VP3", Destination: "Manager3"))
        self.dataArray.append(Model(Source: "VP4", Destination: "Manager4"))
        self.dataArray.append(Model(Source: "Manager1", Destination: "TL1"))
        self.dataArray.append(Model(Source: "Manager1", Destination: "TL2"))
        self.dataArray.append(Model(Source: "Manager2", Destination: "TL3"))
        self.dataArray.append(Model(Source: "Manager3", Destination: "TL4"))
        self.dataArray.append(Model(Source: "TL1", Destination: "EMP1"))
        self.dataArray.append(Model(Source: "TL1", Destination: "EMP2"))
        self.dataArray.append(Model(Source: "TL2", Destination: "EMP3"))
        self.dataArray.append(Model(Source: "TL2", Destination: "EMP4"))
        self.dataArray.append(Model(Source: "TL3", Destination: "EMP5"))
        self.dataArray.append(Model(Source: "TL3", Destination: "EMP6"))
        self.dataArray.append(Model(Source: "TL4", Destination: "EMP7"))
        self.dataArray.append(Model(Source: "TL4", Destination: "EMP8"))
        self.dataArray.append(Model(Source: "Manager4", Destination: "EMP9"))
        self.dataArray.append(Model(Source: "Manager4", Destination: "EMP10"))
        self.dataArray.append(Model(Source: "Manager4", Destination: "EMP11"))
        self.dataArray.append(Model(Source: "Manager4", Destination: "EMP12"))
        self.createJSFile()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.textChanged = false
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: NSNotification.Name.NSControlTextDidChange,
                                               object: nil)
        self.defaultChart()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        self.window.makeKeyAndOrderFront(self)
        return true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
