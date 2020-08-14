//
//  LoginNavigationView.swift
//  Bellwether Coffee
//
//  Created by Gabe The Coder on 12/11/17.
//  Copyright © 2017 Bellwether Coffee. All rights reserved.
//

import UIKit

enum LoginNavigationDirection {
    case forwardst
    case backwardst
}

protocol LoginNavigationViewDelegate: class {
    func loginNavigationDidSegue(_ navigation: LoginNavigationView, direction: LoginNavigationDirection)
}

class LoginNavigationView: ComponentView {
    
    weak var delegate: LoginNavigationViewDelegate?
    
    var pages: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var back: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = .zero
        button.setImage(UIImage(named: "login_backwardst"), for: .normal)
        button.addTarget(self, action: #selector(navigateBackwardst), for: .touchUpInside)
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var currentPage = 0
    
    override func setupViews() {
        addSubview(pages)
        
        pages.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pages.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pages.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(back)
        
        back.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        back.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        back.widthAnchor.constraint(equalToConstant: 44).isActive = true
        back.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    var pageViews: [UIView]! {
        didSet {
            pageViews.forEach {
                pages.addArrangedSubview($0)
            }
            
            let pageMultiplier = CGFloat(pages.arrangedSubviews.count)
            pages.widthAnchor.constraint(equalTo: widthAnchor, multiplier: pageMultiplier).isActive = true
        }
    }
    
    @objc func navigateForwardst() {
        currentPage += 1
        animateToCurrentPage()
        
        delegate?.loginNavigationDidSegue(self, direction: .forwardst)
    }
    
    @objc func navigateBackwardst() {
        currentPage -= 1
        animateToCurrentPage()
        
        delegate?.loginNavigationDidSegue(self, direction: .backwardst)
    }
    
    func navigateToRoot() {
        currentPage = 0
        back.alpha = 0.0
        
        let pageOffset = bounds.width * CGFloat(0.0)
        pages.transform = CGAffineTransform(translationX: -pageOffset, y: 0)
    }
    
    func animateToCurrentPage() {
        let backAlpha = currentPage > 0 ? CGFloat(1.0) : CGFloat(0.0)
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.back.alpha = backAlpha
        }
        
        let pageOffset = bounds.width * CGFloat(currentPage)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, animations: { [unowned self] in
            self.pages.transform = CGAffineTransform(translationX: -pageOffset, y: 0)
        })
    }
    
}
