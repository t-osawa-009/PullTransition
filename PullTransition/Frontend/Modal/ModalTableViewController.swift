//
//  ModalTableViewController.swift
//  PullTransition
//
//  Created by Takuya Ohsawa on 2018/02/19.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

final class ModalTableViewController: UIViewController {
    var interactor: Interactor?
    private static let cellReuseIdentifier = "cell"
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type(of: self).cellReuseIdentifier)
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let interactor = interactor,
            let originView = sender.view else {return}
        switch originView {
        case view:
            break
        case tableView:
            if tableView.contentOffset.y > 0 {
                return
            }
        default:
            break
        }
        
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            if interactor.shouldFinish {
                interactor.finish()
            } else {
                interactor.cancel()
            }
        default: break
        }
    }
}

extension ModalTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}
