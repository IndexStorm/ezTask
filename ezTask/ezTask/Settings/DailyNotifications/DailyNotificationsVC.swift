//
//  DailyNotificationsVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 20.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit
import PinLayout

class DailyNotificationsVC: UIViewController {

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 20

        return view
    }()
    
    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.text = "Daily Notifications"

        return lbl
    }()
    
    let morning: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.text = "Morning"

        return lbl
    }()
    
    let evening: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.text = "Evening"

        return lbl
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("label.done".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 3
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonPressed() {
        dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        setup()
    }
    
    func setup() {
        self.view.addSubview(container)
        container.pin.horizontally().height(self.view.frame.size.height / 1.5).bottom()
        
        container.addSubview(topLabel)
        topLabel.pin.hCenter().top(20).sizeToFit()
        
        container.addSubview(morning)
        morning.pin.left(36).below(of: topLabel).marginTop(30).sizeToFit()
        
        container.addSubview(evening)
        evening.pin.left(36).below(of: morning).marginTop(30).sizeToFit()
        
        container.addSubview(button)
        button.pin.bottom(100).hCenter().width(250).height(50)
    }

}
