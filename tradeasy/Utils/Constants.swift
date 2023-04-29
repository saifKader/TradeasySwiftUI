//
//  Constants.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
let kbaseUrl = "http://localhost:9090/"
//let kbaseUrl = "http://172.17.12.140:9090/"
let kImageUrl = "\(kbaseUrl)img/"

// authentification
let kregister = "user/register"
let klogin = "user/login"
let kforgetpassword = "user/forgotPassword"
let kresetpassword = "user/resetpassword"
let kverifyotp = "user/verifyOtp"
let kupdateUsername = "user/updateusername"
let kupdatePassword = "user/updatePassword"
let ksendVerificationEmail = "user/sendVerificationEmail"
let kchangeEmail = "user/changeEmail"
let kregisterFirebaseUser = "user/registerfirebaseuser"
let kUploadProfilePicture = "user/uploadprofilepicture"
let kSendVerificationSms = "user/smstoverify"
let kVerifyAccount = "user/verifyaccount"

// product
let kAddProduct = "product/user/add"
let ksearchProdByName = "product/searchbyname"
let kGetAllProducts = "product/getall"
let kAddProdToSaved = "product/addprodtosaved"
let kGetCurrentUser = "user/getCurrentUser"
let kGetUserProducts = "product/userproducts"
let kUnlistProduct = "product/unlistproduct"
let kEditProduct = "product/editproduct"
let kAddRatingToProduct = "product/addrating"
