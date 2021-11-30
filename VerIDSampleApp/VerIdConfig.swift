//
//  VerIdConfig.swift
//  VerIDSampleApp
//
//  Created by REO HARADA
//
import AVKit

// 顔検出に失敗したときにリトライ回数
let VER_ID_SESSION_RETRY = 10

// デバッグモード 顔認証の結果がわかる
let VER_ID_SESSION_DEBUG = false

// 利用するカメラ
let VER_ID_CAMERA_POSITION = AVCaptureDevice.Position.front
//let VER_ID_CAMERA_POSITION = AVCaptureDevice.Position.back

// VerIDのユーザID（顔の保存場所）
let VER_ID_USER_ID = "softbank"

// 登録の際のYawのしきい値
let VER_ID_REGISTRATION_YAW = CGFloat(15)

// 登録の際のPitchのしきい値
let VER_ID_REGISTRATION_PITCH = CGFloat(12)

// 登録の際の写真枚数
let VER_ID_REGISTRATION_FACE_CAPTURE_FACE_COUNT = 3

// 登録の際の顔検出の横幅
let VER_ID_REGISTRATION_FACE_EXTENTS_WIDTH = CGFloat(0.65)

// 登録の際の顔検出の高さ
let VER_ID_REGISTRATION_FACE_EXTENTS_HEIGHT = CGFloat(0.85)

// 登録のisFaceCoveringDetectionEnabledの値
let VER_ID_REGISTRATION_IS_FACE_COVERING_DETECTION_ENABLED = true

// 認証の際のYawのしきい値
let VER_ID_AUTHENTICATION_YAW = CGFloat(15)

// 認証の際のPitchのしきい値
let VER_ID_AUTHENTICATION_PITCH = CGFloat(12)

// 認証の際の写真枚数
let VER_ID_AUTHENTICATION_FACE_CAPTURE_FACE_COUNT = 1

// 認証の際の顔検出の横幅
let VER_ID_AUTHENTICATION_FACE_EXTENTS_WIDTH = CGFloat(0.65)

// 認証の際の顔検出の高さ
let VER_ID_AUTHENTICATION_FACE_EXTENTS_HEIGHT = CGFloat(0.85)

// 認証のisFaceCoveringDetectionEnabledの値
let VER_ID_AUTHENTICATION_IS_FACE_COVERING_DETECTION_ENABLED = true
