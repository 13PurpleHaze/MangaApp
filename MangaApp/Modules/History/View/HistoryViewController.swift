//
//  HistoryViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

import UIKit

class HistoryViewController: UIViewController {
    private var tableView = UITableView()
    let presenter: HistoryViewOutput

    init(presenter: HistoryViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //presenter.fetchHistory()
    }
    
    // FIXME: переместить fetchHistory в правильное место, он должен вызываться при set view.alpha = 1
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.fetchHistory()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupHistoryList()
    }
    
    private func setupHistoryList() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        //tableView.isEditing = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = presenter.history[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(text: presenter.history[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.removeHistoryRequest(text: presenter.history[indexPath.row])
        tableView.reloadData()
    }
}


extension HistoryViewController: HistoryViewInput {
    func updateUI(state: ViewState) {
        if state == .isSuccess {
            tableView.reloadData()
        }
    }
}
