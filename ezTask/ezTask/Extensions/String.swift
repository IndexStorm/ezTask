//
//  String.swift
//  ezTask
//
//  Created by Mike Ovyan on 19.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.main, comment: self)
    }

    func format(_ arguments: CVarArg...) -> String {
        return String(format: self, locale: Locale.current, arguments: arguments)
    }
}
