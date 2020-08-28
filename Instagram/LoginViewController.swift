//
//  LoginViewController.swift
//  Instagram
//
//  Created by hiroko nagano on 2020/08/25.
//  Copyright © 2020 hiroko.nagano. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displalynameTextField: UITextField!
    
    //ログインボタンタップで呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            //アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) {
                authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                //HUDを消す
                SVProgressHUD.dismiss()
                //画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //アカウント作成ボタンで呼び出されるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displalynameTextField.text {
            //アドレスとパスワードと表示名のいずれかでも入力されてない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            //アドレスとパスでユーザー作成に成功すると自動でログインする
            print("address=",address)
            print("password=",password)
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    //エラーがあったら原因をプリント、リターンして、以降の処理を実行せずに処理を終了
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                //表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //プロフィール更新でエラー発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        //画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
