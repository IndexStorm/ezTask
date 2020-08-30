//
//  MainVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import AVFoundation
import CoreData
import SideMenu
import UIKit
import UserNotifications
import ViewAnimator

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, UNUserNotificationCenterDelegate, MenuVCDelegate {
    // Var

    var lastOffsetWithSound: CGFloat = 0
    var chosenIndex: Int = 0
    let doneSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sound-done", ofType: "mp3")!) // TODO: move
    let deleteSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sound-pop", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var isList: Bool = false
    var gradient: CAGradientLayer?

    // Views

    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().mainColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5

        return view
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()

    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()

    let menuBtn: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "menu")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white

        return image
    }()

    let backTodayBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("label.backToToday".localized, for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = ThemeManager.currentTheme().mainColor
        let image = UIImage(named: "left_arrow")
        btn.setImage(image, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: -5, bottom: 7.5, right: 0)
        btn.layer.cornerRadius = 13
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.shadowRadius = 5
        btn.addTarget(self, action: #selector(backTodayPressed), for: .touchUpInside)
        btn.alpha = 0

        return btn
    }()

    lazy var calendarOrList: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        if !self.isList {
            btn.setTitle("button.list".localized, for: .normal)
        } else {
            btn.setTitle("button.schedule".localized, for: .normal)
        }
        btn.backgroundColor = .white
        btn.tintColor = ThemeManager.currentTheme().mainColor
        btn.layer.cornerRadius = 13
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 5
        btn.addTarget(self, action: #selector(calendarOrListTapped), for: .touchUpInside)

        return btn
    }()

    class GlassView: UIView {
        let contentView = UIView()
        var circleLayer = CAShapeLayer()
        let imageView = UIImageView()
        let circleView = UIView()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        func setup() {
            self.contentView.backgroundColor = .tertiarySystemBackground
            self.addSubview(contentView)

            self.circleView.frame = CGRect(x: self.frame.size.width / 2.0 - 40 / 2, y: 30 - 40 / 2, width: 40, height: 40)
            self.circleView.layer.cornerRadius = 40 / 2
            self.circleView.backgroundColor = ThemeManager.currentTheme().mainColor
            self.circleView.alpha = 0
            self.addSubview(circleView)

            self.imageView.image = UIImage(named: "plus")
            self.imageView.tintColor = .tertiarySystemBackground
            self.imageView.frame = CGRect(x: self.frame.size.width / 2.0 - 10, y: 30 - 10, width: 20, height: 20)
            self.addSubview(imageView)

            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: 30), radius: 21.5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = ThemeManager.currentTheme().mainColor.cgColor
            circleLayer.lineWidth = 4.0
            circleLayer.strokeEnd = 0
            circleLayer.lineCap = CAShapeLayerLineCap.round
            layer.addSublayer(circleLayer)

            layoutIfNeeded()
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            contentView.frame = self.bounds
        }

        func update(offset: CGFloat) {
            self.circleLayer.strokeEnd = min(offset / 130, 1)
            self.circleView.alpha = min(offset / 110, 1)

            let newHeight = min(offset / 180 + 0.3, 1) * 22
            self.imageView.frame = CGRect(x: self.frame.size.width / 2.0 - newHeight / 2, y: 30 - newHeight / 2, width: newHeight, height: newHeight)
        }
    }

    private let rocket: UIImageView = { // TODO: unite in one view
        let image = UIImageView()
        image.image = UIImage(named: "rocket")
        image.contentMode = .scaleAspectFit

        return image
    }()

    private let quote: UILabel = {
        let label = UILabel()
        label.text = "“The Way To Get Started Is To Quit Talking And Begin Doing.”".localized
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    private let author: UILabel = {
        let label = UILabel()
        label.text = "– Walt Disney"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    private lazy var headerForListToday: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        view.backgroundColor = .tertiarySystemBackground
        let label = UILabel()
        label.text = "label.today".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true

        return view
    }()

    private lazy var headerForListTommorow: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let label = UILabel()
        label.text = "label.tomorrow".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true

        return view
    }()

    private lazy var headerForListThisWeek: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let label = UILabel()
        label.text = "label.thisWeek".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true

        return view
    }()

    private lazy var headerForListLater: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let label = UILabel()
        label.text = "label.later".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true

        return view
    }()

    private let createTaskView: UIView = {
        let view = UIView()
        let image = UIImageView()
        image.image = UIImage(named: "plus")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 22).isActive = true
        image.heightAnchor.constraint(equalToConstant: 22).isActive = true

        return view
    }()

    // CollectionView

    private var daysCollectionView: UICollectionView?
    private var topViewHeight: NSLayoutConstraint!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 365
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView?.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
        let date = Date().addDays(add: indexPath[1])

        cell.configure(name: date.dayNameOfWeek(), number: date.day, busy: checkDayIsBusy(date: date), isChosen: indexPath[1] == chosenIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenIndex = indexPath[1]
        updateTopLabels(date: Date().addDays(add: chosenIndex))
        fetchTasks()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
        tasksTable.reloadData()
        animateTable()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableview
        if scrollView == tasksTable {
            let contentOffset = scrollView.contentOffset.y
            animatedView.update(offset: -1 * contentOffset)
        }

        if scrollView == listTable {
            let contentOffset = scrollView.contentOffset.y
            animatedView1.update(offset: -1 * contentOffset)
        }

        // collection
        if let flowLayout = ((scrollView as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout) {
            let lineHeight = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            let offset = scrollView.contentOffset.x
            let roundedOffset = offset - offset.truncatingRemainder(dividingBy: lineHeight)
            if offset > 200 && lastOffsetWithSound - roundedOffset < 0 {
                UIView.animate(withDuration: 0.2) {
                    self.backTodayBtn.alpha = 1
                }
            } else if offset < 200 && backTodayBtn.alpha != 0 {
                UIView.animate(withDuration: 0.2) {
                    self.backTodayBtn.alpha = 0
                }
            }
            if abs(lastOffsetWithSound - roundedOffset) >= lineHeight {
                lastOffsetWithSound = roundedOffset
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }

    // TableView

    private let tasksTable = UITableView()
    private let listTable = UITableView(frame: .zero, style: .grouped)

    var refreshControl = UIRefreshControl()
    var refreshControlList = UIRefreshControl()

    var allTasks: [TaskModel] = []
    var allTasksForDay: [TaskModel] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listTable {
            switch section {
            case 0:
                return allTasks.tasksForToday().count
            case 1:
                return allTasks.tasksForTommorow().count
            case 2:
                return allTasks.tasksForThisWeek().count
            case 3:
                return allTasks.tasksForLater().count
            default:
                return 0
            }
        } else {
            return allTasksForDay.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == listTable {
            return 4
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == listTable {
            return 45
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == listTable {
            switch section {
            case 0:
                return headerForListToday
            case 1:
                return headerForListTommorow
            case 2:
                return headerForListThisWeek
            case 3:
                return headerForListLater
            default:
                return nil
            }
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tasksTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            let task = allTasksForDay[indexPath.row]
            cell.configure(task: task)
            cell.delegate = self

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            var data = [TaskModel]()
            switch indexPath.section {
            case 0:
                data = allTasks.tasksForToday()
            case 1:
                data = allTasks.tasksForTommorow()
            case 2:
                data = allTasks.tasksForThisWeek()
            case 3:
                data = allTasks.tasksForLater()
            default:
                data = allTasks.tasksForToday()
            }
            let task = data[indexPath.row]
            cell.configure(task: task)
            cell.delegate = self

            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }

    func getAllTasksForDay() {
        let date = Date().addDays(add: chosenIndex)
        var res = [TaskModel]()
        for task in allTasks {
            if date.isToday(), task.taskDate.startOfDay < date.startOfDay, !task.isDone {
                res.append(task)
            } else if date.startOfDay == task.taskDate.startOfDay, !date.isToday() {
                res.append(task)
            } else if date.startOfDay == task.taskDate.startOfDay, date.isToday(), !task.isDone || (task.dateModified >= date.startOfDay) {
                res.append(task)
            } else if task.isDone, date.isToday(), task.dateModified.isToday(), task.taskDate.startOfDay < Date().startOfDay {
                res.append(task)
            }
        }
        allTasksForDay = res
    }

    func checkIfDayEmpty() {
        if allTasksForDay.isEmpty {
            tasksTable.backgroundColor = .clear
            animatePlaceholder()
        } else {
            tasksTable.backgroundColor = .tertiarySystemBackground
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            if let model = cell.model {
                
                deleteTask(id: model.id.uuidString, completion: {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: deleteSound)
                        audioPlayer.play()
                    } catch {
                        // couldn't load file :(
                    }
                    self.fetchTasks()
                    if self.isList {
                        self.listTable.performBatchUpdates({
                            self.listTable.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: { (_: Bool) in
                            self.listTable.reloadData()
                        })
                    } else {
                        self.tasksTable.performBatchUpdates({
                            self.tasksTable.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: { (_: Bool) in
                            self.tasksTable.reloadData()
                        })
                    }
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                })
                daysCollectionView?.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let newVC = NewTaskVC()
        newVC.model = cell.model
        newVC.returnTask = { task in
            if task.mainText == "" {
                deleteTask(id: task.id.uuidString, completion: {
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: self.deleteSound)
                        self.audioPlayer.play()
                    } catch {
                        // couldn't load file :(
                    }
                    self.fetchTasks()
                    if self.isList {
                        self.listTable.performBatchUpdates({
                            self.listTable.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: { (_: Bool) in
                            self.listTable.reloadData()
                        })
                    } else {
                        self.tasksTable.performBatchUpdates({
                            self.tasksTable.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: { (_: Bool) in
                            self.tasksTable.reloadData()
                    })
                    }
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                    self.daysCollectionView?.reloadData()
                })
                return
            }
            if cell.model != task {
                self.didReceivedUpdatedTask(task: task)
                self.fetchTasks()
                if self.isList {
                    let (row, section) = self.getRowAndSectionOfTask(id: task.id)
                    self.listTable.performBatchUpdates({
                        cell.configure(task: task)
                        tableView.moveRow(at: indexPath, to: IndexPath(row: row, section: section))
                    }, completion: { (_: Bool) in
                        self.listTable.reloadData()
                    })
                } else {
                    if task.taskDate.startOfDay != Date().addDays(add: self.chosenIndex).startOfDay {
                        self.tasksTable.reloadData()
                        return
                    }
                    self.tasksTable.performBatchUpdates({
                        cell.configure(task: task)
                        if let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString) {
                            tableView.moveRow(at: indexPath, to: IndexPath(row: row, section: 0))
                        }
                    }, completion: { (_: Bool) in
                        self.tasksTable.reloadData()
                    })
                }
                self.daysCollectionView?.reloadData()
            }
        }
        self.present(newVC, animated: true, completion: nil)
    }

    func didReceivedUpdatedTask(task: TaskModel) {
        update(id: task.id.uuidString, newModel: task, completion: {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        })
    }

    func getRowAndSectionOfTask(id: UUID) -> (Int, Int) {
        if let row = self.allTasks.tasksForToday().firstIndexById(id: id.uuidString) {
            return (row, 0)
        } else if let row = self.allTasks.tasksForTommorow().firstIndexById(id: id.uuidString) {
            return (row, 1)
        } else if let row = self.allTasks.tasksForThisWeek().firstIndexById(id: id.uuidString) {
            return (row, 2)
        } else if let row = self.allTasks.tasksForLater().firstIndexById(id: id.uuidString) {
            return (row, 3)
        }

        return (-1, -1)
    }

    func checkboxTapped(cell: TaskCell) {
        var indexPath: IndexPath?
        if isList {
            indexPath = listTable.indexPath(for: cell)
        } else {
            indexPath = tasksTable.indexPath(for: cell)
        }
        if indexPath != nil {
            if let id = cell.id, let isDone = cell.model?.isDone, let task = cell.model { // reload
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: doneSound)
                    audioPlayer.play()
                } catch {
                    // couldn't load file :(
                }
                if !isDone {
                    setDone(id: id.uuidString, completion: { newReccuringId in
                        fetchTasks()
                        if isList {
                            listTable.performBatchUpdates({
                                cell.setCellDone()
                                if newReccuringId != nil {
                                    let (rowNew, sectionNew) = getRowAndSectionOfTask(id: UUID(uuidString: newReccuringId!)!)
                                    listTable.insertRows(at: [IndexPath(row: rowNew, section: sectionNew)], with: rowNew == 0 ? .top : .left)
                                }
                                if UserDefaults.standard.bool(forKey: "hideCompleted") {
                                    listTable.deleteRows(at: [indexPath!], with: .none)
                                } else {
                                    let (row, section) = getRowAndSectionOfTask(id: task.id)
                                    listTable.moveRow(at: indexPath!, to: IndexPath(row: row, section: section))
                                }
                            }, completion: { (_: Bool) in
                                self.listTable.reloadData()
                            })
                        } else {
                            tasksTable.performBatchUpdates({
                                cell.setCellDone()
                                if newReccuringId != nil {
                                    if let row = self.allTasksForDay.firstIndexById(id: newReccuringId!) {
                                        tasksTable.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                                    }
                                }
                                if let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString) {
                                    tasksTable.moveRow(at: indexPath!, to: IndexPath(row: row, section: 0))
                                }
                            }, completion: { (_: Bool) in
                                self.tasksTable.reloadData()
                            })
                        }
                    })
                } else {
                    setUndone(id: id.uuidString, completion: {
                        fetchTasks()
                        if isList {
                            let (row, section) = getRowAndSectionOfTask(id: task.id)
                            listTable.performBatchUpdates({
                                cell.setCellUndone()
                                listTable.moveRow(at: indexPath!, to: IndexPath(row: row, section: section))
                            }, completion: { (_: Bool) in
                                self.listTable.reloadData()
                            })
                        } else {
                            daysCollectionView?.reloadData()
                            tasksTable.performBatchUpdates({
                                cell.setCellUndone()
                                if let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString) {
                                    tasksTable.moveRow(at: indexPath!, to: IndexPath(row: row, section: 0))
                                }
                            }, completion: { (_: Bool) in
                                self.tasksTable.reloadData()
                            })
                        }
                    })
                }
            }
            self.daysCollectionView?.reloadData()
        }
    }

    private func insertNewTask(task: TaskModel) {
        save(model: task, completion: {
            fetchTasks()
            if isList {
                let (row, section) = getRowAndSectionOfTask(id: task.id)
                listTable.insertRows(at: [IndexPath(row: row, section: section)], with: .left)
            } else {
                if task.taskDate.startOfDay == Date().addDays(add: chosenIndex).startOfDay { // on current page
                    if let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString) {
                        tasksTable.insertRows(at: [IndexPath(row: row, section: 0)], with: row == 0 ? .top : .left)
                    }
                }
                daysCollectionView?.reloadData()
            }
        })
    }

    // override

    private var sideMenu: SideMenuNavigationController?
    private let colorThemeVC = ColorThemeVC()
    private let settingsVC = SettingsVC()
    private let completedTasksVC = CompletedTasksVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        isList = UserDefaults.standard.bool(forKey: "isList")
        setup()
        updateTopLabels(date: Date().addDays(add: chosenIndex))
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)

        loadAllChosenCalendars()
        createMenu()
        setupColorsFromTheme()
    }

    func createMenu() {
        var settings = SideMenuSettings()
        settings.statusBarEndAlpha = 0
        settings.menuWidth = UIScreen.main.bounds.width * 0.54
        settings.presentationStyle = .viewSlideOut

        let menuVC = MenuVC(with: ["Home", "Settings", "Completed", "Theme"])
        menuVC.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuVC, settings: settings)
        sideMenu?.leftSide = true
        sideMenu?.presentationStyle.onTopShadowOpacity = 0.3
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        addChildControllers()
    }

    private func addChildControllers() {
        addChild(colorThemeVC)
        view.addSubview(colorThemeVC.view)
        colorThemeVC.view.frame = view.bounds
        colorThemeVC.didMove(toParent: self)
        colorThemeVC.view.isHidden = true

        addChild(settingsVC)
        view.addSubview(settingsVC.view)
        settingsVC.view.frame = view.bounds
        settingsVC.didMove(toParent: self)
        settingsVC.view.isHidden = true

        addChild(completedTasksVC)
        view.addSubview(completedTasksVC.view)
        completedTasksVC.view.frame = view.bounds
        completedTasksVC.didMove(toParent: self)
        completedTasksVC.view.isHidden = true
    }

    func didSelectMenuItem(named: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.sideMenu?.dismiss(animated: true, completion: nil)
        }

        switch named {
        case "Home":
            safeAreaView.isHidden = false
            colorThemeVC.view.isHidden = true
            settingsVC.view.isHidden = true
            completedTasksVC.view.isHidden = true
            setupColorsFromTheme()

        case "Theme":
            safeAreaView.isHidden = true
            colorThemeVC.view.isHidden = false
            settingsVC.view.isHidden = true
            completedTasksVC.view.isHidden = true
            colorThemeVC.viewWillAppear(true)

        case "Settings":
            safeAreaView.isHidden = true
            colorThemeVC.view.isHidden = true
            settingsVC.view.isHidden = false
            completedTasksVC.view.isHidden = true
            settingsVC.viewWillAppear(true)

        case "Completed":
            safeAreaView.isHidden = true
            colorThemeVC.view.isHidden = true
            settingsVC.view.isHidden = true
            completedTasksVC.view.isHidden = false
            completedTasksVC.viewWillAppear(true)

        default:
            return
        }
    }

    func setupColorsFromTheme() {
        topView.backgroundColor = ThemeManager.currentTheme().mainColor
        backTodayBtn.tintColor = ThemeManager.currentTheme().mainColor
        calendarOrList.tintColor = ThemeManager.currentTheme().mainColor
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor

        if gradient == nil {
            gradient = CAGradientLayer()
            createTaskView.layer.insertSublayer(gradient!, at: 0)
        }
        gradient!.frame = createTaskView.bounds
        gradient!.colors = [ThemeManager.currentTheme().mainColor.withAlphaComponent(0.8).cgColor, ThemeManager.currentTheme().mainColor.cgColor]
        gradient!.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient!.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient!.cornerRadius = 30

        fetchTasks()
        tasksTable.reloadData()
        listTable.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkFirstLaunch()
        checkUpdate()
        setupColorsFromTheme()
    }

    func animateTable() {
        if isList {
            UIView.animate(views: listTable.visibleCells, animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.5)
        } else {
            UIView.animate(views: tasksTable.visibleCells, animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.5)
        }
    }

    func animatePlaceholder() {
        if tasksTable.alpha != 0 {
            UIView.animate(views: [rocket, quote, author], animations: [AnimationType.from(direction: .top, offset: 20.0)], initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 1)
        }
    }

    // @objc

    @objc
    func newTask() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let newVC = NewTaskVC()
        newVC.chosenDate = Date().addDays(add: chosenIndex).startOfDay
        newVC.returnTask = { task in
            if task.mainText.isEmpty {
                return
            }
            self.didReceivedNewTask(task: task)
        }
        self.present(newVC, animated: true, completion: {
            self.refreshControl.endRefreshing()
            self.refreshControlList.endRefreshing()
        })
    }

    func didReceivedNewTask(task: TaskModel) {
        self.insertNewTask(task: task)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    @objc
    func backTodayPressed() {
        guard let myCollection = daysCollectionView else {
            return
        }
        self.chosenIndex = 0
        UIView.animate(withDuration: 1) {
            myCollection.setContentOffset(CGPoint.zero, animated: true)
        }
        UIView.animate(withDuration: 0.2) {
            self.backTodayBtn.alpha = 0
        }
        myCollection.reloadData()
        updateTopLabels(date: Date().addDays(add: chosenIndex))
        fetchTasks()
        tasksTable.reloadData()
        animateTable()
    }

    @objc
    func calendarOrListTapped() {
        if !isList {
            placeholder(show: false)
            self.backTodayBtn.alpha = 0
            calendarOrList.setTitle("button.schedule".localized, for: .normal)
            self.tasksTable.alpha = 0
            isList = true
            UserDefaults.standard.set(isList, forKey: "isList")
            chosenIndex = 0
            updateTopLabels(date: Date().addDays(add: chosenIndex))
            fetchTasks()
            listTable.reloadData()
            self.calendarOrList.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.daysCollectionView?.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: 0.4, animations: {
                    self.listTable.alpha = 1
                    self.animateTable()
                    self.topViewHeight.constant = 100
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.calendarOrList.alpha = 1
                    }, completion: nil)
                })
            })
        } else {
            calendarOrList.setTitle("button.list".localized, for: .normal)
            self.calendarOrList.alpha = 0
            isList = false
            UserDefaults.standard.set(isList, forKey: "isList")
            listTable.alpha = 0
            backTodayPressed()
            UIView.animate(withDuration: 0.4, animations: {
                self.topViewHeight.constant = 164
                self.view.layoutIfNeeded()
                self.tasksTable.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.daysCollectionView?.alpha = 1
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.placeholder(show: true) // TODO: save to core
                        self.calendarOrList.alpha = 1
                    }, completion: nil)
                })
            })
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc
    public func menuBtnTapped() {
        present(sideMenu!, animated: true)
    }

    func placeholder(show: Bool) {
        self.rocket.alpha = show ? 1 : 0
        self.quote.alpha = show ? 1 : 0
        self.author.alpha = show ? 1 : 0
    }

    func updateTopLabels(date: Date) {
        let formatter = DateFormatter()
        if Locale.current.identifier == "en" {
            formatter.dateFormat = "MMMM d, yyyy"
        } else {
            formatter.dateFormat = "d MMMM, yyyy"
        }
        let formattedDate = formatter.string(from: date)
        dateLabel.text = formattedDate.capitalized
        if date.isToday() {
            dayLabel.text = "label.today".localized
        } else if date.isTomorrow() {
            dayLabel.text = "label.tomorrow".localized
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            dayLabel.text = formatter.string(from: date).capitalized
        }
    }

    func checkDayIsBusy(date: Date) -> Bool {
        for task in allTasks {
            if task.taskDate.startOfDay == date.startOfDay, !task.isDone {
                return true
            }
            if date.isToday(), task.taskDate.startOfDay < date.startOfDay, !task.isDone {
                return true
            }
        }
        return false
    }

    lazy var animatedView = GlassView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
    lazy var animatedView1 = GlassView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
    var safeAreaView = UIView()

    func setup() {
        self.view.backgroundColor = .tertiarySystemBackground
        safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 1))
        safeAreaView.backgroundColor = ThemeManager.currentTheme().mainColor
        safeAreaView.layer.zPosition = 1_000
        self.view.addSubview(safeAreaView)
        self.view.addSubview(rocket)
        self.view.addSubview(quote)
        self.view.addSubview(author)
        placeholder(show: !isList)
        self.view.addSubview(listTable)
        self.view.addSubview(tasksTable)

        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: topView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        topViewHeight = topView.heightAnchor.constraint(equalToConstant: 169)
        topViewHeight.isActive = true
        if isList {
            topViewHeight.constant = 105
        }
        topView.leadingAnchor.constraint(equalTo: topView.superview!.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: topView.superview!.trailingAnchor, constant: 0).isActive = true

        self.view.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true
        menuBtn.isUserInteractionEnabled = true
        menuBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuBtnTapped)))

        self.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: menuBtn.bottomAnchor, constant: 4).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true // TODO: Test on different languages

        self.view.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        createCollection()

        guard let myCollection = daysCollectionView else {
            return
        }
        myCollection.translatesAutoresizingMaskIntoConstraints = false
        myCollection.heightAnchor.constraint(equalToConstant: 54).isActive = true
        myCollection.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive = true
        myCollection.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 0).isActive = true
        myCollection.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10).isActive = true
        if isList {
            myCollection.alpha = 0
        }

        rocket.translatesAutoresizingMaskIntoConstraints = false
        rocket.heightAnchor.constraint(equalToConstant: 280).isActive = true
        rocket.widthAnchor.constraint(equalToConstant: 280).isActive = true
        rocket.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 80).isActive = true
        rocket.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        quote.translatesAutoresizingMaskIntoConstraints = false
        quote.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        quote.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        quote.topAnchor.constraint(equalTo: rocket.bottomAnchor, constant: 10).isActive = true
        quote.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        author.translatesAutoresizingMaskIntoConstraints = false
        author.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        author.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        author.topAnchor.constraint(equalTo: quote.bottomAnchor, constant: 5).isActive = true
        author.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        createTable()

        tasksTable.translatesAutoresizingMaskIntoConstraints = false
        tasksTable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        tasksTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tasksTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tasksTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        tasksTable.separatorStyle = .none
        tasksTable.contentInset.top = 10
        tasksTable.contentInset.bottom = 10
        tasksTable.showsHorizontalScrollIndicator = false
        tasksTable.showsVerticalScrollIndicator = false

        listTable.translatesAutoresizingMaskIntoConstraints = false
        listTable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        listTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        listTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        listTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        listTable.separatorStyle = .none
        listTable.contentInset.top = 10
        listTable.contentInset.bottom = 10
        listTable.showsHorizontalScrollIndicator = false
        listTable.showsVerticalScrollIndicator = false
        listTable.backgroundColor = .tertiarySystemBackground

        refreshControl.addTarget(self, action: #selector(self.newTask), for: .valueChanged)
        refreshControl.tintColor = .clear
        refreshControl.layer.zPosition = -1
        refreshControl.addSubview(animatedView)
        tasksTable.refreshControl = refreshControl

        refreshControlList.addTarget(self, action: #selector(self.newTask), for: .valueChanged)
        refreshControlList.tintColor = .clear
        refreshControlList.layer.zPosition = -1
        refreshControlList.addSubview(animatedView1)
        listTable.refreshControl = refreshControlList

        self.view.addSubview(backTodayBtn)
        backTodayBtn.translatesAutoresizingMaskIntoConstraints = false
        backTodayBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backTodayBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        backTodayBtn.centerYAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        backTodayBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26).isActive = true

        self.view.addSubview(calendarOrList)
        calendarOrList.translatesAutoresizingMaskIntoConstraints = false
        calendarOrList.widthAnchor.constraint(equalToConstant: 75).isActive = true
        calendarOrList.heightAnchor.constraint(equalToConstant: 28).isActive = true
        calendarOrList.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor).isActive = true
        calendarOrList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true

        self.view.addSubview(createTaskView)
        createTaskView.translatesAutoresizingMaskIntoConstraints = false
        createTaskView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        createTaskView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        createTaskView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        createTaskView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        createTaskView.layer.cornerRadius = 30
        createTaskView.isUserInteractionEnabled = true
        createTaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newTask)))
    }

    func createCollection() {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 54)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 12

        daysCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        daysCollectionView?.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        daysCollectionView?.showsHorizontalScrollIndicator = false
        daysCollectionView?.delegate = self
        daysCollectionView?.dataSource = self
        daysCollectionView?.backgroundColor = .clear
        daysCollectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        guard let myCollection = daysCollectionView else {
            return
        }
        self.view.addSubview(myCollection)
    }

    func createTable() {
        if isList {
            tasksTable.alpha = 0
        } else {
            listTable.alpha = 0
        }

        tasksTable.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tasksTable.dataSource = self
        tasksTable.delegate = self

        listTable.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        listTable.dataSource = self
        listTable.delegate = self
        listTable.tableFooterView = UIView(frame: CGRect.zero)
        listTable.sectionFooterHeight = 0.0
    }

    func checkUpdate() {
        if !UserDefaults.standard.bool(forKey: "1.3.4(2)") {
            let updateVC = UpdateVC()
            present(updateVC, animated: true, completion: { UserDefaults.standard.set(true, forKey: "1.3.4(2)") })
        }
    }

    func checkFirstLaunch() {
        if UserDefaults.standard.integer(forKey: "morningHour") == 0 {
            UserDefaults.standard.set(true, forKey: "dailyNotifications")
            UserDefaults.standard.set(8, forKey: "morningHour")
            UserDefaults.standard.set(0, forKey: "morningMinute")
            UserDefaults.standard.set(21, forKey: "eveningHour")
            UserDefaults.standard.set(0, forKey: "eveningMinute")
        }
        if !UserDefaults.standard.bool(forKey: "notFirstLaunch") {
            createInitialTasks()
            let onboarding = OnboardingVC()
            onboarding.modalPresentationStyle = .fullScreen
            present(onboarding, animated: true, completion: {})
            setupSpotlight()
            view.addSubview(spotlightView)
            spotlightView.layer.zPosition = 1_001
            spotlightView.continueButtonModel.isEnable = false
            spotlightView.skipButtonModel.isEnable = false
            spotlightView.showAllSpotlightsAtOnce = false
            spotlightView.start()
        }
        if UserDefaults.standard.object(forKey: "dateInstalled") == nil {
            UserDefaults.standard.set(Date(), forKey: "dateInstalled")
        }
        if UserDefaults.standard.stringArray(forKey: "chosenCalendars") == nil {
            UserDefaults.standard.setValue(true, forKey: "importCalendars")
        }
    }

    var spotlightView = AwesomeSpotlightView()

    func setupSpotlight() {
        let nameLabelSpotlight = AwesomeSpotlight(withRect: calendarOrList.frame, shape: .roundRectangle, text: "Switch between representations".localized)
        let menuRect = CGRect(x: menuBtn.frame.origin.x - 10, y: menuBtn.frame.origin.y - 10, width: menuBtn.frame.size.width + 20, height: menuBtn.frame.size.height + 20)
        let menuBtnSpotlight = AwesomeSpotlight(withRect: menuRect, shape: .circle, text: "Use menu button to find more features".localized)
        spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [nameLabelSpotlight, menuBtnSpotlight])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
    }

    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        loadAllChosenCalendars()
        if allTasks.isEmpty {
            fetchTasks()
            if isList {
                listTable.reloadData()
                animateTable()
                return
            }
            tasksTable.reloadData()
            daysCollectionView?.reloadData()
            animateTable()
        } else {
            fetchTasks()
            if isList {
                listTable.reloadData()
                return
            }
            tasksTable.reloadData()
            daysCollectionView?.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainVC {
    func fetchTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let hideCompleted = UserDefaults.standard.bool(forKey: "hideCompleted")
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchAll = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
        fetchAll.predicate = NSPredicate(format: "isHidden == nil")
        do {
            let objects = try managedContext.fetch(fetchAll)
            allTasks = objects.map { TaskModel(task: $0) }
            allTasks.sort()
            if isList, hideCompleted {
                allTasks = allTasks.allUndoneTasks()
            }
            getAllTasksForDay()
            allTasksForDay.sort()
            checkIfDayEmpty()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach { layoutAttributes in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment - sectionInset.left, y: proposedContentOffset.y)
    }
}

extension MainVC: AwesomeSpotlightViewDelegate {
    func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int) {}

    func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int) {}

    func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int) {}

    func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView) {}
}

