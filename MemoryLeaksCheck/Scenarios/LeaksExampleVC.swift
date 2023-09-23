//
//  LeaksExample.swift
//  MemoryLeaksCheck
//
//  Created by Hoang Anh Tuan on 23/09/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    
    private let randomNumberLabel = UILabel()
    private let changeRootVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Simulate Logout then Login Action", for: .normal)
        button.addTarget(self, action: #selector(simulateLogOutThenLogInBehaviour), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memory Leaks Example"
        view.backgroundColor = .white
        
        let randomInt = Int.random(in: 1..<1000)
        randomNumberLabel.text = "Random number: \(randomInt)"
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(randomNumberLabel)
        view.addSubview(changeRootVCButton)
        
        randomNumberLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        changeRootVCButton.snp.makeConstraints {
            $0.top.equalTo(randomNumberLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func simulateLogOutThenLogInBehaviour() {
        print("Simulate logout then login action")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = HomeViewController()
    }
}

final class HomeViewModel {
    
    var callback: ((Int) -> Void)?
    var number: Int = 5
    
    init() {
        callback = {
            self.number = $0
        }
    }
    
}
