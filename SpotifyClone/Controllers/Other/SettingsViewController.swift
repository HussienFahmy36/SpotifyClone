//
//  OtherViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureSections()
    }
    
    
    private func configureSections() {
        sections.append(
            Section(
                title: "Profile",
                options: [
                    Option(title: "View your profile", handler: {[weak self] in
                        self?.viewProfile()
                    })
        ]
            )
        )
        
        sections.append(
            Section(
                title: "Account",
                options: [
                    Option(title: "Sign out", handler: {[weak self] in
                        self?.signOutTapped()
                    })
        ]
            )
        )
    }
    
    private func signOutTapped() {
        
    }
    
    private func viewProfile() {
        DispatchQueue.main.async {[weak self] in
            let vc = ProfileViewController()
            vc.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
}
