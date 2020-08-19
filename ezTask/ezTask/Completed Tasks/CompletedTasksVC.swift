//
//  CompletedTasksVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 11.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class CompletedTasksVC: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    func checkboxTapped(cell: TaskCell) {}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeholder.isHidden = allDoneTasks.count != 0
        return allDoneTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = allDoneTasks[indexPath.row]
        cell.configure(task: task)
        cell.delegate = self
        cell.setCompletedDate(date: task.dateCompleted!)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            if let model = cell.model {
                deleteTask(id: model.id.uuidString, completion: {
//                    do {
//                        audioPlayer = try AVAudioPlayer(contentsOf: deleteSound) TODO: add sound
//                        audioPlayer.play()
//                    } catch {
//                        // couldn't load file :(
//                    }
                    self.allDoneTasks = fetchAllTasks().allDoneTasks()
                    self.completedTasks.performBatchUpdates({
                        self.completedTasks.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: { (_: Bool) in
                        self.completedTasks.reloadData()
                    })
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                })
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let newVC = NewTaskVC()
        newVC.model = cell.model
        newVC.returnTask = { task in
            if task.mainText == "" {
                deleteTask(id: task.id.uuidString, completion: {
//                    do {
//                        self.audioPlayer = try AVAudioPlayer(contentsOf: self.deleteSound) TODO: add sound
//                        self.audioPlayer.play()
//                    } catch {
//                        // couldn't load file :(
//                    }
                    self.allDoneTasks = fetchAllTasks().allDoneTasks()
                    self.completedTasks.performBatchUpdates({
                        self.completedTasks.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: { (_: Bool) in
                        self.completedTasks.reloadData()
                    })
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                })
                return
            }
            if cell.model != task {
                update(id: task.id.uuidString, newModel: task, completion: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                })
                self.allDoneTasks = fetchAllTasks().allDoneTasks()
                self.completedTasks.reloadData()
            }
        }
        self.present(newVC, animated: true, completion: nil)
    }

    var allDoneTasks: [TaskModel] = []

    let menuBtn: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "menu")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white

        return image
    }()

    let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "label.completed".localized
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white

        return label
    }()

    let placeholder: UILabel = {
        let label = UILabel()
        label.text = "You don't have any completed tasks"
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.contentMode = .center

        return label
    }()

    @objc
    func menuBtnTapped() {
        if let mainVC = self.parent as? MainVC {
            mainVC.menuBtnTapped()
        }
    }

    private let completedTasks = UITableView()
    var safeAreaView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .tertiarySystemBackground
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        allDoneTasks = fetchAllTasks().allDoneTasks()
        completedTasks.reloadData()
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
    }

    func setup() {
        self.view.addSubview(completedTasks)
        safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 41))
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
        safeAreaView.layer.shadowColor = UIColor.black.cgColor
        safeAreaView.layer.shadowOpacity = 0.25
        safeAreaView.layer.shadowOffset = CGSize(width: 0, height: 4)
        safeAreaView.layer.shadowRadius = 5
        self.view.addSubview(safeAreaView)

        self.view.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21).isActive = true
        menuBtn.isUserInteractionEnabled = true
        menuBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuBtnTapped)))

        self.view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.sizeToFit()
        pageTitle.centerXAnchor.constraint(equalTo: safeAreaView.centerXAnchor).isActive = true
        pageTitle.topAnchor.constraint(equalTo: menuBtn.topAnchor).isActive = true

        createTable()
        completedTasks.translatesAutoresizingMaskIntoConstraints = false
        completedTasks.topAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: 0).isActive = true
        completedTasks.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        completedTasks.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        completedTasks.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        completedTasks.separatorStyle = .none
        completedTasks.contentInset.top = 10
        completedTasks.contentInset.bottom = 10
        completedTasks.showsHorizontalScrollIndicator = false
        completedTasks.showsVerticalScrollIndicator = false
        completedTasks.backgroundColor = .tertiarySystemBackground

        completedTasks.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.centerXAnchor.constraint(equalTo: completedTasks.centerXAnchor).isActive = true
        placeholder.topAnchor.constraint(equalTo: completedTasks.topAnchor, constant: 32).isActive = true
        placeholder.leadingAnchor.constraint(equalTo: completedTasks.leadingAnchor, constant: 32).isActive = true
        placeholder.trailingAnchor.constraint(equalTo: completedTasks.trailingAnchor, constant: -32).isActive = true
    }

    func createTable() {
        completedTasks.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        completedTasks.dataSource = self
        completedTasks.delegate = self
    }
}
