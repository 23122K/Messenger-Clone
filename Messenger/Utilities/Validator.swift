//
//  Validator.swift
//  Messenger
//
//  Created by Patryk Maciąg on 22/05/2023.
//

import Foundation

class Validator {
    static func isValidMail(_ input: String) -> Bool {
        let format = "[A-Z0-9a-z._]+@[A-Za-z0-9]+.[A-Za-z]{2,30}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: input)
    }
    
    static func isValidPassword(_ input: String) -> Bool {
        let format = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: input)
    }
    
    static func isValidString(_ input: String) -> Bool {
        let format = "[A-Za-z]{2,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: input)
    }
}
