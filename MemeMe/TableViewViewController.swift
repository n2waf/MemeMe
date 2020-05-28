//
//  TableViewViewController.swift
//  MemeMe
//
//  Created by nF ™ on 26/05/2020.
//  Copyright © 2020 nF ™. All rights reserved.
//

import UIKit

class TableViewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var memes = [Meme]()
    @IBOutlet weak var memsTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: tableView SETUP
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + meme.bottomText
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowMeme") as! ShowMemeViewController
        vc.meme = meme
        navigationController?.pushViewController(vc, animated: true)
    }
    

   
    
}


// MARK: Delegate Extension : for Reload tableView
extension TableViewViewController: CreateMemeDelegate {
    func didAddmeme() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.getMems()
        self.memsTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateMeme" {
            let vc = segue.destination as! CreateMeme
            vc.del = self
        }
    }
}
