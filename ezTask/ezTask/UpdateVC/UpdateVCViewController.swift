//
//  UpdateVCViewController.swift
//  ezTask
//
//  Created by Mike Ovyan on 20.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import PinLayout
import UIKit

class UpdateVC: UIViewController {
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 20

        return view
    }()

    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lbl.text = "What's new".localized
        lbl.contentMode = .center

        return lbl
    }()

    let subtitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.text = "Version: 1.3.3".localized

        return lbl
    }()

    let textView: UITextView = {
        let txt = UITextView()
        txt.textContainer.lineBreakMode = .byWordWrapping
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        style.headIndent = 28

        let attributes = [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        txt.attributedText = NSAttributedString(string: "☑️ Added Russian language 🇷🇺\n\n☑️ Now you can modify daily notifications\n\n☑️ Fixed more bugs\n\n☑️ Working hard on new features!".localized, attributes: attributes)

        return txt
    }()

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("label.continue".localized, for: .normal)
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
        topLabel.pin.top(20).hCenter().sizeToFit()

        container.addSubview(subtitle)
        subtitle.pin
            .below(of: topLabel)
            .marginTop(2)
            .hCenter()
            .sizeToFit()

        container.addSubview(textView)
        textView.pin
            .below(of: subtitle, aligned: .center)
            .marginVertical(10)
            .width(container.frame.size.width - 70)
            .height(240)
        
        container.addSubview(button)
        button.pin.bottom(100).hCenter().width(250).height(50)
    }
}
