//
//  ViewController.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
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
            if abs(lastOffsetWithSound - roundedOffset) >= lineHeight {
                lastOffsetWithSound = roundedOffset
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }

    // TableView

    private let tasksTable = UITableView()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(title: "hello world")
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemGray6
        } else {
            // Fallback on earlier versions
        }

        let safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.maxY))
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
        tasksTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tasksTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tasksTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    func createCollection() {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 53)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
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
        print(tasksTable.backgroundColor)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
