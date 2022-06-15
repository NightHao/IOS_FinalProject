//
//  RewardedAdController.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds

class RewardedAdController: NSObject {
    
    private var ad: GADRewardedAd?
    var showAnimation: Bool = false
    
    let db = Firestore.firestore()
    func loadAD() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { ad, error in
            if let error = error {
                print(error)
                return
            }
            ad?.fullScreenContentDelegate = self
            self.ad = ad
        }
    }

    func showAD(currentUserData: UserData) {
        if let ad = ad,
           let controller = UIViewController.getLastPresentedViewController() {
            ad.present(fromRootViewController: controller){
                print("拿到獎勵了")
                let rewardMoney = currentUserData.userMoney + 20
                self.db.collection("Users_Data").document(currentUserData.userID ?? "").setData(["userMoney": rewardMoney], merge: true)
                self.showAnimation = true
            }
        }

    }
}

extension RewardedAdController: GADFullScreenContentDelegate {

    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        print(#function)
      }

}
