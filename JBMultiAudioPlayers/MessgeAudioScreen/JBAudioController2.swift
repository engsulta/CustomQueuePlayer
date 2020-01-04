//
//  JBAudioController2.swift
//  Stretchy Header
//
//  Created by Ahmed Sultan on 1/3/20.
//  Copyright © 2020 Mark Labib. All rights reserved.
//

import Foundation
import SwiftAudio

class JBAudioController2 {
    let serialQueue = DispatchQueue(label: "serialQueue")
    var automaticallyPlayNext: Bool = true
    var players: [AudioPlayer] = []
    var currentIndex: Int = -1
    let audioSessionController = AudioSessionController.shared
    init() {
        try? audioSessionController.set(category: .playback)
        
    }
    var currentPlayer: AudioPlayer? {
        didSet {
            currentIndex = players.firstIndex(of: currentPlayer!) ?? -1
            currentPlayerDidFinished = false
            guard let oldPlayer = oldValue, oldPlayer != currentPlayer else { return }
            oldPlayer.pause()
        }
    }
    var currentPlayerDidFinished: Bool = false {
        didSet {
            if currentPlayerDidFinished && automaticallyPlayNext && currentIndex < (players.count - 1) {
                currentPlayer = players[safe: (currentIndex)+1]
                currentPlayer?.play()
            }
        }
    }
    func appendPlayer(player: AudioPlayer) {
        guard !players.contains(player) else { return }
        serialQueue.async {
            self.players.append(player)
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension AudioPlayer: Equatable {
    public static func == (lhs: AudioPlayer, rhs: AudioPlayer) -> Bool {
        lhs.currentItem?.getSourceUrl() == rhs.currentItem?.getSourceUrl()
    }
}
