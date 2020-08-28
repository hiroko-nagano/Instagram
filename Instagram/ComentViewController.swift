//
//  ComentViewController.swift
//  Instagram
//
//  Created by hiroko nagano on 2020/08/26.
//  Copyright © 2020 hiroko.nagano. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ComentViewController: UIViewController {
    
    
    //タップしたセルの情報を得る
    
    var receivedPostData : PostData?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var handleComentButton: UIButton!
    
    
    //コメント投稿ボタンをタップした時に呼ばれるメソッド
    @IBAction func handleComentButton(_ sender: Any) {
        
        let coment = self.textField.text!
        if coment.isEmpty {
            SVProgressHUD.showSuccess(withStatus: "コメントを入力してください")
            SVProgressHUD.dismiss(withDelay: 2)
            
            return
            
        } else {
            
            
            let comentName = Auth.auth().currentUser?.displayName
            //コメントを更新する
            let coment = " \( comentName!) : \(self.textField.text!)"
            //更新でーたを作成する
            var updateValue: FieldValue
            
            //コメントを追加するデータを作成
            updateValue = FieldValue.arrayUnion([coment])
            
            //comentに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(receivedPostData!.id)
            postRef.updateData(["coments": updateValue])
            
            //HUDでコメント投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "コメントしました")
            
            //コメント投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //キャンセルボタンをタップした時に
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

