//
//  MessageAudioCellProtocol.swift
//  Jawab
//
//  Created by Ahmed Sultan on 12/30/19.
//  Copyright © 2019 Tunc Tugcu. All rights reserved.
//

import Foundation
import UIKit
import SwiftAudio

enum AudioStatus {
    case playing
    case paused
    case idle
    mutating func setStatus(state: AudioPlayerState) {
        switch state {
        case .playing:
            self = .playing
        case .paused:
            self = .paused
        case .idle:
            self = .idle
        default: break
        }
    }
    var audioImage: UIImage? {
        switch self {
        case .playing:
            return UIImage(systemName: "pause.circle.fill")
        case .paused:
            return UIImage(systemName: "play.circle.fill")
        case .idle:
            return UIImage(named: "play.circle.fill")
        }
    }
}
