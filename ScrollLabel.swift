//
//  ScrollLabel.swift
//  swiftMusicPlayerSample_2018_08_28
//
//  Created by kobayashitatsuya on 2018/08/28.
//  Copyright © 2018年 org. All rights reserved.
//

import Foundation
import UIKit

class ScrollLabel: UIView
{
    var label: UILabel!
    var labelColor: UIColor = .red
    var textColor: UIColor = .black
    var TextWidth: CGFloat = 0
    var constraint: NSLayoutConstraint!
    
    var Text: String?{
        willSet{
            
        }
        didSet{
            if let line = Text
            {
                label.text = line
                label.sizeToFit()
                TextWidth = label.frame.width
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initView()
    }
    
    init(color: UIColor){
        super.init(frame: CGRect.zero)
        self.labelColor = color
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView()
    {
        self.backgroundColor = labelColor
        self.clipsToBounds = true

        label = UILabel()
        label.backgroundColor = labelColor
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func startAnimation(){
        let distance = TextWidth - self.frame.width
        if(distance < 0)
        {
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        else
        {
            label.frame.origin.x = self.frame.origin.x
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [.repeat, .curveLinear], animations: {
                self.label.center.x -= 1
            }, completion: {
                finished in
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
                    self.label.center.x -= distance
                }, completion: {
                    finished in
                    UIView.animate(withDuration: 1, animations: {
                        self.label.center.x -= 1
                    }, completion:{
                        finished in
                        self.startAnimation()
                    })
                })
            })
        }
    }
}
