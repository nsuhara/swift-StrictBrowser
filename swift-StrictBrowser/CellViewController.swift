//
//  CellViewController.swift
//  swift-StrictBrowser
//
//  Created by nsuhara on 2018/11/19.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import UIKit

class CellViewController: UIViewController {

    var strInputUrl: String?
    
    @IBOutlet weak var objUiTextField: UITextField!
    @IBOutlet weak var objSaveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Init objects.
        self.objSaveButton.isEnabled = false
        if let strInputUrl = self.strInputUrl {
            self.objUiTextField.text = strInputUrl
            self.navigationItem.title = "編集"
        }
        self.setButtonEnabled()
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        self.setButtonEnabled()
    }
    
    private func setButtonEnabled() {
        let strInputUrl = self.objUiTextField.text ?? ""
        self.objSaveButton.isEnabled = !strInputUrl.isEmpty
    }
    
    // Process when cancel is pressed.
    @IBAction func cancel(_ sender: Any) {
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let objSaveButton = sender as? UIBarButtonItem, objSaveButton === self.objSaveButton else {
            return
        }
        // Set input data when save is pressed.
        self.strInputUrl = self.objUiTextField.text ?? ""
    }

    // Process to hide the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
