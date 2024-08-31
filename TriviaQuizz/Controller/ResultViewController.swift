//
//  ResultViewController.swift
//  TriviaQuizz
//
//  Created by God on 25/8/24.
//

import UIKit
import Lottie
import AVFoundation

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    var result = 0
    var animationView: LottieAnimationView?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "\(result)"
        animationView = .init(name: "animation")
        animationView?.frame = view.bounds
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.play()
        playSound()
        
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "ending", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }    
}
