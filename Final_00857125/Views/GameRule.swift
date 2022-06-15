//
//  GameRule.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI

struct GameRule: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack (alignment: .leading) {
                    Text("遊戲規則")
                        .font(.title)
                        .bold()
                    Text("共20格的大富翁。\n開局時,會隨機選擇一名玩家開始\n只要擲骰子即可往前，相同點數可再骰一次，右上和左下為機會命運，有一定機率賺錢或賠錢，右下角為監獄，進入後一回合不能移動\n所在的位子若沒有建築可以購買並建造，若有他人建築則需付給他過路費\n當四位玩家有三位破產時則獲勝。")
                        .font(.title2)
                }.padding()
            }.foregroundColor(midNightBlue)
            .background(Color.blue)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(midNightBlue, lineWidth: 10))
            .cornerRadius(20)
            VStack {
                VStack (alignment: .leading) {
                    Text("遊戲策略")
                        .font(.title)
                        .bold()
                    Text("一款非常吃運氣的遊戲，建議不一定要走到哪買到哪，容易導致破產")
                        .font(.title2)
                }.padding()
            }.foregroundColor(midNightBlue)
            .background(Color.blue)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(midNightBlue, lineWidth: 10))
            .cornerRadius(20)
            VStack {
                VStack (alignment: .leading) {
                    Text("入場費")
                        .font(.title)
                        .bold()
                    Text("每次輸了會少50金幣 贏了會獲得50金幣，若餘額小於50不可進場，觀看一次廣告獲得20金幣\n")
                        .font(.title2)
                }.padding()
            }.foregroundColor(midNightBlue)
            .background(Color.blue)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(midNightBlue, lineWidth: 10))
            .cornerRadius(20)
            
        }.padding()
        .background(Image("bg2").blur(radius: 10).contrast(0.69))
    }
}

struct GameRule_Previews: PreviewProvider {
    static var previews: some View {
        GameRule()
    }
}
