//
//  CardListView.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import SwiftUI

struct CardListView: View {
    @EnvironmentObject var FService: MyFirebaseService
    @EnvironmentObject var CardListVM: CardsViewModel
    var colors: [Color] = [ .orange, .green, .yellow, .pink, .purple].shuffled()
//    @State var textInEditor = ""
    

    var body: some View {
                
//        VStack{
//            ForEach(CardListVM.Cards){ item in
//                ZStack{
//                    Rectangle()
//                        .fill(colors.randomElement() ?? Color.yellow)
//                        .frame(width: nil, height: 120)
//                        .cornerRadius(10)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                    ScrollView{
//                        Text(item.content)
//                    }
//                    .frame(width: nil, height: 100)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 25)
//                }
//            }
//        }
//        .onAppear {
//            CardListVM.getCards()
//        }
        
        TabView(){
            ForEach(CardListVM.Cards){ item in
                ZStack{
                    Rectangle()
                        .fill(colors.randomElement() ?? Color.yellow)
                        .frame(width: nil, height: 120)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                    ScrollView{
                        Text(item.content)
                    }
                    .frame(width: nil, height: 100)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            CardListVM.getCards()
        }

        
        
        
    }
}
