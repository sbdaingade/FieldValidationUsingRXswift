//
//  ViewController.swift
//  LoginDemo
//
//  Created by Sachin Daingade on 26/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTip: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTip: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    typealias loginFetcher = Fetcher<SignIn>
    
    let myDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.rx.text.map{$0!.isValidForType(type: .email)}.bind {[unowned self] success in
            self.emailTip.isHidden = success ? true : false
            if let email = self.emailTextField.text, email.count > 0, !success{
                self.emailTip.textColor = UIColor.red
            }
        }.disposed(by: myDisposeBag)
        
        
        passwordTextField.rx.text.map{$0!.isValidForType(type: .password)}.bind {[unowned self] success in
            self.passwordTip.isHidden = success ? true : false
            if let password = self.passwordTextField.text, password.count > 0, !success{
                self.passwordTip.textColor = UIColor.red
            }
        }.disposed(by: myDisposeBag)
        
        
        Observable.combineLatest(emailTextField.rx.text, passwordTextField.rx.text){
            email, password in
            return email!.isValidForType(type: .email) && password!.isValidForType(type: .password)
        }.bind{ [unowned self]  success in
            if self.loginButton.isEnabled != success {
                self.loginButton.isEnabled = success
                UIView.animate(withDuration: 0.24, animations: {
                    self.loginButton.alpha = success ? 1.0: 0.4
                })
            }
        }.disposed(by: myDisposeBag)
        
        loginButton.rx.tap.bind {[unowned self] _ in
            
            let loginData = SignIn(email: emailTextField.text!, password: passwordTextField.text!)
            loginFetcher.init().loginAction(initWith: loginData) { loginData in
                
            }
            
        }.disposed(by: myDisposeBag)
        
    }
    
}

