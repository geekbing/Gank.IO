//
//  String+ITDAvatarPlaceholder.swift
//  Pods
//
//  Created by Igor Kurylenko on 4/4/16.
//
//

extension String {
    public func toAvatarPlaceholderText(maxLettersCount: Int = 3) -> String {
        let maxLettersCount = maxLettersCount < 0 ? 0: maxLettersCount
        
        let text = self.firstLetters.uppercaseString
        
        return text.characters.count > maxLettersCount ?
            text[text.startIndex..<text.startIndex.advancedBy(maxLettersCount)] : text
    }
    
    var firstLetters: String {
        var result = String()        
        var shouldAddLetter = true
        
        unicodeScalars.forEach { ch in
            switch ch {
            case " ":
                shouldAddLetter = true
                
            case _ where shouldAddLetter && kLetterCharacterSet.longCharacterIsMember(ch.value):
                shouldAddLetter = false
                result.append(ch)
                
            default:
                break
            }
        }
        
        return result
    }
}
