//
//  ContentViewController.swift
//  XdagWallet
//
//  Created by 张晓亮 on 2018/10/7.
//  Copyright © 2018 张晓亮. All rights reserved.
//

import Cocoa

class ContentViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    // TODO: Create a local wallet if it doesn't exsit.
    func walletInit() {
        
    }
    
    // TODO: Refresh wallet status every time application is launched.
    func walletRefresh() {
        
    }
}
