//
//  ViewMemeViewController.swift
//  Memerizor
//
//  Created by Kirill Kudymov on 2017-03-11.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

class ViewMemeViewController: UIViewController {

    // MARK: - Properties
    
    var meme: Meme?
    
    // MARK: - Outlets
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let meme = meme {
            memeImage.image = meme.memeImage
        }
        
    }

}
