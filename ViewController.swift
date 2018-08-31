//
//  ViewController.swift
//  swiftMusicPlayerSample_2018_08_28
//
//  Created by kobayashitatsuya on 2018/08/28.
//  Copyright © 2018年 org. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, MPMediaPickerControllerDelegate {

    var player: MPMusicPlayerController!
    
    let artistLabel = UILabel()
    let albumLabel = UILabel()
    let songLabel = UILabel()
    let imageView = UIImageView()
    var playpause = UIButton()
    let reb = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = MPMusicPlayerController.systemMusicPlayer
        player.stop()
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(type(of: self).playPause(notification:)), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        notification.addObserver(self, selector: #selector(type(of: self).nowPlayeyingItemChanged(notification:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        
        
        player.beginGeneratingPlaybackNotifications()
        
        artistLabel.text = ""
        artistLabel.textAlignment = .center
        artistLabel.textColor = .white
        view.addSubview(artistLabel)
        
        albumLabel.text = ""
        albumLabel.textAlignment = .center
        albumLabel.textColor = .white
        view.addSubview(albumLabel)
        
        let playStateButton = UIButton()
        playStateButton.layer.cornerRadius = 25.0
        playStateButton.setTitleColor(UIColor.white, for: UIControlState())
        playStateButton.backgroundColor = UIColor(red: 25, green: 25, blue: 255, alpha: 0)
        playStateButton.addTarget(self, action: #selector(selector(_:)), for: .touchUpInside)
        view.addSubview(playStateButton)
        
        let playState = player.playbackState
        
        if playState == .stopped{
            playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
        }
        else if playState == .paused{
            playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
        }
        
        let stopButton = UIButton()
        stopButton.addTarget(self, action: #selector(Stop(_:)), for: .touchUpInside)
        view.addSubview(stopButton)
        
        reb.addTarget(self, action: #selector(ChangeRepeat(_:)), for: .touchUpInside)
        view.addSubview(reb)
        
        let playing = player.nowPlayingItem
        player.skipToBeginning()
        
        if let media = playing{
            let playstate = player.playbackState
            if playstate == .stopped{
                updateSongInformationUI(media: media)
                player.stop()
                print("stop")
            }else if playstate == .paused{
                updateSongInformationUI(media: media)
            }else{
                updateSongInformationUI(media: media)
                player.stop()
                print("playing")
            }
        }else{
            let query = MPMediaQuery.songs()
            player.setQueue(with: query)
            player.play()
        }
    }
    
    @objc func selector(_: UIButton){
        let picker = MPMediaPickerController()
        picker.delegate = self
        
        picker.allowsPickingMultipleItems = false
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func Play(_: UIButton){
        player.play()
        playpause.addTarget(self, action: #selector(Pause(_:)), for: .touchUpInside)
    }
    
    @objc func Pause(_: UIButton){
        player.pause()
        playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
    }
    
    @objc func Stop(_: UIButton){
        player.stop()
        player.skipToBeginning()
        playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
    }
    
    @objc func ChangeRepeat(_: UIButton){
        player.repeatMode = .one
        reb.addTarget(self, action: #selector(ChangeRepeat(_:)), for: .touchUpInside)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.stop()
        
        player.setQueue(with: mediaItemCollection)
        
        if let media = mediaItemCollection.items.first{
            updateSongInformationUI(media: media)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateSongInformationUI(media: MPMediaItem)
    {
        artistLabel.text = media.artist ?? "不明なアーティスト"
        
        albumLabel.text = media.albumTitle ?? "不明なアルバム"
        
        songLabel.text = media.title ?? "不明な曲"
        
        if let artwork = media.artwork{
            imageView.image = artwork.image(at: imageView.bounds.size)
        }else{
            imageView.image = nil
            imageView.backgroundColor = .gray
        }
        
        player.play()
    }
    
    @objc func nowPlayeyingItemChanged(notification: NSNotification){
        if let media = player.nowPlayingItem{
            updateSongInformationUI(media: media)
            
            playpause.addTarget(self, action: #selector(Pause(_:)), for: .touchUpInside)
        }
    }
    
    @objc func playPause(notification: NSNotification){
        let playState = player.playbackState
        
        if playState == .stopped {
            playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
        }
        
        if playState == .paused {
            playpause.addTarget(self, action: #selector(Play(_:)), for: .touchUpInside)
        }
        
        if playState == .playing {
            playpause.addTarget(self, action: #selector(Pause(_:)), for: .touchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
