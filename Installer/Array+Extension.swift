//
//  Array+Extension.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 19.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
