//
//  RouteState.swift
//  Pathy
//
//  Created by Ronald Huang on 9/19/24.
//

import Foundation

enum RouteState: Equatable {
    case notStarted
    case inProgress(startTime: Date)
    case ended(startTime: Date, endTime: Date)
}
