//
//  FSQView.swift
//  FoursquareARCamera
//
//  Created by Gareth Paul Jones 02/07/2017.
//  Copyright © 2017 Foursquare. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable
class FSQView: UIView {
    var shouldSetupConstraints = true
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var ratingStr: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet var view: FSQView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FSQView", owner: self, options: nil)
        guard let loadedView = view else {
            DDLogWarn("Skipping FSQView setup because nib outlet is unavailable.")
            return
        }

        loadedView.frame = CGRect(x: 0, y: 0, width: 362, height: 291)
        addSubview(loadedView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    class func instanceFromNib() -> FSQView {
        return UINib(nibName: "FSQView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FSQView
    }
}
