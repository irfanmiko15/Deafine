//
//  ASLClasifierApp.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//

import SwiftUI

@main
struct ASLClasifierApp: App {    var body: some Scene {
        WindowGroup {
           LivePreviewView(vm: ClassificationViewModel())
        }
    }
}
