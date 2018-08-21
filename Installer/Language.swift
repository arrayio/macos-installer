//
//  LanguageString.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 21.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

class Language {
    
    func getString(array: [String : String]) -> String {
        var lang = Locale.preferredLanguages[0]
        var (string, isFind) = foreach(array: array, langPrefix: lang)
        if isFind {
            return string
        } else {
            lang = lang.components(separatedBy: "-").first!
            (string, isFind) = foreach(array: array, langPrefix: lang)
            if isFind {
                return string
            } else {
                (string, isFind) = foreach(array: array, langPrefix: "en")
                if isFind {
                    return string
                }
            }
        }
        return ""
    }
    
    func foreach (array: [String : String], langPrefix: String) -> (String, Bool) {
        for element in array {
            if element.key == langPrefix {
                return (element.value, true)
            }
        }
        return ("", false)
    }
}
