//
//  MessageBubble.swift
//  Gosio
//
//  Created by ANKIT YADAV on 11/03/21.
//

import Foundation
import UIKit
//
//class MessageBubble: UIView {
//
//    var borderWidth : CGFloat = 4 // Should be less or equal to the `radius` property
//    var radius : CGFloat = 10
//    var triangleHeight : CGFloat = 15
//
//    private func bubblePathForContentSize(contentSize: CGSize) -> UIBezierPath {
//
//        let rect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height).offsetBy(dx: radius, dy: radius + triangleHeight)
//        let path = UIBezierPath();
//        let radius2 = radius - borderWidth / 2 // Radius adjasted for the border width
//
//        path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
//        path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY), radius: radius2, startAngle: CGFloat(-Double.pi/2), endAngle: 0, clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius2, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY), radius: radius2, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi/2), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY), radius: radius2, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(-Double.pi/2), clockwise: true)
//
//        path.close()
//        return path
//    }
//
//}

public extension UIView {

    enum PeakSide: Int {
        case Top
        case Left
        case Right
        case Bottom
    }

    func addPikeOnView(side: PeakSide, size: CGFloat = 10.0) {
        self.layoutIfNeeded()
        let peakLayer = CAShapeLayer()
        var path: CGPath?
        switch side {
        case .Top:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
        case .Left:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
        case .Right:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
        case .Bottom:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
        }
        peakLayer.path = path
//        let color = (self.backgroundColor ?? .clearColor()).CGColor
        peakLayer.fillColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        peakLayer.strokeColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        self.layer.insertSublayer(peakLayer, at: 0)
    }


    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11

        let centerX = rect.width / 2
        let centerY = rect.height / 2
        var h: CGFloat = 0
        let path = CGMutablePath()
        var points: [CGPoint] = []
        // P1
        points.append(CGPoint(x: rect.origin.x, y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            h = ts * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y
            
            points.append(CGPoint(x: x - ts, y: y))
            points.append(CGPoint(x: x, y: y-h))
            points.append(CGPoint(x: x + ts, y: y))
        }

        // P5
        points.append(CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            h = rs * sqrt(3.0) / 2
            let x = rect.origin.x + rect.width
            let y = rect.origin.y + centerY
            
            points.append(CGPoint(x: x, y: y - rs))
            points.append(CGPoint(x: x + h, y: y))
            points.append(CGPoint(x: x, y: y + rs))
            
        }

        // P9
        points.append(CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            h = bs * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y + rect.height
            
            
            points.append(CGPoint(x: x, y: y))
            points.append(CGPoint(x: x, y: y+h))
            points.append(CGPoint(x: x-bs, y: y))
            
        }

        // P13
        points.append(CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left side
        if ls > 0 {
            h = ls * sqrt(3.0) / 2
            let x = rect.origin.x
            let y = rect.origin.y + centerY
            
            points.append(CGPoint(x: x, y: ls))
            points.append(CGPoint(x: x-h, y: y))
            points.append(CGPoint(x: x, y: y - ls))
        }

        let startPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        for point in points {
            self.addPoint(point: point, toPath: path)
        }
        self.addPoint(point: startPoint, toPath: path)
        return path
    }

    private func startPath(path: CGMutablePath, onPoint point: CGPoint) {
        path.move(to: CGPoint(x: point.x, y:  point.y))
    }

    private func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        path.move(to: CGPoint(x: point.x, y:  point.y))
    }

}
