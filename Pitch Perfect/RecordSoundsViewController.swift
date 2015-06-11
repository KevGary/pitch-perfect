//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Gary on 6/8/15.
//  Copyright (c) 2015 SikSense. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    //label outlet for recording in progress... optional for nil
    @IBOutlet weak var recordingInProgress: UILabel!
    
    //stop button outlet
    @IBOutlet weak var stopButton: UIButton!
    
    //record button outlet
    @IBOutlet weak var recordButton: UIButton!
    
    //create record button / recordButton action
    @IBAction func recordAudio(sender: UIButton) {
        
        //disable mic
        recordButton.enabled = false
        //show text
        recordingInProgress.hidden = false
        //show stop button
        stopButton.hidden = false
        
        //TODO: record user voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //DELETE THESE LINES TO NOT STORE 
        //wrtie over each time/ no storage
        //let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        //MODIFY THIS NAME
        //sets name of recording
        //let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //add with AVAudioRecorderDelegate
        audioRecorder.delegate = self
        //others
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    //create stop button action / stopButton action
    
    @IBAction func stopRecording(sender: UIButton) {
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        
        recordingInProgress.hidden = true
            
        //enable record button
        recordButton.enabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //TODO: save audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            //TODO: segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording Error")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}
    




