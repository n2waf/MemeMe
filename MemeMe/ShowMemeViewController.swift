//
//  ShowMemeViewController.swift
//  MemeMe
//
//  Created by nF ™ on 28/05/2020.
//  Copyright © 2020 nF ™. All rights reserved.
//

import UIKit

class ShowMemeViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImage.image = meme.memedImage
    }

}
