//
//  Common.swift
//  IOffice_Swift
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/7.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

//MARK: - Screen

let kScreenH = UIScreen.main.bounds.height;
let kScreenW = UIScreen.main.bounds.width;
let kLineH = 1.0 / UIScreen.main.scale;

let scaleH = kScreenH / 736.0;
let scaleW = kScreenW / 375.0;


let kStatusHeight = UIApplication.shared.statusBarFrame.size.height;
let kNavHeight = kStatusHeight + 44.0;
let kIsIPhoneX = kStatusHeight == 44;
let kSafeBottomHeight = kIsIPhoneX ? 34.0 : 0;






func kScaleW(_ w : Float) -> CGFloat
{
    return CGFloat(w * Float(scaleW));
}

func kScaleH(_ h : Float) -> CGFloat
{
    return CGFloat(h * Float(scaleH));
}



