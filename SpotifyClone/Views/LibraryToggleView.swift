//
//  LibraryToggleView.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 02/11/2023.
//

import UIKit
protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_  toggleView:LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_  toggleView:LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum LibraryToggleViewState {
        case album
        case playlist
    }

    private let segmentedControlBar: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        return view
    }()
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Playlists", "Albums"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.tintColor = .clear
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return segmentedControl
    }()
    
    public var delegate: LibraryToggleViewDelegate?
    private var state: LibraryToggleViewState = .playlist
    
    public func set(_ state: LibraryToggleViewState) {
        self.state = state
        updateView()
    }
    
    public func getState() -> LibraryToggleViewState {
        state
    }
    
    private func addConstraints() {
        let segmentedControlBarConstraints = [
            segmentedControlBar.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            segmentedControlBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentedControlBar.heightAnchor.constraint(equalToConstant: 3),
            segmentedControlBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0/CGFloat(segmentedControl.numberOfSegments))
        ]
        let segmentedControlConstraints = [
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(segmentedControlBarConstraints)
        NSLayoutConstraint.activate(segmentedControlConstraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(segmentedControlBar)
        addSubview(segmentedControl)
        addConstraints()
        segmentedControl.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func updateView() {
        switch state {
        case .album:
            self.segmentedControl.selectedSegmentIndex = 1
        case .playlist:
            self.segmentedControl.selectedSegmentIndex = 0
        }
        animateSegmentedBar()
    }

    private func animateSegmentedBar() {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.segmentedControlBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
    }
    
    @objc private func segmentTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            state = .playlist
            didTapPlaylists()
        case 1:
            state = .album
            didTapAlbums()
        default: break
        }
    }
    
    @objc private func didTapPlaylists() {
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
}
