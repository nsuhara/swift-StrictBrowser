//
//  ListTableViewController.swift
//  swift-StrictBrowser
//
//  Created by nsuhara on 2018/11/19.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var objUserDefaults = UserDefaults.standard
    var lstAllowedUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load list data.
        if self.objUserDefaults.object(forKey: "com.nsuhara.swift-StrictBrowser") != nil {
            self.lstAllowedUrls = self.objUserDefaults.stringArray(forKey: "com.nsuhara.swift-StrictBrowser")!
        } else {
            self.lstAllowedUrls = [
                "about:blank",
                ".*google.*",
                ".*yahoo.*"
            ]
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // Return from CellViewController.
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        // Check from where to return.
        guard let objCellVC = sender.source as? CellViewController, let strInputUrl = objCellVC.strInputUrl else {
            return
        }
        // Set input data.
        if let objSelectedIndex = self.tableView.indexPathForSelectedRow {
            self.lstAllowedUrls[objSelectedIndex.row] = strInputUrl
        } else {
            self.lstAllowedUrls.append(strInputUrl)
        }
        // Save list data and reload.
        self.objUserDefaults.set(self.lstAllowedUrls, forKey: "com.nsuhara.swift-StrictBrowser")
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.lstAllowedUrls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierTableView", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = self.lstAllowedUrls[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete list data.
            self.lstAllowedUrls.remove(at: indexPath.row)
            // Save list data.
            self.objUserDefaults.set(self.lstAllowedUrls, forKey: "com.nsuhara.swift-StrictBrowser")
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {
            return
        }
        // Prepare for moving to edit.
        if identifier == "identifierEditCell" {
            let objCellVC = segue.destination as! CellViewController
            objCellVC.strInputUrl = self.lstAllowedUrls[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
        
    // Process when done is pressed.
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
