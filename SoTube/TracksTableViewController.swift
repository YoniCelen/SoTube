//
//  MusicTableViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 09/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class TracksTableViewController: MyMusicTabBarViewController, UITableViewDelegate, UITableViewDataSource, SortDelegate {
    // MARK: - Properties
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var songTableView: UITableView!

    let database = DatabaseViewModel()
    var tracks: [Track] = [] {
        didSet {
            songTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set self as weak sort delegate
        weak var weakSelf = self
        sortDelegate = weakSelf
        
        // Get tracks
        database.getTracks { tracks in
            self.tracks = tracks
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFooterHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let footerView = songTableView.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var footerFrame = footerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != footerFrame.size.height {
                footerFrame.size.height = height
                footerView.frame = footerFrame
                songTableView.tableFooterView = footerView
            }
        }
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFooterHeight()
    }
    
    // MARK: - TableView
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackTableViewCell else {
            fatalError("The dequeued cell is not an instance of StaticAlbumTableViewCell.")
        }
        let track = tracks[indexPath.row]
        cell.albumImageView.image(fromLink: track.coverUrl)
        cell.titelLabel.text = track.name
        cell.albumLabel.text = track.albumName
        cell.artistLabel.text = track.artistName
        cell.timeLabel.text = string(fromIntInMiliSec: track.duration)
        return cell
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedTrack = tracks[index]
        
        musicPlayer.play(selectedTrack)
        
        print("musicPlayer.Play:")
        print(musicPlayer.isPlaying)
        self.updateMiniPlayer()

        updateFooterHeight()
    }
    
    // MARK: - Sort functions
    func sortByName() {
        self.tracks.sort(by: {
            $0.name < $1.name
        })
    }
    
    func sortByArtist() {
        self.tracks.sort(by: {
            if $0.artistName == $1.artistName {
                if $0.albumName == $1.albumName {
                    return $0.trackNumber < $1.trackNumber
                }
                return $0.albumName < $1.albumName
            }
            return $0.artistName < $1.artistName
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let musicCollectionVC = destinationvc as? AlbumsCollectionViewController {
//            musicCollectionVC.data = self.dummmyData
        }
    }
    
    // Private Methods
    private func updateFooterHeight() {
        let height: CGFloat
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if musicPlayer.hasSong {
                height = 94
            } else {
                height = 50 
            }
        } else {
            height = 50
        }
        songTableView.tableFooterView?.frame.size.height = height
        
        // Reset tableview contentsize height
        let lastTableViewSubviewYPosition = songTableView.tableFooterView?.frame.origin.y
        let lastTableViewSubviewHeight = songTableView.tableFooterView?.bounds.height
        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
        songTableView.contentSize = CGSize(width: songTableView.contentSize.width, height: newHeight)
    }
    
    private func string(fromIntInMiliSec timeMS: Int) -> String {
        
        let time = timeMS / 1000
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours == 0 {
            return String(format: "%0.1d:%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.1d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
}
