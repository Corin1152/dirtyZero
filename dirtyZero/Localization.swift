//
//  Localization.swift
//  dirtyZero
//
//  简体中文适配：为 UI 文案提供查表能力。
//

import Foundation

extension String {
    /// 以自身为 key 在 Localizable.strings 中查表。
    ///
    /// 工程里没有 en.lproj：英文环境查不到译文时 NSLocalizedString 会原样返回
    /// key，而 key 本身就是英文原文，所以英文界面无需任何额外资源即可正常工作。
    /// 中文环境命中 zh-Hans.lproj 得到译文。
    ///
    /// 重要：tweak / section 的 name 同时承担两个职责 ——
    ///   1. 持久化数据（@AppStorage("tweakArray") 里存的是 Codable 结构）
    ///   2. 查找键（如 tweakArray.firstIndex { $0.name == "Custom Tweaks" }）
    /// 因此它们必须保持英文原值，只在「显示时」查表，绝不能把译文写回存储，
    /// 否则切换语言后既匹配不上旧数据，也会让自定义 tweak 落到错误的分组。
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

/// 带参数的本地化文案。
///
/// key 里用 %lld / %@ 等占位符，与英文原句一一对应 —— 这样英文环境查不到译文时，
/// 用原 key 做 format 得到的仍是原本那句英文，行为与改造前完全一致。
func L(_ key: String, _ args: CVarArg...) -> String {
    String(format: NSLocalizedString(key, comment: ""), arguments: args)
}
