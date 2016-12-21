//
//  ViewController.swift
//  iPsychologist
//
//  Created by Niu Panfeng on 20/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    //代码触发Segue
    @IBAction func btnActNothing(sender: UIButton) {
        performSegueWithIdentifier("showNothing", sender: nil)
    }
    
    //为Segue准备
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        //中间存在UINavigationController时，运行下面的转换过程
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController!
        }
        
        if let hvc = destination as? FaceViewController
        {
            if let identifier = segue.identifier
            {
                switch identifier
                {
                case "showHappy":
                        hvc.happiness = 100
                case "showSad":
                        hvc.happiness = 0
                case "showNothing":
                        hvc.happiness = 60
                default:
                    hvc.happiness = 50
                }
            }
        }
    }
}

