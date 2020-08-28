//
//  HomeViewController.swift
//  Instagram
//
//  Created by hiroko nagano on 2020/08/25.
//  Copyright © 2020 hiroko.nagano. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    //Firestoreのリスナー
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログイン済
            if listener == nil {
                //lietener未登録なら登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの習得が失敗しました。　\(error)")
                        return
                    }
                    //習得したdocumentをもとにPostDataを作成し、PostArrayの配列
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document習得\(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    //TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            //ログイン未（またはログアウト済）
            if listener != nil {
                //listener登録済なら削除してpostArrayをクリアする
                
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostDate(postArray[indexPath.row])
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.comentButton.addTarget(self, action: #selector(handleComentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleComentButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: コメントがタップされました。")
        print()
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        let comentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Coment") as! ComentViewController
        comentViewController.receivedPostData = postData
        self.present(comentViewController, animated: true, completion: nil)
    }

    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新でーたを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合はいいねの解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねした場合myidを追加するデータを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likeに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
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
