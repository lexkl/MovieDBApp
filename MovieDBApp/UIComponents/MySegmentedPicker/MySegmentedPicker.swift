//
//  MySegmentedPicker.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit

final class MySegmentedPicker: UIView {
    private lazy var buttons: [UIButton] = {
        return items.map { item in
            let button = UIButton(frame: .zero)
            button.setTitle(item, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    private let items: [String]
    private let textColor: UIColor
    private let selectedTextColor: UIColor
    private let onChange: (Int) -> Void
    
    init(items: [String], textColor: UIColor, selectedTextColor: UIColor, onChange: @escaping (Int) -> Void) {
        self.items = items
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.onChange = onChange
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MySegmentedPicker {
    
    @objc func onTap(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        buttons.forEach { $0.setTitleColor(textColor, for: .normal) }
        sender.setTitleColor(selectedTextColor, for: .normal)
        onChange(index)
    }
    
    func setupUI() {
        guard let firstButton = buttons.first else { return }
        firstButton.setTitleColor(selectedTextColor, for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.layer.opacity = 1
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
