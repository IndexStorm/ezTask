//
//  OnboardingVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 16.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
    var currentPage = 0
    lazy var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height - 60))
    
    func firstPage(x: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: x + 15, y: 15, width: viewWidth, height: viewHeight))
        view.backgroundColor = .tertiarySystemBackground
        
        let title = UILabel()
        view.addSubview(title)
        title.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        title.text = "Welcome to\nEazy Task"
        title.textAlignment = .left
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        let image = UIImageView()
        
        image.image = UIImage(named: "menu")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Begin", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return view
    }
    
    func secondPage(x: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: x + 15, y: 15, width: viewWidth, height: viewHeight))

        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground

        setup()
    }

    func setup() {
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .tertiarySystemBackground
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        
        var x: CGFloat = 0.0
        let padding: CGFloat = 15.0
        let viewWidth: CGFloat = scrollView.frame.size.width - 2 * padding
        let viewHeight: CGFloat = scrollView.frame.size.height - 2 * padding
        
        var page = UIView()
        page = firstPage(x: x, viewWidth: viewWidth, viewHeight: viewHeight)
        scrollView.addSubview(page)
        x = page.frame.origin.x + viewWidth + padding
        
        page = secondPage(x: x, viewWidth: viewWidth, viewHeight: viewHeight)
        scrollView.addSubview(page)
        x = page.frame.origin.x + viewWidth + padding
        
        scrollView.contentSize = CGSize(width: x + padding, height: scrollView.frame.size.height)
    }

    @objc
    func buttonPressed() {
        if currentPage == 1 {
            dismiss(animated: true, completion: {})
            return
        }
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(currentPage + 1)
        currentPage += 1
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
}
