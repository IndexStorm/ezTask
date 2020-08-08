//
//  MenuVC.swift
//  ezTask
//
//  Created by Mike Ovyan on 04.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import UIKit

protocol MenuVCDelegate {
    func didSelectMenuItem(named: String)
}

class MenuVC: UITableViewController {
    private let menuItems: [String]
    public var delegate: MenuVCDelegate?
    public var chosenRow = 0

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        cell.configure(text: menuItems[indexPath.row], isChosen: chosenRow == indexPath.row)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [IndexPath(row: chosenRow, section: 0)], with: .automatic)
            chosenRow = indexPath.row
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, completion: { _ in
            self.delegate?.didSelectMenuItem(named: self.menuItems[indexPath.row])
        })
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    init(with menuItems: [String]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        
        self.tableView.backgroundColor = .secondarySystemBackground
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.contentInset.top = 32
        self.tableView.isScrollEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableView.reloadData()
    }
}
