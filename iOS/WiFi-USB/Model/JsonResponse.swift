//
//  JsonResponse.swift
//  WiFi-USB
//
//  Created by Brandon Groff on 6/26/16.
//
//  Copyright © 2016 Brandon Groff.
//
//  License: GNU GPLv3 (see LICENSE)
//

import Foundation

/**
 *  Simple object for the WiFi-USBs JSON response
 */
struct JsonResponse {
    /// true if the WiFi-USB port is on
    var on: Bool?
    /// the raw GPIO value for the WiFi-USB's port
    var raw: Int?
    /// description of the WiFi-USB's status
    var description: String?
}