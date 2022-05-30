//
//  Final_00857125App.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/11.
//

import SwiftUI
import Firebase
import FacebookCore
@main
struct Final_00857125App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                }
        }
    }
}
