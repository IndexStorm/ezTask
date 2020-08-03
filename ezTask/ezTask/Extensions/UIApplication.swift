//
//  UIApplication.swift
//  ezTask
//
//  Created by Mike Ovyan on 03.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
