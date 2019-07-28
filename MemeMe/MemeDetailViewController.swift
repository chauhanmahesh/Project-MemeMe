//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mahesh Chauhan on 28/7/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeView: UIImageView!
    
    var memeToDisplay: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeView.image = memeToDisplay.memeImage
    }
    
}
