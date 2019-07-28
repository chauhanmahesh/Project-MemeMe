//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Mahesh Chauhan on 24/7/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeTableViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        // Set the image
        cell.memeText?.text = meme.topText + " " + meme.bottomText
        cell.memeImage?.image = meme.memeImage
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memeDetailViewSegue" {
            let memeDetailViewController = segue.destination as! MemeDetailViewController
            memeDetailViewController.memeToDisplay = memes[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}
