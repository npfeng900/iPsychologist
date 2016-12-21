//
//  HistoryViewController.swift
//  iPsychologist
//
//  Created by Niu Panfeng on 21/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
    /** 自适应textView的内容，或者为presentingViewController分配的合适大小 */
    override var preferredContentSize: CGSize {
        get{
            //presentingViewController为DiagnosedFaceViewController
            if textView != nil && presentingViewController != nil
            {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }
            else
            {
                return super.preferredContentSize
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
}
