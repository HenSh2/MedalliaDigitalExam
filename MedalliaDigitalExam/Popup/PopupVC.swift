//
//  PopupVC.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
    
    var action: CDAction? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAction()
    }
    
    private func setupAction() {
        guard let act = self.action else { return }
        self.titleLabel.text = act.title
        self.bodyLabel.text = act.body
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
