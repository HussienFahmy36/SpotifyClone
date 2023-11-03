//
//  extensions.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import Foundation
import UIKit

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

extension String {
    func toFormattedDate() -> String {
        guard let date = DateFormatter.dateFormatter.date(from: self) else { return "" }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}

extension UIViewController {
    func showLoadingIndicator() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.backgroundColor = .systemGreen.withAlphaComponent(0.9)
        indicator.color = .black
        indicator.tag = 111
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        indicator.layer.cornerRadius = 4
        indicator.clipsToBounds = true
        
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        guard let indicatorView = view.subviews.first { $0.tag == 111 } as? UIActivityIndicatorView else { return }
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
}

extension UIImageView {
    func makeRounded() {
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension String {
    var toURL: URL? {
        URL(string: self)
    }
}
