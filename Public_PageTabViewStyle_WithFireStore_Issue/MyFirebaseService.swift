//
//  MyFirebaseService.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI

class MyFirebaseService: ObservableObject{
    var currentID : String?
    var loggedIn = false
    
    func CheckIfSignedin(){
        currentID = Auth.auth().currentUser?.uid
        if currentID == nil{
            loggedIn = false
        } else {
            loggedIn = true
        }
    }
    
    func writeData(uid:String, a:String, b:String, c:String){
        let db = Firestore.firestore()
        CheckIfSignedin()
        
        if currentID != nil{
//            let setCollection = db.collection("ListOfUsersDocs")
//            let DocsQuery = setCollection.whereField("uid", isEqualTo: currentID)
            
            
            db.collection("ListOfUsersDocs").whereField("uid", isEqualTo: currentID)
                .getDocuments(){ (snapshot, err) in
                    if let err = err{
                        print("Error getting docs: \(err)")
                    } else {
                        db.collection("ListOfUsersDocs").document(self.currentID!).setData(["uid":uid, "dataA" : a, "dataB" : b, "dataC" : c])
                    
                    }
                }
//            setCollection.document().setData(["uid":uid, "dataA" : a, "dataB" : b, "dataC" : c])
        }
    }
    
}
