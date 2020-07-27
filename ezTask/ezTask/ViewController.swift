//
//  MainVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import CoreData
import UIKit
import UserNotifications
import ViewAnimator

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, UNUserNotificationCenterDelegate {
    // Var

    var lastOffsetWithSound: CGFloat = 0
    var chosenDate: Int = 0

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
        label.text = "July 18, 2020"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()

    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()

    let backTodayBtn: UIButton = {
        // TODO: add arrow icon
        let btn = UIButton(type: .system)
        btn.setTitle("Today", for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
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

    // CollectionView

    private var daysCollectionView: UICollectionView?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView?.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
        cell.configure(name: "Mon", number: indexPath[1] + 1, busy: true, isChosen: indexPath[1] == chosenDate)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        cell.contentView.alpha = 1
        chosenDate = indexPath[1]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    var undoneTasks: [NSManagedObject] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return undoneTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = undoneTasks[undoneTasks.count - indexPath.row - 1] // TODO: fix by sorting
        let model = TaskModel(task: task)
        cell.configure(task: model)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func checkboxTapped(cell: TaskCell) {
        if let indexPath = tasksTable.indexPath(for: cell) {
            if let id = cell.id {
                setDone(id: id.uuidString)
            }
            undoneTasks.remove(at: indexPath.row)
            tasksTable.deleteRows(at: [indexPath], with: .fade)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

    private func insertNewTask(task: TaskModel) {
        save(model: task, completion: {
            fetchUndoneTasks()
        })
        tasksTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUndoneTasks()
//        tasksTable.reloadData() // TODO:call every time view is on the screen
    }

    @objc
    func newTask(_ sender: AnyObject) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let newVC = NewTaskVC()
        newVC.returnTask = { task in
            print("-----RETURNED TASK-----\n", task)
            if task.mainText.isEmpty {
                return
            }
            self.DidReceivedNewTask(task: task)
        }
        self.present(newVC, animated: true, completion: {
            self.refreshControl.endRefreshing()
        })
    }

    func DidReceivedNewTask(task: TaskModel) {
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
        self.chosenDate = 0
        UIView.animate(withDuration: 1) {
            myCollection.setContentOffset(CGPoint.zero, animated: true)
        }
        UIView.animate(withDuration: 0.2) {
            self.backTodayBtn.alpha = 0
        }
        myCollection.reloadData()
    }

    @objc
    func calendarOrListPressed() {}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: fix animation
        UIView.animate(views: [dateLabel, dayLabel, calendarOrList], animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.5)
        UIView.animate(views: tasksTable.visibleCells, animations: [AnimationType.from(direction: .top, offset: 10.0)], initialAlpha: 0, finalAlpha: 1, duration: 0.5)
    }

    func setup() {
        self.view.backgroundColor = .white

        let safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY + 1))
        safeAreaView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4156862745, blue: 0.9960784314, alpha: 1)
        safeAreaView.layer.zPosition = 1_000
        self.view.addSubview(safeAreaView)
        self.view.addSubview(tasksTable)

        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: topView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        topView.leadingAnchor.constraint(equalTo: topView.superview!.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: topView.superview!.trailingAnchor, constant: 0).isActive = true

        self.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 21).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

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
        myCollection.heightAnchor.constraint(equalToConstant: 53).isActive = true
        myCollection.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive = true
        myCollection.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 0).isActive = true
        myCollection.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 16).isActive = true

        createTable()

        tasksTable.translatesAutoresizingMaskIntoConstraints = false
        tasksTable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        tasksTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tasksTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tasksTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        tasksTable.separatorStyle = .none
        tasksTable.contentInset.top = 10
        tasksTable.contentInset.bottom = 10

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to add a new task", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.newTask(_:)), for: .valueChanged)
        refreshControl.tintColor = .green
        refreshControl.layer.zPosition = -1
        tasksTable.refreshControl = refreshControl

        self.view.addSubview(backTodayBtn)
        backTodayBtn.translatesAutoresizingMaskIntoConstraints = false
        backTodayBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
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
        layout.itemSize = CGSize(width: 40, height: 53)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainVC {
    func fetchUndoneTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
        fetchRequest.predicate = NSPredicate(format: "isDone = false")
        do {
            undoneTasks = try managedContext.fetch(fetchRequest)
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
