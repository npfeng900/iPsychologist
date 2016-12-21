//
//  FaceView.swift
//  iFace
//
//  Created by Niu Panfeng on 20/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable //storyboard显示FaceView
class FaceView: UIView {
    @IBInspectable //Attributes Inspector显示设置
    var lineWidth: CGFloat = 3 { didSet{ setNeedsDisplay() } }
    @IBInspectable //Attributes Inspector显示设置
    var color: UIColor = UIColor.blueColor() { didSet{ setNeedsDisplay() } }
    @IBInspectable //Attributes Inspector显示设置
    var scale:CGFloat = 0.9 { didSet{ setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
    }
    
    private enum Eye { case Left,Right }
    /** 眼睛 */
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye
        {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        
        return path
    }
    /** 嘴巴 fractionOfMaxMile (-1,1) */
    private func bezierPathForSmileMouth(fractionOfMaxMile: Double) -> UIBezierPath {
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxMile, 1), -1)) * mouthHeight
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
        
    }
    /** 大圆脸 */
    private func bezierPahtForFaceOutLine() ->UIBezierPath {
        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        
        return path
    }
    
    weak var dataSource: FaceViewDataSource?
    /** drawRect */
    override func drawRect(rect: CGRect) {
        
        let smileness: Double = dataSource?.smilinessForFaceView(self) ?? 0.0
        
        color.set()
        bezierPahtForFaceOutLine().stroke()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        bezierPathForSmileMouth(smileness).stroke()

    }
    /** UIPinchGestureRecognizer */
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed
        {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
}
