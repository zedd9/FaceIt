//
//  FaceView.swift
//  FaceIt
//
//  Created by Hyeonuk Shin on 2020/12/26.
//

import UIKit

@IBDesignable
class FaceView: UIView {
	
	@IBInspectable var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() }}
	@IBInspectable var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() }}    // 1.0 is full smile, and -1.0 is full frown
	@IBInspectable var eyesOpen: Bool = false { didSet { setNeedsDisplay() }}
	@IBInspectable var eyeBrowTilt: Double = -0.5 { didSet { setNeedsDisplay() }}	// -1 full furrow, 1 fully relaxed
	@IBInspectable var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() }}
	@IBInspectable var color: UIColor = UIColor.black { didSet { setNeedsDisplay() }}
	
	private var skullRadius: CGFloat{
		return min(bounds.height, bounds.width) / 2 * scale
	}
	private var skullCenter : CGPoint{
		return CGPoint(x: bounds.midX, y: bounds.midY)
	}
	
	private struct Ratios {
		static let SkullRadiusToEyeOffset: 		CGFloat = 3
		static let SkullRadiusToEyeRadius: 		CGFloat = 10
		static let SkullRadiusToEyeSeparation:	CGFloat = 1.5
		static let SkullRadiusToBrowOffset: 	CGFloat = 5
		static let SkullRadiusToMouthWidth: 	CGFloat = 1
		static let SkullRadiusToMouthHeight: 	CGFloat = 3
		static let SkullRadiusToMouthOffset: 	CGFloat = 3
	}
	
	private enum Eye{
		case Left
		case Right
	}
	
	@objc func changeScale(recognizer: UIPinchGestureRecognizer)
	{
		switch recognizer.state {
		case .changed, .ended:
			scale *= recognizer.scale
			recognizer.scale = 1.0
		default:
			break
		}
	}
	
	private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
	{
		let path = UIBezierPath(
			arcCenter: midPoint,
			radius: radius,
			startAngle: 0.0,
			endAngle: CGFloat(2*Double.pi),
			clockwise: false
		)
		path.lineWidth = lineWidth
		return path
		
	}
	
	private func getEyeCenter(eye: Eye) -> CGPoint
	{
		let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
		var eyeCenter = skullCenter
		eyeCenter.y -= eyeOffset
		switch eye {
		case .Left: eyeCenter.x -= eyeOffset
		case .Right: eyeCenter.x += eyeOffset
		}
		return eyeCenter
	}
	
	private func pathForEye(eye: Eye) -> UIBezierPath {
		let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
		let eyeCenter = getEyeCenter(eye:eye)
		if eyesOpen {
			return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
		}
		let path = UIBezierPath()
		path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
		path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
		path.lineWidth = lineWidth
		return path
	}
	
	private func pathForBrow(eye: Eye) -> UIBezierPath
	{
		let tilt = eye == .Left ? eyeBrowTilt * -1 : eyeBrowTilt
		var browCenter = getEyeCenter(eye:eye)
		browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
		let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
		let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
		let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
		let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
		let path = UIBezierPath()
		path.move(to:browStart)
		path.addLine(to: browEnd)
		path.lineWidth = lineWidth
		return path
	}
	
	private func pathForMouth() -> UIBezierPath {
		let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
		let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
		let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
		
		let mouthOrigin = CGPoint(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset)
		let mouthSize = CGSize(width: mouthWidth, height: mouthHeight)
		let mouthRect = CGRect(origin: mouthOrigin, size: mouthSize)
		
		let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
		
		let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
		let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
		
		let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
		let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: end.y + smileOffset)
		
		let path = UIBezierPath()
		path.move(to: start)
		path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
		path.lineWidth = lineWidth
		
		return path
		
	}
	
	override func draw(_ rect: CGRect) {
		color.set()
		pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
		pathForEye(eye:.Left).stroke()
		pathForBrow(eye:.Left).stroke()
		pathForEye(eye:.Right).stroke()
		pathForBrow(eye:.Right).stroke()
		pathForMouth().stroke()
	}
	
}
