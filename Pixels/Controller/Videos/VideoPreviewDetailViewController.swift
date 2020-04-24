//
//  VideoPreviewDetailViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoPreviewDetailViewController: UIViewController {

    var moviePlayer:MPMoviePlayerController!

    override func viewDidLoad() {
       super.viewDidLoad()

        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!

        moviePlayer = MPMoviePlayerController(contentURL: url as URL)
       moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)

       self.view.addSubview(moviePlayer.view)
        moviePlayer.isFullscreen = true

        moviePlayer.controlStyle = MPMovieControlStyle.embedded

    }
    
}
