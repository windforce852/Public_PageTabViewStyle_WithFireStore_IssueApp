//
//  ContentView.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct ContentView: View {
    @EnvironmentObject var myFirebaseService : MyFirebaseService
    @State var canShowUid = false
    
    @State var Item1data = ""
    @State var Item2data = ""
    @State var Item3data = ""
    

    
    var body: some View {
        VStack{
            
            //Item1
            if canShowUid == true {
//                Text(Auth.auth().currentUser?.uid ?? "no uid returned")
                Text(myFirebaseService.currentID!)
                
            }

            //Item2
            Button {
                myFirebaseService.CheckIfSignedin()
                if myFirebaseService.loggedIn == true {
                    canShowUid = true
                } else {
                    canShowUid = false
                }
                print("currentuser.uid = \(Auth.auth().currentUser?.uid ?? "nil")")
                if let providerData = Auth.auth().currentUser?.providerData{
                    for userInfo in providerData{
                        switch userInfo.providerID{
                        case "facebook.com": print("providerID: FB")
                        case "google.com": print("providerID: Google")
                        case "apple.com": print("providerID: Apple")
                        default: print("providerID: \(userInfo.providerID)")
                        }
                    }
                }
            } label: {
                Text("check uid update")
            }
            
            //Item3
            HStack{
                Spacer()
                TextField("Item1", text: $Item1data, prompt: Text("enter item 1 data"))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            HStack{
                Spacer()
                TextField("Item2", text: $Item2data, prompt: Text("enter item 2 data"))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            HStack{
                Spacer()
                TextField("Item3", text: $Item3data, prompt: Text("enter item 3 data"))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            
            
            //Item4
            Button {
                myFirebaseService.writeData(uid:myFirebaseService.currentID ?? "nil" ,a: Item1data, b: Item2data, c: Item3data)
            } label: {
                Text("SetData1,2,3")
            }

            
            //MARK: Apple sign in button
            SignInWithAppleView()
            
            
        }
        .onAppear(perform: myFirebaseService.CheckIfSignedin)
//        .onTapGesture {
//            hideKeyboard()
//        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(Item1data: "Item1data", Item2data: "Item2data", Item3data: "Item3data")
    }
}
