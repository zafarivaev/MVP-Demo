//
//  ViewController.swift
//  MVP-Realm
//
//  Created by Zafar on 1/28/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

protocol ItemsView: class {
    func onItemsRetrieval(titles: [String])
    func onItemAddSuccess(title: String)
    func onItemAddFailure(message: String)
    func onItemDeletion(index: Int)
}

class ItemsViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavItem()
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add new Item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction()
        let add = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let title = alert.textFields?.first!.text, !title.isEmpty {
                self?.presenter.addTapped(with: title)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Item's title"
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    var presenter: ItemsViewPresenter!
    var titles: [String] = []
    
    lazy var addBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        item.tintColor = .systemYellow
        return item
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView
            .translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

}

// MARK: - View Protocol
extension ItemsViewController: ItemsView {
    
    func onItemsRetrieval(titles: [String]) {
        print("View recieves the result from Presenter.")
        self.titles = titles
        self.tableView.reloadData()
    }
    
    func onItemAddSuccess(title: String) {
        print("View recieves the result from Presenter.")
        self.titles.append(title)
        self.tableView.reloadData()
    }
    
    func onItemAddFailure(message: String) {
        print("View recieved a failure result from Presenter: \(message)")
    }
    
    func onItemDeletion(index: Int) {
        self.titles.remove(at: index)
        self.tableView.reloadData()
    }
}

// MARK: - UITableView Data Source
extension ItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteSelected(for: indexPath.row)
        }
    }
    
    
}

// MARK: - UI Setup
extension ItemsViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
    private func setupNavItem() {
        self.navigationItem.rightBarButtonItem = addBarItem
    }
}