extension MainVC {
    func createInitialTasks() {
        if fetchAllTasks().isEmpty {
            var task = TaskModel(id: UUID(), mainText: "A simple task for today".localized, subtasks: "done\nDownload the app\nundone\nBecome more productive\n".localized, isPriority: false, isDone: false, taskDate: Date(), isAlarmSet: false, alarmDate: nil, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: nil, eventId: nil)
            save(model: task, completion: {})
            task = TaskModel(id: UUID(), mainText: "Swipe left to delete the task".localized, subtasks: nil, isPriority: false, isDone: false, taskDate: Date(), isAlarmSet: false, alarmDate: nil, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: nil, eventId: nil)
            save(model: task, completion: {})
            task = TaskModel(id: UUID(), mainText: "Create a task by yourself".localized, subtasks: "undone\nSwipe down\nundone\nEnter the text\nundone\nSwipe down to save\n".localized, isPriority: false, isDone: false, taskDate: Date(), isAlarmSet: false, alarmDate: nil, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: nil, eventId: nil)
            save(model: task, completion: {})
            task = TaskModel(id: UUID(), mainText: "Watch a movie".localized, subtasks: "undone\nSnatch\nundone\nThe Transporter\nundone\nCrank\n".localized, isPriority: false, isDone: false, taskDate: Date().dayAfter, isAlarmSet: false, alarmDate: nil, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: nil, eventId: nil)
            save(model: task, completion: {})
            task = TaskModel(id: UUID(), mainText: "Rate the app on AppStore".localized, subtasks: nil, isPriority: false, isDone: false, taskDate: Date().addDays(add: 4), isAlarmSet: false, alarmDate: nil, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: nil, eventId: nil)
            save(model: task, completion: {})
        }
        fetchTasks()
        tasksTable.reloadData()
        daysCollectionView?.reloadData()
    }
}
