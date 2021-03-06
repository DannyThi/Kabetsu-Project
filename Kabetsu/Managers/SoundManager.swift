//
//  SoundManager.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/22.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import AVFoundation

enum SoundFileKey: String, Codable, CaseIterable {
    case phoneTone = "Technology Electronic Cell Phone Ring Tone 03"
    case clownHorn = "Cartoon Clown Horn 01"
    case cartoonHonk = "Cartoon Toy Noisemaker Honk 01"
    var title: String {
        switch self {
        case .phoneTone:
            return "Alarm"
        case .clownHorn:
            return "Horn"
        case .cartoonHonk:
            return "Honk"
        }
    }
}

class SoundManager {
    static let shared = SoundManager()
    private let settings = Settings.shared
    //private var currentSoundEffect = Settings.shared.currentAlertSound
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        NotificationCenter.default.addObserver(forName: Notification.Name.timerDidEnd, object: nil, queue: nil) {
            [weak self] _ in
            self?.playCurrentSoundEffect()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.alertDidDismiss, object: nil, queue: nil) {
            [weak self] _ in
            self?.stopPlayer()
        }
    }
    
    private func playCurrentSoundEffect() {
        guard audioPlayer == nil else { return }
        let soundEffect = settings.currentAlertSound
        guard let path = Bundle.main.path(forResource: soundEffect.rawValue, ofType: "wav") else {
            print("Cannot create path for: \(soundEffect).");
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = Float(settings.volume)
            audioPlayer?.play()
        } catch {
            print("Could not play soundfile: \(soundEffect)")
        }
    }
    
    private func triggerVibration() {        
        // TODO: - Add option to turn on vibration
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    private func stopPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    
    
}
