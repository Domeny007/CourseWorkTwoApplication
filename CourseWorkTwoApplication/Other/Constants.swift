//
//  Constants.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 17/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import Foundation

let infoKeyForEditedImage = "UIImagePickerControllerEditedImage"
let infoKeyForOriginalImage = "UIImagePickerControllerOriginalImage"

let BASE_URL = "https://finelifex-eduhelper-api.herokuapp.com"

let userDefaultTokenKey = "usersToken"

let mainTabBarIdentifier = "MainTabBar"

let webkitViewControllerIdentifier = "webkitViewController"
let profileViewControllerIdentifier = "profileViewController"
let tagsListVCIdentifier = "tagsListVCIdentifier"
let newsViewControllerIdentifier = "newsViewController"
let creatingEventVCIdentifier = "creatingEventVCIdentifier"
let newsCommentsViewControllerIdentifier = "newsCommentsViewControllerIdentifier"
let answerViewControllerIdentifier = "answerViewControllerIdentifier"
let commentsCellIdentifier = "CommentTableViewCell"


let newsTableViewCellNibName = "NewsTableViewCell"

let emptyString = ""



let vkString = "https://api.vk.com/oauth/authorize?client_id=6723456&scope=wall,photos,friends&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token"

let storyBoardNameString = "Main"

let passwordFieldIsntValid = "Неправильный пароль: 8 символов, 1 спец символ, англ. буквы"
let allFieldArentFilled = "Не все поля заполнены"
let emailFieldIsntValid = "Неправильный e-mail"
let passwordIsNotCorrect = "Пароли не совпадают"


let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"


let vkAppID = "6723456"

