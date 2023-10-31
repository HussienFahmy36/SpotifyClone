//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var models: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        fetchProfile()
       
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { result in
            DispatchQueue.main.async {[weak self] in
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)

                case .failure(let error):
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }

    private func createTableHeader(with url: String?) {
        guard let urlString = url,
              let url = URL(string: urlString) else {
            return
        }
        let headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.4))
        
        tableView.tableHeaderView = headerView
        headerView.setProfileImage(url: url)
        
    }
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
}
