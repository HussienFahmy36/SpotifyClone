//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 31/10/2023.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForward(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackward(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewModel {
    let title: String?
    let subtitle: String?
}

final class PlayerControlsView: UIView {
    private var isPlaying = true
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This is subtitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()

    private let playPauseButtonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()

    weak var delegate: PlayerControlsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButtonButton)
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(backwardTappedAction), for: .touchUpInside)
        playPauseButtonButton.addTarget(self, action: #selector(playPauseTappedAction), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardTappedAction), for: .touchUpInside)

        addConstraints()
    }
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    private func addConstraints() {
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ]
        
        let subtitleLabelConstraints = [
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16)
        ]

        let volumeSliderConstraints = [
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            volumeSlider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8)
        ]
        
        let backButtonConstraints = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            backButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 32)
        ]
        
        let playPauseButtonConstraints = [
            playPauseButtonButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButtonButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 32)
        ]
        
        let forwardButtonConstraints = [
            forwardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            forwardButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 32)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(subtitleLabelConstraints)
        NSLayoutConstraint.activate(volumeSliderConstraints)
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(forwardButtonConstraints)
        NSLayoutConstraint.activate(playPauseButtonConstraints)
    }
    
    public func configure(with viewModel: PlayerControlsViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func backwardTappedAction() {
        delegate?.playerControlsViewDidTapBackward(self)
    }
    
    @objc private func playPauseTappedAction() {
        isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPause(self)
        
        let pauseImage = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))

        let playImage = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))

        playPauseButtonButton.setImage(isPlaying ? pauseImage : playImage, for: .normal)
    }

    @objc private func forwardTappedAction() {
        delegate?.playerControlsViewDidTapForward(self)
    }
}
