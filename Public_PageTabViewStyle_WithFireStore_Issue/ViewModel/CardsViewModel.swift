//
//  CardsViewModel.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CardsViewModel: ObservableObject{
    @Published var Cards = [Card]()
    
    func getCards(){
        let db = Firestore.firestore()
        let collection = db.collection("Card")
        
        collection.whereField("userID", isEqualTo: Auth.auth().currentUser?.uid)
            .getDocuments { QuerySnapshot, Error in
                if let ErrorUW = Error {
                    print("Error: \(ErrorUW)")
                } else {
                for document in QuerySnapshot!.documents{
                    do {
                        let object = try document.data(as: Card.self)
                        self.Cards.append(object!)
                    } catch {
                        print("could not parse doc data")
                    }
                }
            }
        }
    }
}
