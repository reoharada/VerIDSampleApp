//
//  ViewController.swift
//  VerIDSampleApp
//
//  Created by REO HARADA
//

import UIKit
import VerIDUI
import VerIDCore
import AVKit

class ViewController: UIViewController {
    
    let verIDFactory = VerIDFactory()
    var verId: VerID!
    var savedUserFaces = [Recognizable]()
    var recognaizeUserFaces = [Recognizable]()
    var isRegisting = false
    var isAuthenticationg = false
    var runCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            verId = try verIDFactory.createVerIDSync()
            savedUserFaces = try verId.userManagement.facesOfUser(VER_ID_USER_ID)
        } catch {
            showAlert("エラー", "verIdの生成に失敗しました。アプリを再起動してください。", nil)
        }
    }
    
    @IBAction func tabRegistFaceButton(_ sender: Any) {
        if isRegisting || isAuthenticationg { return }
        isRegisting = true
        registFace()
    }
    
    @IBAction func tabAuthenticateFaceButton(_ sender: Any) {
        if isRegisting || isAuthenticationg { return }
        isAuthenticationg = true
        authenticateFace()
    }
    
    fileprivate func registFace() {
        let registrationSettings = RegistrationSessionSettings(userId: VER_ID_USER_ID)
        registrationSettings.yawThreshold = VER_ID_REGISTRATION_YAW
        registrationSettings.pitchThreshold = VER_ID_REGISTRATION_PITCH
        registrationSettings.faceCaptureFaceCount = VER_ID_REGISTRATION_FACE_CAPTURE_FACE_COUNT
        registrationSettings.expectedFaceExtents = FaceExtents(proportionOfViewWidth: VER_ID_REGISTRATION_FACE_EXTENTS_WIDTH, proportionOfViewHeight: VER_ID_REGISTRATION_FACE_EXTENTS_HEIGHT)
        registrationSettings.isFaceCoveringDetectionEnabled = VER_ID_REGISTRATION_IS_FACE_COVERING_DETECTION_ENABLED
        let session = VerIDSession(environment: verId, settings: registrationSettings)
        session.delegate = self
        session.start()
    }

    fileprivate func authenticateFace() {
        let autheticationSettings = AuthenticationSessionSettings(userId: VER_ID_USER_ID)
        autheticationSettings.yawThreshold = VER_ID_AUTHENTICATION_YAW
        autheticationSettings.pitchThreshold = VER_ID_AUTHENTICATION_PITCH
        autheticationSettings.faceCaptureFaceCount = VER_ID_AUTHENTICATION_FACE_CAPTURE_FACE_COUNT
        autheticationSettings.expectedFaceExtents = FaceExtents(proportionOfViewWidth: VER_ID_AUTHENTICATION_FACE_EXTENTS_WIDTH, proportionOfViewHeight: VER_ID_AUTHENTICATION_FACE_EXTENTS_HEIGHT)
        autheticationSettings.isFaceCoveringDetectionEnabled = VER_ID_AUTHENTICATION_IS_FACE_COVERING_DETECTION_ENABLED
        let session = VerIDSession(environment: verId, settings: autheticationSettings)
        session.delegate = self
        session.start()
    }
    
    fileprivate func showAlert(_ title: String, _ message: String, _ handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default) { alert in
            guard let h = handler else { return }
            h()
        }
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showPostWillViewController(_ faces: [RecognizableFace]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostWillViewController") as! PostWillViewController
        vc.faces = faces
        navigationController?.show(vc, sender: nil)
    }
    
    fileprivate func showWillListViewController(_ faces: [Recognizable]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WillListViewController") as! WillListViewController
        vc.faces = faces
        navigationController?.show(vc, sender: nil)
    }
}

extension ViewController: VerIDSessionDelegate {
    // 顔検出が完了したときの設定
    func didFinishSession(_ session: VerIDSession, withResult result: VerIDSessionResult) {
        isRegisting = false
        isAuthenticationg = false
        
        if VER_ID_SESSION_DEBUG { return showDebugWindow(session, result) }
        
        if result.error != nil { return showAlert("エラー", "顔検出に失敗しました。時間をおいて再度お試しください。", nil) }
        
        if session.settings is RegistrationSessionSettings {
            if result.error == nil && result.faces.count > 0 {
                return showAlert("成功", "顔認証に成功しました。遺言を書いてください") { self.showPostWillViewController(result.faces) }
            }
        }
        
        
        if session.settings is AuthenticationSessionSettings {
            if result.error == nil && result.faces.count > 0 {
                guard let face = result.faces.first else { return showAlert("エラー", "顔検出に失敗しました。時間をおいて再度お試しください。", nil) }
                let defaultVersion = (session.environment.faceRecognition as? VerIDFaceRecognition)?.defaultFaceTemplateVersion ?? .V16
                if defaultVersion == .V20 && self.savedUserFaces.contains(where: { $0.version == RecognitionFace.Version.v20Unencrypted.rawValue }) {
                    self.recognaizeUserFaces = self.savedUserFaces.filter({ $0.version == RecognitionFace.Version.v20Unencrypted.rawValue })
                } else {
                    self.recognaizeUserFaces = self.savedUserFaces.filter({ $0.version == RecognitionFace.Version.unencrypted.rawValue })
                }
                let identification = UserIdentification(verid: session.environment)
                identification.findFacesSimilarTo(face, in: self.recognaizeUserFaces, threshold: nil, progress: nil) { result in
                    if case Result.success(let identifiedFaces) = result {
                        if identifiedFaces.count > 0 {
                            let faces = identifiedFaces.map { $0.face }
                            self.showWillListViewController(faces)
                        }
                    } else {
                        return self.showAlert("エラー", "登録データが見つかりませんでした。", nil)
                    }
                }
            }
        }
    }
    
    func showDebugWindow(_ session: VerIDSession, _ result: VerIDSessionResult) {
        let viewController = SessionDiagnosticsViewController.create(sessionResultPackage: SessionResultPackage(verID: session.environment, settings: session.settings, result: result))
        if result.error != nil {
            viewController.title = "Session Failed"
        } else {
            viewController.title = "Success"
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 顔検出をキャンセルしたときの設定
    func didCancelSession(_ session: VerIDSession) {
        print("didCancelSession")
    }
    
    // 顔検出後に結果を表示するかどうかの設定
    func shouldDisplayResult(_ result: VerIDSessionResult, ofSession session: VerIDSession) -> Bool {
        return false
    }

    // 顔検出の際に注意を促すかどうかの設定
    func shouldSpeakPromptsInSession(_ session: VerIDSession) -> Bool {
        return true
    }
    
    // 顔検出のフローを録画するかどうかの設定
    func shouldRecordVideoOfSession(_ session: VerIDSession) -> Bool {
        return VER_ID_SESSION_DEBUG
    }
    
    // カメラの設定
    func cameraPositionForSession(_ session: VerIDSession) -> AVCaptureDevice.Position {
        return VER_ID_CAMERA_POSITION
    }
    
    // 顔検出リトライの設定
    func shouldRetrySession(_ session: VerIDSession, afterFailure error: Error) -> Bool {
        runCount += 1
        return runCount < VER_ID_SESSION_RETRY
    }
}
