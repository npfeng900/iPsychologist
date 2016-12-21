//
//  DiagnosedFaceViewController.swift
//  iPsychologist
//
//  Created by Niu Panfeng on 21/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class DiagnosedFaceViewController: FaceViewController, UIPopoverPresentationControllerDelegate {

    /** 重写FaceViewController的happiness，但不会覆盖，两个并存 */
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    /** 记录happiness的纪录（因为Segues always create a new instace of an MVC,所以要数据持久化处理） */
    private let defaults = NSUserDefaults.standardUserDefaults()
    var diagnosticHistory: [Int] {
        get {
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: History.DefaultsKey)
        }
    }
    
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedFaceViewController.History"
    }
    
    /** 为Segue准备 */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case History.SegueIdentifier:
                if let historyVC = segue.destinationViewController as? HistoryViewController
                {
                    if let ppc = historyVC.popoverPresentationController
                    {
                        ppc.delegate = self
                    }
                    historyVC.text = "\(diagnosticHistory)"
                }
            default:
                break
            }
        }
    }
    /** Popover窗口大小 */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}
