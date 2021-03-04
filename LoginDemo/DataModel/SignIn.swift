//
//  SignIn.swift
//  LoginDemo
//
//  Created by Sachin Daingade on 26/02/21.
//

import Foundation

public struct SignIn:Codable {
   
    let email:String
    let password:String
    
    public init(email: String,password: String){
        self.email = email
        self.password = password
    }
}
