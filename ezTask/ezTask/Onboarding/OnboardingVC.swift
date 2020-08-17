//
//  OnboardingVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 16.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class OnboardingVC: UIViewController {
    func onMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    var currentPage = 0
    lazy var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 30, width: self.view.bounds.width, height: self.view.bounds.height - 30))

    func firstPage(x: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: x + 15, y: 15, width: viewWidth, height: viewHeight))
        view.backgroundColor = .tertiarySystemBackground

        let lets = UILabel()
        view.addSubview(lets)
        lets.font = UIFont.systemFont(ofSize: 58, weight: .black)
        lets.text = "Let's"
        lets.translatesAutoresizingMaskIntoConstraints = false
        lets.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        lets.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lets.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true

        let get = UILabel()
        view.addSubview(get)
        get.font = UIFont.systemFont(ofSize: 58, weight: .black)
        get.text = "Get"
        get.translatesAutoresizingMaskIntoConstraints = false
        get.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        get.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        get.topAnchor.constraint(equalTo: lets.bottomAnchor, constant: 20).isActive = true

        let things = UILabel()
        view.addSubview(things)
        things.font = UIFont.systemFont(ofSize: 58, weight: .black)
        things.text = "Things"
        things.translatesAutoresizingMaskIntoConstraints = false
        things.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        things.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        things.topAnchor.constraint(equalTo: get.bottomAnchor, constant: 20).isActive = true

        let done = UILabel()
        view.addSubview(done)
        done.font = UIFont.systemFont(ofSize: 58, weight: .black)
        done.text = "Done"
        done.translatesAutoresizingMaskIntoConstraints = false
        done.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        done.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        done.topAnchor.constraint(equalTo: things.bottomAnchor, constant: 20).isActive = true

        let eazy = UILabel()
        view.addSubview(eazy)
        eazy.font = UIFont.systemFont(ofSize: 58, weight: .black)
        eazy.text = "Eazy"
        eazy.translatesAutoresizingMaskIntoConstraints = false
        eazy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        eazy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eazy.topAnchor.constraint(equalTo: done.bottomAnchor, constant: 20).isActive = true

        let task = UILabel()
        view.addSubview(task)
        task.font = UIFont.systemFont(ofSize: 58, weight: .black)
        task.textColor = .systemBlue
        task.text = "Task"
        task.translatesAutoresizingMaskIntoConstraints = false
        task.leadingAnchor.constraint(equalTo: eazy.leadingAnchor, constant: 150).isActive = true
        task.centerYAnchor.constraint(equalTo: eazy.centerYAnchor).isActive = true

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

        let subviews = view.subviews
        for view in subviews {
            view.isHidden = true
        }

        return view
    }

    func secondPage(x: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: x + 15, y: 15, width: viewWidth, height: viewHeight))

        let videoView = UIView()
        view.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        videoView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        videoView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 2).isActive = true

        let swipeDown = UILabel()
        view.addSubview(swipeDown)
        swipeDown.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        swipeDown.text = "Swipe down to create a new task"
        swipeDown.textAlignment = .left
        swipeDown.numberOfLines = 0
        swipeDown.lineBreakMode = .byWordWrapping
        swipeDown.translatesAutoresizingMaskIntoConstraints = false
        swipeDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        swipeDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        swipeDown.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 30).isActive = true

        let saveTask = UILabel()
        view.addSubview(saveTask)
        saveTask.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        saveTask.text = "Swipe one more time to save it"
        saveTask.textColor = .secondaryLabel
        saveTask.textAlignment = .left
        saveTask.numberOfLines = 0
        saveTask.lineBreakMode = .byWordWrapping
        saveTask.translatesAutoresizingMaskIntoConstraints = false
        saveTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        saveTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        saveTask.topAnchor.constraint(equalTo: swipeDown.bottomAnchor, constant: 10).isActive = true

        let eazy = UILabel()
        view.addSubview(eazy)
        eazy.font = UIFont.systemFont(ofSize: 20, weight: .black)
        eazy.text = "Eazy as that"
        eazy.textColor = .systemBlue
        eazy.textAlignment = .left
        eazy.translatesAutoresizingMaskIntoConstraints = false
        eazy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        eazy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        eazy.topAnchor.constraint(equalTo: saveTask.bottomAnchor, constant: 10).isActive = true

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

    func thirdPage(x: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: x + 15, y: 15, width: viewWidth, height: viewHeight))

        let image = UIImageView()
        image.image = UIImage(named: "badge")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemBlue
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let notificationsLabel = UILabel()
        view.addSubview(notificationsLabel)
        notificationsLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        notificationsLabel.text = "Notifications"
        notificationsLabel.textAlignment = .center
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        notificationsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        notificationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notificationsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250).isActive = true
        image.bottomAnchor.constraint(equalTo: notificationsLabel.topAnchor, constant: -50).isActive = true

        let subtitle = UILabel()
        view.addSubview(subtitle)
        subtitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitle.textColor = .secondaryLabel
        subtitle.text = "In order to set alarms and get things done, please allow our app to deliver notifications."
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 5).isActive = true

        let notifyBtn = UIButton(type: .system)
        notifyBtn.setTitle("Allow Notifications", for: .normal)
        notifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        notifyBtn.tintColor = .white
        notifyBtn.backgroundColor = .systemBlue
        notifyBtn.layer.cornerRadius = 25
        view.addSubview(notifyBtn)
        notifyBtn.translatesAutoresizingMaskIntoConstraints = false
        notifyBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        notifyBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        notifyBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notifyBtn.addTarget(self, action: #selector(notifyBtnPressed), for: .touchUpInside)

        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 25
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        notifyBtn.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20).isActive = true

        if notificationsStatus == .authorized || notificationsStatus == .denied {
            notifyBtn.alpha = 0
            button.backgroundColor = .systemBlue
        }

        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground

        setup()
    }

    var first = UIView()
    var second = UIView()
    var third = UIView()

    func setup() {
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .tertiarySystemBackground
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)

        var x: CGFloat = 0.0
        let padding: CGFloat = 15.0
        let viewWidth: CGFloat = scrollView.frame.size.width - 2 * padding
        let viewHeight: CGFloat = scrollView.frame.size.height - 2 * padding

        first = firstPage(x: x, viewWidth: viewWidth, viewHeight: viewHeight)
        scrollView.addSubview(first)
        x = first.frame.origin.x + viewWidth + padding

        second = secondPage(x: x, viewWidth: viewWidth, viewHeight: viewHeight)
        scrollView.addSubview(second)
        x = second.frame.origin.x + viewWidth + padding

        third = thirdPage(x: x, viewWidth: viewWidth, viewHeight: viewHeight)
        scrollView.addSubview(third)
        x = third.frame.origin.x + viewWidth + padding

        scrollView.contentSize = CGSize(width: x + padding, height: scrollView.frame.size.height)
    }

    let myqueue = DispatchQueue(label: "myQQ", attributes: [])

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let subviews = first.subviews
        myqueue.async {
            for i in 0 ..< subviews.count {
                if i > 4 {
                    break
                }
                let view = subviews[i]
                self.onMain {
                    UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        view.isHidden = false
                    })
                }
                usleep(600 * 1_000)
            }
        }
        myqueue.async {
            for i in 0 ..< subviews.count {
                let view = subviews[i]
                if i < 4 {
                    self.onMain {
                        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            view.isHidden = true
                        })
                    }
                }
                if i == 4 {
                    self.onMain {
                        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            if let lbl = view as? UILabel {
                                lbl.textColor = .systemBlue
                            }
                        })
                    }
                }
                if i > 4 {
                    self.onMain {
                        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            view.isHidden = false
                        })
                    }
                }
                usleep(600 * 1_000)
            }
        }
    }

    var player = AVQueuePlayer()
    var playerController = AVPlayerViewController()
    var looper: AVPlayerLooper?

    @objc
    func buttonPressed() {
        if currentPage == 2 {
            UserDefaults.standard.set(true, forKey: "notFirstLaunch")
            dismiss(animated: true, completion: {})
            return
        }
        if currentPage == 0 {
            guard let path = Bundle.main.path(forResource: "tutorial", ofType: "mp4") else {
                debugPrint("video not found")
                return
            }
            player = AVQueuePlayer(playerItem: AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: path))))
            looper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: path))))
            playerController = AVPlayerViewController()
            playerController.player = player
            let playerLayerAV = AVPlayerLayer(player: player)
            playerLayerAV.frame = second.subviews[0].bounds
            second.subviews[0].layer.addSublayer(playerLayerAV)
            player.play()
        }
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(currentPage + 1)
        currentPage += 1
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }

    @objc
    func notifyBtnPressed() {
        if notificationsStatus == .notDetermined {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    checkNotifications()
                    DispatchQueue.main.async {
                        self.buttonPressed()
                    }
                } else if error != nil {
                    print("error occured")
                } else if error == nil {
                    checkNotifications()
                    DispatchQueue.main.async {
                        self.buttonPressed()
                    }
                }
            })
        }
    }
}
