//
//  ViewController.swift
//  MemoryLeaksCheck
//
//  Created by Hoang Anh Tuan on 23/09/2023.
//

import UIKit
import SnapKit

enum ScenarioType: String {
    case abandoned = "Abandoned Memory Example"
    case leaks = "Leaks Memory Example"
}

final class ViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let scenarios: [ScenarioType] = [.abandoned, .leaks]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.title = "Scenarios"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scenarios.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = scenarios[indexPath.row].rawValue
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scenario = scenarios[indexPath.row]
        switch scenario {
            case .abandoned:
                let vc = AbandonedMemoryVC()
                navigationController?.pushViewController(vc, animated: true)
            case .leaks:
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let vc = HomeViewController()
                appDelegate.window?.rootViewController = vc
        }
    }
    
}
