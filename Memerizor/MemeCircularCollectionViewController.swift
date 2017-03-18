//
//  MemeCircularCollectionViewController.swift
//  Memerizor
//
//  Created by Kirill Kudymov on 2017-03-07.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionViewCell"

class MemeCircularCollectionViewController: UICollectionViewController {
    
    
    // MARK: - Properties

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    // MARK: - Outlets
    
//    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.reloadData()

    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCircularCollectionViewCell
    
        // Configure the cell
        let meme = memes[indexPath.row]
        cell.memeCellImageView?.image = meme.memeImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewMemeViewController") as! ViewMemeViewController
        
        detailViewController.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
