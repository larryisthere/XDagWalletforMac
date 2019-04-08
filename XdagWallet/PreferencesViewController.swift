//
//  PreferencesViewController.swift
//  XdagWallet
//
//  Created by 张晓亮 on 2018/10/12.
//  Copyright © 2018 张晓亮. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    var poolList = [String]()

    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the size for each views
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        self.requestPoolList()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title with the active TabView Title
        self.parent?.view.window?.title = self.title!
        
        tableView.reloadData()
    }
    
    func requestPoolList() {
        let url = URL(string: "https://raw.githubusercontent.com/XDagger/xdag/master/client/pools.txt")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //            if let error = error {
            //                return
            //            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let mimeType = httpResponse.mimeType, let data = data, let string = String(data: data, encoding: .utf8), mimeType == "text/plain" {
                self.poolList = string.components(separatedBy: "\n")
            }
        }
        task.resume()
    }
    
    func saveSelectedPoolAddressWithCoreData(address: String) {
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Pool", in: managedContext)
        let entityAddress = NSManagedObject(entity: entity!, insertInto: managedContext)
        entityAddress.setValue(address, forKeyPath: "address")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension PreferencesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.poolList.count
    }
}

extension PreferencesViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let AddressCell = "AddressCellID"
        static let LocationCell = "LocationCellID"
        static let statusCell = "StatusCellID"
        static let rates = "RatesCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn != tableView.tableColumns[1] {
            return nil
        }
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.AddressCell), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = self.poolList[row]
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        let selectedRow = table.selectedRow
        let contentView = table.view(atColumn: 1, row: selectedRow, makeIfNecessary: false) as! NSTableCellView
        let address = contentView.textField!.objectValue! as! String
        self.saveSelectedPoolAddressWithCoreData(address: address)
    }   

}
