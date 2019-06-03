//
//  MainVC.swift
//      
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainBtn: UIButton!
    
    private var viewModel: MainVCVM = MainVCVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestActions()
    }
    
    private func requestActions() {
        self.startLoad()
        self.viewModel.requestActions { [weak self] (actions, error) in
            self?.mainBtn.isEnabled = true
            self?.indicator.stopAnimating()
            if error {
                self?.handleError()
                return
            }
            self?.mainLabel.text = "Action"
        }
    }
    
    private func startLoad() {
        self.mainBtn.isEnabled = false
        self.indicator.startAnimating()
        self.mainLabel.text = "Loading"
    }
    
    private func handleError() {
        self.mainLabel.text = "Try again"
    }
    
    @IBAction func mainAction(_ sender: UIButton) {
        if self.viewModel.isActionsAvailable {
            self.showAction()
        } else {
            self.requestActions()
        }
    }
    
    private func showAction() {
        guard let actionToShow = self.viewModel.actionToShow else {
            print("No action available at this moment")
            return
        }
        CDService.updateTrigger(actionToShow)
        guard let type = ActionType(rawValue: actionToShow.type ?? "") else { return }
        switch type {
        case .alert, .alertSheet:
            let alertController = UIAlertController(title: actionToShow.title ?? "", message: actionToShow.body ?? "", preferredStyle: type == .alert ? .alert : .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        case .screen:
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
            popupVC.action = actionToShow
            self.present(popupVC, animated: true, completion: nil)
        case .undefined:
            print("undefined action")
        }
    }
    

}

