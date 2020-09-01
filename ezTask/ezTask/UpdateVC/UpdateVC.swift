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
        lbl.text = "Version: 1.3.4".localized

        return lbl
    }()

    let textView: UITextView = {
        let txt = UITextView()
        txt.backgroundColor = .clear
        txt.isUserInteractionEnabled = false
        txt.textContainer.lineBreakMode = .byWordWrapping
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1
        style.headIndent = 32
        let attributes = [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.label]
        txt.attributedText = NSAttributedString(string: "☑️  Now you can import events from calendar 🗓\n\n☑️  Fixed even more bugs 🛠\n\n☑️  Working hard on new features 💪\n\n🙊  Do not hesitate to give your feedback".localized, attributes: attributes)
        return txt
    }()

    let feedback: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("label.giveFeedback".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 3
        button.addTarget(self, action: #selector(feedbackPressed), for: .touchUpInside)

        return button
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

    @objc func feedbackPressed() {
        if let url = URL(string: "itms-apps://apple.com/app/id1526203030") {
            UIApplication.shared.open(url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        setup()
    }

    func setup() {
        self.view.addSubview(container)
        container.pin.horizontally().height(500).bottom()

        container.addSubview(topLabel)
        topLabel.pin.top(20).hCenter().sizeToFit()

        container.addSubview(subtitle)
        subtitle.pin
            .below(of: topLabel)
            .marginTop(2)
            .hCenter()
            .sizeToFit()

        container.addSubview(textView)
        container.addSubview(button)
        container.addSubview(feedback)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: feedback.topAnchor, constant: -10).isActive = true
        textView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(lessThanOrEqualToConstant: 310).isActive = true
        textView.sizeToFit()
        textView.isScrollEnabled = false

        feedback.pin.bottom(165).hCenter().width(250).height(50)
        button.pin.bottom(100).hCenter().width(250).height(50)
    }
}
