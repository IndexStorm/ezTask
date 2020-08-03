//
//  MainVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import AVFoundation
import CoreData
import UIKit
import UserNotifications
import ViewAnimator

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, UNUserNotificationCenterDelegate {
    // Var

    var lastOffsetWithSound: CGFloat = 0
    var chosenIndex: Int = 0
    let pullSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sound-pull", ofType: "mp3")!)
    let doneSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sound-done", ofType: "mp3")!)
    let deleteSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sound-pop", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()

    // Views

    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        view.layer.cornerRadius = 25
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
        btn.setTitle("Today", for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
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

    let calendarOrList: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("List", for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        btn.layer.cornerRadius = 13
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 5
        btn.addTarget(self, action: #selector(calendarOrListPressed), for: .touchUpInside)

        return btn
    }()

    class GlassView: UIView {
        let liquidView = UIView() // is going to be animated from bottom to top
        let shapeView = UIImageView() // is going to mask everything with alpha mask

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        func setup() {
            self.backgroundColor = UIColor.lightGray
            self.liquidView.backgroundColor = .systemYellow

            self.shapeView.contentMode = .scaleAspectFit
            self.shapeView.image = UIImage(named: "bulb")

            self.addSubview(liquidView)
            self.mask = shapeView

            layoutIfNeeded()
            reset()
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            liquidView.frame = self.bounds
            shapeView.frame = self.bounds
        }

        func reset() {
            liquidView.frame.origin.y = bounds.height
        }

        func animate() {
            reset()
            UIView.animate(withDuration: 1) {
                self.liquidView.frame.origin.y = 0
            }
        }

        func update(offset: CGFloat) {
            self.liquidView.frame.origin.y = (1 - offset / 130) * bounds.height
        }
    }

    private let rocket: UIImageView = { // TODO: unite in one view
        let image = UIImageView()
        image.image = UIImage(named: "rocket") // TODO: check if light or dark theme
        image.contentMode = .scaleAspectFit

        return image
    }()

    private let quote: UILabel = {
        let label = UILabel()
        label.text = "“The Way Get Started Is To Quit Talking And Begin Doing.”"
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

    // CollectionView

    private var daysCollectionView: UICollectionView?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 365
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView?.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
        let date = Date().addDays(add: indexPath[1])
        // TODO: keep busy days as a set

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
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableview
        if scrollView == tasksTable {
            let contentOffset = scrollView.contentOffset.y
            animatedView.update(offset: -1 * contentOffset)
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

    var refreshControl = UIRefreshControl()

    var allTasks: [TaskModel] = []
    var allTasksForDay: [TaskModel] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasksForDay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = allTasksForDay[indexPath.row]
        cell.configure(task: task)
        cell.delegate = self
        cell.layoutIfNeeded()

        return cell
    }

    func getAllTasksForDay() {
        let date = Date().addDays(add: chosenIndex)
        var res = [TaskModel]()
        for task in allTasks {
            if date.isToday(), task.taskDate.startOfDay <= date.startOfDay, !task.isDone {
                res.append(task)
            } else if date.startOfDay == task.taskDate.startOfDay {
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
            tasksTable.backgroundColor = .systemBackground
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
                    self.tasksTable.performBatchUpdates({
                        self.fetchTasks()
                        self.tasksTable.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: { (_: Bool) in
                        self.tasksTable.reloadData()
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
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: self.deleteSound)
                        self.audioPlayer.play()
                    } catch {
                        // couldn't load file :(
                    }
                    self.tasksTable.performBatchUpdates({
                        self.fetchTasks()
                        self.tasksTable.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: { (_: Bool) in
                        self.tasksTable.reloadData()
                    })
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                })
                return
            }
            if cell.model != task {
                self.didReceivedUpdatedTask(task: task)
                self.fetchTasks()
                if task.taskDate.startOfDay != Date().addDays(add: self.chosenIndex).startOfDay {
                    self.tasksTable.reloadData()
                    return
                }
                self.tasksTable.performBatchUpdates({
                    cell.configure(task: task)
                    let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString)
                    tableView.moveRow(at: indexPath, to: IndexPath(row: row, section: 0))
                }, completion: { (_: Bool) in
                    self.tasksTable.reloadData()
                })
            }
        }
        self.present(newVC, animated: true, completion: nil)
    }

    func didReceivedUpdatedTask(task: TaskModel) {
        update(id: task.id.uuidString, newModel: task, completion: {
            removeNotificationsById(id: task.id.uuidString)
            if task.isAlarmSet {
                setupReminder(task: task)
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        })
    }

    func checkboxTapped(cell: TaskCell) {
        if let indexPath = tasksTable.indexPath(for: cell) {
            if let id = cell.id, let isDone = cell.model?.isDone, let task = cell.model { // reload
                if !isDone {
                    setDone(id: id.uuidString, completion: {
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: doneSound)
                            audioPlayer.play()
                        } catch {
                            // couldn't load file :(
                        }
                        fetchTasks()
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        daysCollectionView?.reloadData()
                        tasksTable.performBatchUpdates({
                            cell.setCellDone()
                            let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString)
                            tasksTable.moveRow(at: indexPath, to: IndexPath(row: row, section: 0))
                        }, completion: { (_: Bool) in
                            self.tasksTable.reloadData()
                        })
                    })
                } else {
                    setUndone(id: id.uuidString, completion: {
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: doneSound)
                            audioPlayer.play()
                        } catch {
                            // couldn't load file :(
                        }
                        fetchTasks()
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        daysCollectionView?.reloadData()
                        tasksTable.performBatchUpdates({
                            cell.setCellUndone()
                            let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString)
                            tasksTable.moveRow(at: indexPath, to: IndexPath(row: row, section: 0))
                        }, completion: { (_: Bool) in
                            self.tasksTable.reloadData()
                        })
                    })
                }
            }
        }
    }

    private func insertNewTask(task: TaskModel) {
        save(model: task, completion: {
            fetchTasks()
            if task.taskDate.startOfDay == Date().addDays(add: chosenIndex).startOfDay { // on current page
                let row = self.allTasksForDay.firstIndexById(id: task.id.uuidString)
                tasksTable.insertRows(at: [IndexPath(row: row, section: 0)], with: row == 0 ? .top : .left)
            }
            daysCollectionView?.reloadData()
        })
    }

    // override

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateTopLabels(date: Date().addDays(add: chosenIndex))
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(views: [menuBtn, dateLabel, dayLabel, calendarOrList], animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.7)
        animateTable()
    }

    func animateTable() {
        UIView.animate(views: tasksTable.visibleCells, animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.5)
    }

    func animatePlaceholder() {
        UIView.animate(views: [rocket, quote, author], animations: [AnimationType.from(direction: .top, offset: 20.0)], initialAlpha: 0, finalAlpha: 1, duration: 1)
    }

    // @objc

    @objc
    func newTask(_ sender: AnyObject) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let newVC = NewTaskVC()
        newVC.chosenDate = Date().addDays(add: chosenIndex).startOfDay
        newVC.returnTask = { task in
            print("-----RETURNED TASK-----\n", task)
            if task.mainText.isEmpty {
                return
            }
            self.didReceivedNewTask(task: task)
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pullSound)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        self.present(newVC, animated: true, completion: {
            self.refreshControl.endRefreshing()
        })
    }

    func didReceivedNewTask(task: TaskModel) { // TODO: make global
        if task.isAlarmSet {
            setupReminder(task: task)
        }
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
    func calendarOrListPressed() {}

    func updateTopLabels(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let formattedDate = formatter.string(from: date)
        dateLabel.text = formattedDate
        if date.isToday() { // TODO: make it switch
            dayLabel.text = "Today"
        } else if date.isTomorrow() {
            dayLabel.text = "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            dayLabel.text = formatter.string(from: date)
        }
    }

    func checkDayIsBusy(date: Date) -> Bool { // TODO: move this function
        for task in allTasks {
            if task.taskDate.startOfDay == date.startOfDay {
                return true
            }
            if date.isToday(), task.taskDate.startOfDay < date.startOfDay {
                return true
            }
        }
        return false
    }

    lazy var animatedView = GlassView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))

    func setup() {
        self.view.backgroundColor = .systemBackground

        let safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 1))
        safeAreaView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        safeAreaView.layer.zPosition = 1_000
        self.view.addSubview(safeAreaView)
        self.view.addSubview(rocket)
        self.view.addSubview(quote)
        self.view.addSubview(author)
        self.view.addSubview(tasksTable)

        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: topView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        topView.leadingAnchor.constraint(equalTo: topView.superview!.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: topView.superview!.trailingAnchor, constant: 0).isActive = true

        self.view.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true

        self.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: menuBtn.bottomAnchor, constant: 4).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true // TODO: Test on different languages

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
        tasksTable.showsVerticalScrollIndicator = false // TODO: make tasksTable not transparent
        tasksTable.backgroundColor = .systemBackground
        
        refreshControl.addTarget(self, action: #selector(self.newTask(_:)), for: .valueChanged)
        refreshControl.tintColor = .clear
        refreshControl.layer.zPosition = -1
        refreshControl.addSubview(animatedView)
        tasksTable.refreshControl = refreshControl

        self.view.addSubview(backTodayBtn)
        backTodayBtn.translatesAutoresizingMaskIntoConstraints = false
        backTodayBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backTodayBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        backTodayBtn.centerYAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        backTodayBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26).isActive = true

        self.view.addSubview(calendarOrList)
        calendarOrList.translatesAutoresizingMaskIntoConstraints = false
        calendarOrList.widthAnchor.constraint(equalToConstant: 70).isActive = true
        calendarOrList.heightAnchor.constraint(equalToConstant: 26).isActive = true
        calendarOrList.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor).isActive = true
        calendarOrList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
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
        daysCollectionView?.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        daysCollectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        guard let myCollection = daysCollectionView else {
            return
        }
        self.view.addSubview(myCollection)
    }

    func createTable() {
        tasksTable.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tasksTable.dataSource = self
        tasksTable.delegate = self
    }

    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        if allTasks.isEmpty {
            fetchTasks()
            tasksTable.reloadData()
            daysCollectionView?.reloadData()
            animateTable()
        } else {
            fetchTasks()
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
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchUndone = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
        fetchUndone.predicate = NSPredicate(format: "isDone = false")
        let fetchDone = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
        fetchDone.predicate = NSPredicate(format: "isDone = true")

        // TODO: fix ^
        let fetchAll = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")

        do {
            let objects = try managedContext.fetch(fetchAll)
            allTasks = objects.map { TaskModel(task: $0) }
            allTasks.sort()
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
