//
//  CustomSegmentedControl.swift
//  SegmentedController
//
//  Created by SaiKiran Panuganti on 20/12/19.
//  Copyright © 2019 SaiKiran Panuganti. All rights reserved.
//

import Foundation
import UIKit


protocol CustomSegmentedControlDelegate : class {
    func customSegmentedControlAction(segment : Int)
}

protocol CustomSegmentedControlDataSource:class
{
    var buttonTitles:[String] {get}
}

class CustomSegmentedControl : UIView {
    
    var buttonTitles : [String]!
    private var buttons : [UIButton]!
    private var selectorView : UIView!
    weak var delegate : CustomSegmentedControlDelegate?
    weak var dataSource:CustomSegmentedControlDataSource?
    
    var textColor : UIColor = Config.shared.colors.greyTextColor
    var selectorTextColor : UIColor = Config.shared.colors.navBarColor
    var selectorViewColor : UIColor = Config.shared.colors.navBarColor
    var viewBackgroundColor : UIColor = Config.shared.colors.backgroundColor
    let buttonsFont : UIFont = Config.shared.fontStyles.regular3
    
    var selectedIndex: Int = 0
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = viewBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bottomView = UIView()
        self.addSubview(bottomView)
        updateView()
    }
    
    func updateView(){
        buttonTitles = self.dataSource?.buttonTitles ?? []
        createButtons()
        //SelectorView()
        configStackView()
    }
    
    private func configStackView(){
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant:20).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        let selectorWidth = (frame.width-40)/CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height-4, width: selectorWidth, height: 4))
        //selectorView.layer.cornerRadius = 5
        selectorView.layer.borderWidth = 2
        selectorView.layer.borderColor = selectorViewColor.cgColor
        selectorView.backgroundColor = selectorViewColor
        stack.addSubview(selectorView)
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles{
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = Config.shared.fontStyles.regular3
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[selectedIndex].setTitleColor(selectorTextColor, for: .normal)
    }
    
    func updateButtonTitles()
    {
        if let titles = self.dataSource?.buttonTitles, buttons != nil, buttons.count > 0
        {
            for (i,title) in titles.enumerated() {
                buttons[i].setTitle(title, for: .normal)
            }
        }
    }
    
    @objc func buttonAction(sender : UIButton){
        for (buttonIndex, btn) in buttons.enumerated(){
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender{
                let buttonWidth = (frame.width-40)/CGFloat(buttonTitles.count)
                let selectorPosition = buttonWidth*CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
                selectedIndex = buttonIndex
                delegate?.customSegmentedControlAction(segment : buttonIndex)
            }
        }
    }
    
}

