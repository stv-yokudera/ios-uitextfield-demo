//
//  String+PartiallyReplace.swift
//  ios-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/08/30.
//  Copyright © 2017年 Okudera Yuki. All rights reserved.
//

import Foundation

extension String {
    
    /// 文字数
    var count: Int {
        return self.characters.count
    }
    
    /// 1文字目からn文字目まで「*」に置換する
    ///
    /// - Parameter unmaskCharactersCount: 末尾から置換しない文字数のカウント(default: 3)
    /// - Returns: 返還後の文字列
    func partiallyReplace(to unmaskCharactersCount: Int = 3,
                          maskSymbol: String = "*") -> String {
        
        // 空文字の場合
        if self.isEmpty { return "" }
        
        let inputTextCount = self.count
        
        // 規定値より文字数が少ない場合
        if inputTextCount <= unmaskCharactersCount {
            return String(repeating: maskSymbol, count: inputTextCount)
        }
        
        // 規定値以上の場合
        let maskCharactersCount = inputTextCount - unmaskCharactersCount
        let maskCharacters = String(repeating: maskSymbol, count: maskCharactersCount)
        
        let unmaskIndex = self.index(self.endIndex, offsetBy: -(unmaskCharactersCount))
        let unmaskCharacters = self.substring(from: unmaskIndex)
        
        return maskCharacters + unmaskCharacters
    }
}
