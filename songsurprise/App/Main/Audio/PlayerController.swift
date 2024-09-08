//
//  PlayerController.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController {
    
    private var index: Int
    private var tracks: [Track]
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var currentMinutes: Int = 0
    private var minutes: Int = 0
    private var seconds: Int = 0
    private var currentSeconds: Int = 0
    
    private lazy var coverAlbum = UIImageView()
    private lazy var durationSlider = SliderControl()
    private lazy var durationView = UIView()
    private lazy var startTimeLabel = UILabel()
    private lazy var endTimeLabel = UILabel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#9ca3af")!
        
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        button.tintColor = .label
        button.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .label
        
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        button.tintColor = .label
        
        return button
    }()
    
    init(index: Int, tracks: [Track]) {
        self.index = index
        self.tracks = tracks
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(coverAlbum, titleLabel, detailsLabel, durationSlider, durationView, playPauseButton, nextButton, backButton)
        
        coverAlbum.constraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: UIScreen.main.bounds.width))
        
        titleLabel.centerXconstraint(for: view)
        detailsLabel.centerXconstraint(for: view)
        titleLabel.constraints(top: coverAlbum.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 35, left: 0, bottom: 0, right: 0))
        detailsLabel.constraints(top: titleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        
        durationSlider.constraints(top: detailsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 35, left: 10, bottom: 0, right: 15), size: .init(width: 0, height: 35))
        durationView.constraints(top: durationSlider.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 15), size: .init(width: 0, height: 25))
        durationView.addSubviews(startTimeLabel, endTimeLabel)
        startTimeLabel.constraints(top: nil, leading: durationView.leadingAnchor, bottom: nil, trailing: nil)
        startTimeLabel.centerYconstraint(for: durationView)
        endTimeLabel.centerYconstraint(for: durationView)
        endTimeLabel.constraints(top: nil, leading: nil, bottom: nil, trailing: durationView.trailingAnchor)
        
        playPauseButton.centerXconstraint(for: view)
        playPauseButton.constraints(top: durationView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 45, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        backButton.constraints(top: durationView.bottomAnchor, leading: nil, bottom: nil, trailing: playPauseButton.leadingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: 45), size: .init(width: 70, height: 70))
        nextButton.constraints(top: durationView.bottomAnchor, leading: playPauseButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 45, left: 45, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        
        durationSlider.onEditingChanged = { isEditing in
            if !isEditing, let player = self.player {
                player.currentTime = TimeInterval(Float(self.durationSlider.value))
                if TimeInterval(Float(self.durationSlider.value)) == player.duration {
                    self.didTapNextButton()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    private func play(_ url: URL) {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {
                print("player is nil")
                return
            }
            player.delegate = self
            player.play()
            
            durationSlider.valueRange = 0...Float(player.duration)
            
            minutes = Int(player.duration / 60)
            seconds = Int(player.duration.truncatingRemainder(dividingBy: 60))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configurePlayer() {
        let song = tracks[index]
        coverAlbum.image = UIImage(named: song.imageName)
        titleLabel.text = song.artistName
        detailsLabel.text = song.trackName
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackAudio), userInfo: nil, repeats: true)
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        do {
            let endpoint = try Client.http.supabase().storage.from("audio").getPublicURL(path: song.endpoint)
            StorageManager.shared.getAudioFile(endpoint: endpoint) { result in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        self.play(url)
                    }
                    break
                case .failure(_):
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc
    func trackAudio() {
        guard let player = player else {
            return
        }

        DispatchQueue.main.async {
            self.durationSlider.value = Float(player.currentTime)
            self.currentMinutes = Int(player.currentTime / 60);
            self.currentSeconds = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
            self.startTimeLabel.text = String(format: "%02i:%02i", self.currentMinutes, self.currentSeconds)
            self.endTimeLabel.text = String(format: "%02i:%02i", self.minutes, self.seconds)
        }
    }
    
    @objc
    func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc
    func didTapPrevButton() {
        if index > 0 {
            index = index - 1
            stopTimer()
            configurePlayer()
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc
    func didTapNextButton() {
        if index < (tracks.count - 1) {
            index = index + 1
            stopTimer()
            configurePlayer()
        } else {
            dismiss(animated: true)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        player?.stop()
        player = nil
        timer = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerController: AVAudioPlayerDelegate {}
