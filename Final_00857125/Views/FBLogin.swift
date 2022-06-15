//
//  FBLogin.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/30.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import FacebookLogin

func isLoginFB() -> Bool {
    let message = AccessToken.current != nil ? "\(AccessToken.current!.userID) 登入" : "未登入"
    print(message)
    return AccessToken.current != nil ? true : false
}

func loadUserProfileFB() {
    if let accessToken = AccessToken.current {
        Profile.loadCurrentProfile { (profile, error) in
            if let profile = profile {
                print(profile.name)
                print(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)))
            }
        }
    }
}

func logOutFB() {
    let manager = LoginManager()
    manager.logOut()
}

func loginUseFB(completion: @escaping (String) -> Void) {
    let manager = LoginManager()
    manager.logIn(permissions: [.email, .publicProfile]) { (result) in
        if case LoginResult.success(granted: _, declined: _, token: _) = result {
            print("fb login ok")
            let credential =  FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    completion("FB login error")
                    return
                }
                print("fb login ok")
                completion("FB login success")
                //印出使用者FB資訊
//                let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
//                request.start { (response, result, error) in
//                   if let result = result as? [String:String] {
//                      print(result)
//                   }
//                }
            }
        } else {
            print("login fail")
            completion("FB login failed")
        }
    }
}
