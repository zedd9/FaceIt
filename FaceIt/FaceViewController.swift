//
//  ViewController.swift
//  FaceIt
//
//  Created by Hyeonuk Shin on 2020/12/26.
//

import UIKit

class FaceViewController: UIViewController {
	var expression : FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile){
		didSet {
			updateUI()
		}
	}
	
	@IBOutlet weak var faceView: FaceView!{
		didSet {
			faceView.addGestureRecognizer(
				UIPinchGestureRecognizer(target: faceView,
										 action: #selector(FaceView.changeScale(recognizer:))
				))
			
			let happiersSwipeRecognizer = UISwipeGestureRecognizer(target: self,
																   action: #selector(FaceViewController.increaseHappiness))
			happiersSwipeRecognizer.direction = .up
			faceView.addGestureRecognizer(happiersSwipeRecognizer)
			
			let sadderSwipeRecognizer = UISwipeGestureRecognizer(target: self,
																   action: #selector(FaceViewController.decreaseHappiness))
			sadderSwipeRecognizer.direction = .down
			faceView.addGestureRecognizer(sadderSwipeRecognizer)
			
			updateUI()
		}
		
	}
	
	@IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer)
	{
		if recognizer.state == .ended {
			switch expression.eyes {
			case .Open: expression.eyes = .Closed
			case .Closed: expression.eyes = .Open
			case .Squinting: break
			}
		}
	}
	
	@objc func increaseHappiness()
	{
		expression.mouth = expression.mouth.happierMouth()
	}
	
	@objc func decreaseHappiness()
	{
		expression.mouth = expression.mouth.sadderMouth()
	}
	
	private var mouthCurvature = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,
			.Neutral:0.0]
	private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed:-0.5, .Normal:0.0]
	
	private func updateUI() {
		switch expression.eyes {
		case .Open: faceView.eyesOpen = true
		case .Closed: faceView.eyesOpen = false
		case .Squinting: faceView.eyesOpen = false
		}
		
		faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
		faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
		
	}
}

