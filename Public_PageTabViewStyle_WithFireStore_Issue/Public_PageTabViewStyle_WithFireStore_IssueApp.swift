//
//  Public_PageTabViewStyle_WithFireStore_IssueApp.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct Public_PageTabViewStyle_WithFireStore_IssueApp: App {
    
    init(){
        FirebaseApp.configure()
        if Auth.auth().currentUser == nil{
            Auth.auth().signInAnonymously()
            print("currentUser == nil, signInAnonymously")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(){
                ContentView()
                    .tabItem{Text("Content")}
                CardListView()
                    .tabItem {Text("CardList")}
            }
            .environmentObject(MyFirebaseService())
            .environmentObject(CardsViewModel())
        }
    }
}

