//
//  GameElements.swift
//  Crappy Turd
//
//  Created by jl on 21/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let turdCategory: UInt32 = 0x1 << 0
    static let pillarCategory: UInt32 = 0x1 << 1
    static let bacteriaCategory: UInt32 = 0x1 << 2
    static let groundCategory: UInt32 = 0x1 << 3
}
