//
//  MobileNetV2App.swift
//  MobileNetV2
//
//  Created by Eli Hartnett on 12/17/21.
//

import SwiftUI

@main
struct MobileNetV2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ClassifiedObjectModel())
        }
    }
}
