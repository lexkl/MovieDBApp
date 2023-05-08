//
//  DashboardViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit
import Combine

final class DashboardViewController: MVVMViewController<DashboardViewModel> {
    private var segmentedPicker: MySegmentedPicker!
    private var contentView: UIView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func bindUI() {
        view.backgroundColor = .mainGray
        setupSegmentedPicker()
        setupContentView()
        
        viewModel.segmentChangedPublisher
            .sink { [weak self] viewController in
                guard let self, let viewController else { return }
                self.removeChildren()
                self.add(childController: viewController, on: self.contentView)
            }
            .store(in: &cancellables)
        
        viewModel.changeSegment(DashboardSegment.popular.rawValue)
    }
}

// MARK: - setup UI

private extension DashboardViewController {
    func setupSegmentedPicker() {
        segmentedPicker = MySegmentedPicker(items: viewModel.segments.map { $0.title },
                                            textColor: .secondaryGray,
                                            selectedTextColor: .black,
                                            onChange: viewModel.changeSegment)
        view.addSubview(segmentedPicker)
        
        segmentedPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedPicker.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupContentView() {
        contentView = UIView(frame: .zero)
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: segmentedPicker.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
