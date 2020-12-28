//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Hyeonuk Shin on 2020/12/28.
//

import UIKit

class EmotionsViewController: UIViewController {
	private let emotionalFaces: [String: FacialExpression] = [
		"angry": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
		"happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
		"worried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
		"mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin),
	]

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		var destinationVC = segue.destination
		if let navigationController = destinationVC as? UINavigationController {
			destinationVC = navigationController.visibleViewController ?? destinationVC
		}
		if  let faceViewController = destinationVC as? FaceViewController,
			let identifier = segue.identifier,
			let expression = emotionalFaces[identifier]
		{
			faceViewController.expression = expression
			faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
		}
    }
    

}
