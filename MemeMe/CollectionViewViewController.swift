//
//  CollectionViewViewController.swift
//  MemeMe
//
//  Created by nF ™ on 26/05/2020.
//  Copyright © 2020 nF ™. All rights reserved.
//

import UIKit

class CollectionViewViewController: UICollectionViewController {

    var memes = [Meme]()
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cellsetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.getMems()
        collectionView.reloadData()
    }
    
    // MARK: CollectionView SETUP
    func cellsetup() {
        let space:CGFloat = 7.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.MemeImage.image = meme.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowMeme") as! ShowMemeViewController
        vc.meme = meme
        navigationController?.pushViewController(vc, animated: true)
        
    }


}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var MemeImage: UIImageView!
    
}
