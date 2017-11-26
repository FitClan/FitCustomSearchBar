//
//  ViewController.swift
//  FitCustomSearchBar
//
//  Created by Cyrill on 2017/11/17.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FitCustomSearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = self.searchBar.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func initSearchBar() {
        self.navigationItem.titleView = self.searchBar
        if #available(iOS 11.0, *) {
            self.searchBar.heightAnchor.constraint(lessThanOrEqualToConstant: UIApplication.shared.statusBarFrame.size.height).isActive = true
        } else {
            
        }
    }
    
    lazy var searchBar: FitCustomSearchBar = {
        var searchBar = FitCustomSearchBar.init(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: 44.0))
        searchBar.iconImage = UIImage(named: "searchIcon")
        searchBar.backgroundColor = UIColor.clear
        searchBar.iconAlignment = .center
        searchBar.placeholder = "请输入关键字"
        searchBar.placeholderColor = UIColor.gray
        searchBar.delegate = self
        searchBar.sizeToFit()
        return searchBar
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func PrintLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
        //文件名、方法、行号、打印信息
        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息\(message)");
//        print("方法:\(methodName)  行号:\(lineNumber)\n打印信息:\(message)");
    }
    
    func searchBarShouldBeginEditing(_ searchBar: FitCustomSearchBar) -> Bool {
        PrintLog("")
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: FitCustomSearchBar) {
        PrintLog("")
    }
    
    func searchBarShouldEndEditing(_ searchBar: FitCustomSearchBar) -> Bool {
        PrintLog("")
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: FitCustomSearchBar) {
        PrintLog("")
    }

    func searchBar(_ searchBar: FitCustomSearchBar, textDidChange searchText: String) {
        PrintLog("")
    }
    
    func searchBar(_ searchBar: FitCustomSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        PrintLog("")
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: FitCustomSearchBar) {
        PrintLog("")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: FitCustomSearchBar) {
        PrintLog("")
    }
}

