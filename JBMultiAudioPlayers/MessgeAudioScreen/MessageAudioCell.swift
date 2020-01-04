
import UIKit
import SwiftAudio

class MessageAudioCell: UITableViewCell {
    // MARK:  outlets
    @IBOutlet private weak var customImageView: UIImageView!
    @IBOutlet weak private var playPauseButton: UIButton!
    @IBOutlet weak private var bubbleImageView: UIImageView!
    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    
    // MARK: Properties
    var player: AudioPlayer!
    var lastLoadFailed = false
    var animator: UIViewPropertyAnimator!
    
    
    // MARK: observables
    weak var audioPlayerDelegate: JBAudioController2! {
        didSet {
            audioPlayerDelegate.appendPlayer(player: player)
        }
    }
    var msgURL: String! {
        didSet {
            try? player.load(item:DefaultAudioItem(audioUrl: msgURL, sourceType: .stream),playWhenReady: false)
        }
    }
    var audioContollerDelegate: JBAudioController2! {
        didSet {
            audioContollerDelegate.appendPlayer(player: player)
        }
    }
    var currentTime: TimeInterval! {
        didSet {
            //progressBar.progress = Float(currentTime / (audioDuration ?? 1))
            durationLabel.text = format(duration: currentTime)
        }
    }
    var audioDuration: Double? {
        didSet {
            guard let duration = audioDuration else {return}
            durationLabel.text = format(duration: duration)
            animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.progressBar.setProgress(1.0, animated: true)
            }
        }
    }
    var playerStatus: AudioStatus = .idle {
        didSet {
            //update animation + update button // update progress
            playPauseButton.setImage(playerStatus.audioImage, for: .normal)
            switch playerStatus {
            case .playing:
                self.progressBar.progress = Float(currentTime ?? 0 / (audioDuration ?? 1))
                animator.startAnimation()
                break
            case .paused:
                animator.pauseAnimation()
                progressBar.progress = Float(currentTime ?? 0 / (audioDuration ?? 1))
            default:
                break
            }
        }
    }
    // MARK: Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
        applybubbletheme()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar.progress = 0.0
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPlayer()
    }
    func setupProfileImage() {
        customImageView.layer.cornerRadius = customImageView.frame.width / 2
        customImageView.layer.masksToBounds = true
        customImageView.tintColor = UIColor.systemGreen
    }
    func applybubbletheme(){
        var image = UIImage(named: "bubble-not-owner")!
        if Locale.current.languageCode ?? "" == "ar"{
            image = image.withHorizontallyFlippedOrientation()
        }
        bubbleImageView.image = image
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17,
                                                        left: 21,
                                                        bottom: 17,
                                                        right: 21),
                            resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        
        bubbleImageView.backgroundColor = .clear
        bubbleImageView.layer.cornerRadius = 0
    }
    // MARK: Methods and Actions
    @IBAction func playPause(_ sender: UIButton) {
        guard audioPlayerDelegate != nil else {return}
        audioPlayerDelegate.currentPlayer = player
        togglePlay()
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: duration)!
    }
}


// MARK: Handler and listerner
extension MessageAudioCell {
    fileprivate func initPlayer() {
        player = AudioPlayer(remoteCommandController: RemoteCommandController())
        player.remoteCommands = [
            .stop,
            .pause,
            .play,
            .togglePlayPause]
        
        addListener()
    }
    func addListener() {
        player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
        player.event.playbackEnd.addListener(self, handleFinishState)
        player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
    }
    func handleAudioPlayerStateChange(data: AudioPlayer.StateChangeEventData) {
        DispatchQueue.main.async {
            switch data {
            case .ready:
                self.audioDuration = self.player.duration
            case .paused, .playing, .idle:
                DispatchQueue.main.async {
                    self.playerStatus.setStatus(state: self.player.playerState)
                }
            default: break
            }
        }
    }
    
    func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
        let currentTime = self.player.currentTime
        DispatchQueue.main.async {
            self.currentTime = currentTime
        }
    }
    func handleFinishState(data: AudioPlayer.PlaybackEndEventData) {
        print(data)
        DispatchQueue.main.async {
            switch data {
            case .playedUntilEnd:
                self.player.seek(to: 0)
                //self.player.nowPlayingInfoController.clear()
                self.audioPlayerDelegate.currentPlayerDidFinished = true
                DispatchQueue.main.async {
                    self.currentTime = 0
                    //self.progressBar.progress = 0
                }
            default: break
            }
            
        }
    }
    
    func togglePlay(){
        if !audioPlayerDelegate.audioSessionController.audioSessionIsActive {
            try? audioPlayerDelegate.audioSessionController.activateSession()
        }
        // check if its ready
        if lastLoadFailed, let item = player.currentItem {
            lastLoadFailed = false
            //error
            try? player.load(item: item, playWhenReady: true)
        }
        else {
            player.togglePlaying()
        }
    }
}
