//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation

open class OtherApp {
    public var name = ""
    public var url = ""
    public var icon = ""
    public var desc = ""
    public var images = [String]()
    
    public init() { }
    
    public init(_ element: [String: AnyObject], languageCode: String) {
        if languageCode == "ko" {
            if let value = element["nameKo"] as? String { self.name = value }
            if let value = element["hintKo"] as? [String] { self.images = value }
            if let value = element["descKo"] as? String { self.desc = value }
        } else if languageCode == "en" {
            if let value = element["nameEn"] as? String { self.name = value }
            if let value = element["hintEn"] as? [String] { self.images = value}
            if let value = element["descEn"] as? String { self.desc = value }
        } else {
            if let value = element["nameDefault"] as? String { self.name = value }
            if let value = element["hintDefault"] as? [String] { self.images = value }
            if let value = element["descDefault"] as? String { self.desc = value }
        }
        if let value = element["url"] as? String { self.url = value }
        if let value = element["icon"] as? String { self.icon = value }
    }
    
    static func list(_ list: [[String: AnyObject]], languageCode: String) -> [OtherApp] {
        return list.compactMap({ OtherApp($0, languageCode: languageCode) })
    }
}
