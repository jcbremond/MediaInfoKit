//
//  AppDelegate.swift
//  MediaInfoDemo-Swift
//
//  Created by Jeremy Vizzini.
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

import Cocoa
import MediaInfoKit

@NSApplicationMain
public class AppDelegate: NSObject {

    // MARK: IBOutlet
    
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var streamsTableView: NSTableView!
    
    @IBOutlet weak var infoTableView: NSTableView!
    
    // MARK: Properties
    
    public var movieFileURL: NSURL? {
        return NSBundle.mainBundle().URLForResource("BBB", withExtension: "mov")
    }
    
    public lazy var mediaInfo: MIKMediaInfo = {
        guard let movieURL = self.movieFileURL else {
            fatalError("The movie cannot be found.")
        }
        guard let info = MIKMediaInfo(fileURL: movieURL) else {
            fatalError("The movie is not readable by mediainfolib.")
        }
        return info
    }()
}

// MARK: - NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    
    public func applicationDidFinishLaunching(notification: NSNotification) {
        self.streamsTableView.reloadData()
        self.infoTableView.reloadData()
    }
}

// MARK: - NSTableViewDataSource

extension AppDelegate: NSTableViewDataSource {
    
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView === self.streamsTableView {
            return self.mediaInfo.streamKeys.count
        } else {
            let index = self.streamsTableView.selectedRow
            if index >= 0 && index < self.mediaInfo.streamKeys.count {
                let streamKey = self.mediaInfo.streamKeys[index]
                return self.mediaInfo.countOfValuesForStreamKey(streamKey)
            } else {
                return 0
            }
        }
    }
    
    public func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if tableView === self.streamsTableView {
            return self.mediaInfo.streamKeys[row]
        } else {
            let index = self.streamsTableView.selectedRow
            let streamKey = self.mediaInfo.streamKeys[index]
            if self.mediaInfo.countOfValuesForStreamKey(streamKey) <= row {
                return nil
            } else if tableColumn?.title == "Key" {
                return self.mediaInfo.keyAtIndex(row, forStreamKey: streamKey)
            } else {
                return self.mediaInfo.valueAtIndex(row, forStreamKey: streamKey)
            }
        }
    }
}

// MARK: - NSTableViewDelegate

extension AppDelegate: NSTableViewDelegate {
    
    public func tableViewSelectionDidChange(notification: NSNotification) {
        if notification.object === self.streamsTableView {
            self.infoTableView.reloadData()
        }
    }
}
