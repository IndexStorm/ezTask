//
//  ViewController.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: topView.superview!.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        topView.leadingAnchor.constraint(equalTo: topView.superview!.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: topView.superview!.trailingAnchor, constant: 0).isActive = true

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }


}

