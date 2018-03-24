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
        let player = MPMusicPlayerController.systemMusicPlayer
        let num = Int(arc4random_uniform(UInt32(songList.count)))
        
        //楽曲情報の表示
        print("総曲数:\(songList.count), 再生位置:\(num)")
        print("曲名:\(songList[num].value(forProperty: MPMediaItemPropertyTitle)!)")
        print("アルバム:\(songList[num].value(forProperty: MPMediaItemPropertyAlbumTitle)!)")
        print("アーティスト:\(songList[num].value(forProperty: MPMediaItemPropertyArtist)!)")
        print("再生時間:\(songList[num].value(forProperty: MPMediaItemPropertyPlaybackDuration)!)秒")
        
        let collection = MPMediaItemCollection.init(items: [songList[num]])
        
        player.setQueue(with: collection)
        player.prepareToPlay()
        player.play()
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
