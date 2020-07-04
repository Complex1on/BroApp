//
//  HomeViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/4/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func friendsButtonPushed(_ sender: UIButton) {
    }
    @IBAction func friendRequestButtonPushed(_ sender: UIButton) {
    }
    @IBAction func messagesButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: K.homeChatSegue, sender: self)
    }
}
