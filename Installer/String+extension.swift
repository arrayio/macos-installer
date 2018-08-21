//
//  String+extension.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 21.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns a localized string with empty comment.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized string using a given format a template.
    static func localized(_ format: String, _ arguments: CVarArg...) -> String {
        return String(format: format.localized, locale: Locale.current, arguments: arguments)
    }
    
}
