//
//  Card.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Card: Identifiable, Codable{
    @DocumentID var id: String?
    var content: String
    var userID: String
    var category: String
}
