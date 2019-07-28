//
//  Test.swift
//  MemeMe
//
//  Created by Mahesh Chauhan on 27/7/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class Test: UIViewController {
    
    @IBAction func launchMemeCreation() {
        let controller: CreateMemeEditorViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeEditorViewController
        present(controller, animated: true, completion: nil)
    }
    
}
