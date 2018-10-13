//
//  PreferencesViewController.swift
//  XdagWallet
//
//  Created by 张晓亮 on 2018/10/12.
//  Copyright © 2018 张晓亮. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the size for each views
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title with the active TabView Title
        self.parent?.view.window?.title = self.title!
    }
    
}
