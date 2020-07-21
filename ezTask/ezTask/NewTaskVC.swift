//
//  NewTaskVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 21.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class NewTaskVC: UIViewController, UITextViewDelegate {
    // Views

    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "New Task"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        return label
    }()

    private let planning: UILabel = {
        let label = UILabel()
        label.text = "What are you planning?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.alpha = 0.25

        return label
    }()

    private let mainText: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        text.isScrollEnabled = false

        return text
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func dismiss() {
        // TODO: add dismiss cross button
        self.dismiss(animated: true, completion: nil)
    }

    func setup() {
        self.view.backgroundColor = .white

        self.view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true

        self.view.addSubview(planning)
        planning.translatesAutoresizingMaskIntoConstraints = false
        planning.heightAnchor.constraint(equalToConstant: 17).isActive = true
        planning.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        planning.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        planning.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 25).isActive = true

        self.view.addSubview(mainText)
        mainText.translatesAutoresizingMaskIntoConstraints = false
        mainText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21).isActive = true
        mainText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        mainText.topAnchor.constraint(equalTo: planning.bottomAnchor, constant: 10).isActive = true
        mainText.becomeFirstResponder()
        mainText.returnKeyType = .done
        mainText.delegate = self

        self.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        separator.topAnchor.constraint(equalTo: mainText.bottomAnchor, constant: 20).isActive = true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            dismiss()
            return false
        }
        return true
    }
}
