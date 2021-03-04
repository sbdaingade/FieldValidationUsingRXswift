//
//  String.swift
//  LoginDemo
//
//  Created by Sachin Daingade on 26/02/21.
//

import Foundation

extension String{
    
    func isValidForType(type: Validation) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", type.description).evaluate(with: self)
    }
}
public enum Validation : CustomStringConvertible{
    case email
    case password
    
    public var description: String {
        switch self {
        case .email:
            return "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        case .password:
            return "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z` ~ ! @ # ${'$'} % ^ * ( ) _ _ + + .  - - - = { } | \\[ \\] & \\ :  ; ' < > ? , . ]{9,28}$"
        }
    }
}
