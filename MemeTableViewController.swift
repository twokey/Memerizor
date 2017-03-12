//
//  MemeTableViewController.swift
//  Memerizor
//
//  Created by Kirill Kudymov on 2017-03-07.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView?.reloadData()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MemeTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath) as! MemeTableViewCell

        let meme = memes[indexPath.row]
        // Configure the cell...
        cell.memeImageView.image = meme.memeImage
        cell.topTextLabel.text = meme.topTextFieldText
        cell.bottomTextLabel.text = meme.bottomTextFieldText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewMemeViewController") as! ViewMemeViewController
        
        detailViewController.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
 
}
