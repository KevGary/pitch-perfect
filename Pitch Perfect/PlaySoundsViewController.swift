 //
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Gary on 6/8/15.
//  Copyright (c) 2015 SikSense. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    //variable for passing data
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    
    //variable convert NSURL to AudioFile
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set file path for Audio

//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathURL = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL, error: nil)
//            audioPlayer.enableRate = true
//        }
//        else {
//                println("filePath empty")
//        }
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //initialize
        audioEngine = AVAudioEngine()
        
        //pass our recorded audio received from main view controller to audioFile, an instance of AVAudioFile (NSURL to AudioFile)
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //helper function for two actions below
    func audioBlock(currentTime: NSTimeInterval, rate: Float) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = currentTime
        audioPlayer.rate = rate
        audioPlayer.play()
    
    }
        
    @IBAction func slowAudio(sender: UIButton) {
        //play audio slowly
        audioBlock(0.0, rate: 0.5)
    }

    @IBAction func fastAudio(sender: UIButton) {
        audioBlock(0.0, rate: 2.0)
    }
    
    @IBAction func stopButton2(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func chipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    //helper function for chipmunk
    func playAudioWithVariablePitch(pitch: Float) {
    
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        //schedule audioFile to play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        //start audio engine
        audioEngine.startAndReturnError(nil)
        
        //play audioFile
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
