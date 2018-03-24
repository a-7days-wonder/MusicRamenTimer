//
//  PlayerViewController.swift
//  MusicRamenTimer
//
//  Created by 永田駿平 on 2018/01/29.
//  Copyright © 2018年 SyunpeiNagata. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController : UIViewController {
    
    var songList = [MPMediaItem]()
    var artworkSize: CGSize = CGSize.init()
    let player = MPMusicPlayerController.systemMusicPlayer
    var num:Int = 0
    var timer = Timer()
    
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Artwork: UIImageView!
    @IBOutlet weak var SongTitle: UILabel!
    @IBOutlet weak var Album: UILabel!
    @IBOutlet weak var Artist: UILabel!
    
    //曲リストを生成する関数
    func makeSongList() {
        let albumsQuery = MPMediaQuery.albums()
        if let albums = albumsQuery.collections {
            for album in albums {
                for song in album.items {
                    let duration: Double = song.value(forProperty: MPMediaItemPropertyPlaybackDuration) as! Double
                    //楽曲の長さが3分±10秒以内ならリストに追加
                    if(170.0 <= duration && duration <= 190.0) {
                        songList.append(song)
                        //print(song.value(forProperty: MPMediaItemPropertyTitle))
                    }
                }
            }
        }
    }
    
    //リストから曲をランダムで再生する関数
    func playSong() {
        num = Int(arc4random_uniform(UInt32(songList.count)))
        
        //楽曲情報の表示
        print("総曲数:\(songList.count), 再生位置:\(num)")
        print("曲名:\(songList[num].value(forProperty: MPMediaItemPropertyTitle)!)")
        print("アルバム:\(songList[num].value(forProperty: MPMediaItemPropertyAlbumTitle)!)")
        print("アーティスト:\(songList[num].value(forProperty: MPMediaItemPropertyArtist)!)")
        print("再生時間:\(songList[num].value(forProperty: MPMediaItemPropertyPlaybackDuration)!)秒")
        
        let collection = MPMediaItemCollection.init(items: [songList[num]])
        artworkSize.width = 240.0
        artworkSize.height = 240.0
        
        Artwork.image = songList[num].artwork?.image(at: artworkSize)
        SongTitle.text = "Title : \(songList[num].value(forProperty: MPMediaItemPropertyTitle) as! String)"
        Album.text = "Album : \(songList[num].value(forProperty: MPMediaItemPropertyAlbumTitle) as! String)"
        Artist.text = "Artist : \(songList[num].value(forProperty: MPMediaItemPropertyArtist) as! String)"
        
        player.setQueue(with: collection)
        player.repeatMode = .none
        player.prepareToPlay()
        setTimeLabel()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTimeLabel), userInfo: nil, repeats: true)
        player.play()
    }
    
    @objc func setTimeLabel() {
        if player.nowPlayingItem != nil {
            Time.text = "残り : \(Int(songList[num].playbackDuration - player.currentPlaybackTime))秒"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSongList()
        playSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
