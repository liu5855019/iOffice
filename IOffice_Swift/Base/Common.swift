//
//  Common.swift
//  IOffice_Swift
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/7.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

//MARK: - Screen

let kScreenH = UIScreen.main.bounds.height
let kScreenW = UIScreen.main.bounds.width
let kLineH = 1.0 / UIScreen.main.scale

let scaleH = kScreenH / 736.0
let scaleW = kScreenW / 375.0
func kScaleW(_ w : Float) -> Float {
    return w * Float(scaleW)
}
func kScaleH(_ h : Float) -> Float {
    return h * Float(scaleH)
}


