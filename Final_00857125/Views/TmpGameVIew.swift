//
//  TmpGameVIew.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/10.
//

import SwiftUI

struct TmpGameVIew: View {
    @StateObject var myGameData = MyGame()
    @State private var dice_1 = 1
    @State private var dice_2 = 1
    func GridColor(i:Int, j:Int, color:Color)->Color{
        if color == Color.clear{
            if i != 0 && i != 5 && j != 0 && j != 5{
                return Color.clear
            }
            if (i == 0 && j == 0) || (i == 0 && j == 5) || (i == 5 && j == 0) || (i == 5 && j == 5){
                return Color.gray
            }
            if i % 2 == 0{
                if j % 2 == 0{
                    return Color.brown
                }
                else{
                    return Color.yellow
                }
            }
            else{
                if j % 2 == 0{
                    return Color.yellow
                }
                else{
                    return Color.brown
                }
            }
        }
        else{
            return color
        }
    }
    
    func count_step(step:Int, player_num:Int){
        var step_now = step
        if player_num == 0{
            /*for _ in stride(from:0, to: step, by:1){
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                    if player0_offset[3] == 0 && player0_offset[2] != 5{
                        player0_offset[2] += 1
                    }
                    else if player0_offset[2] == 5 && player0_offset[3] != 5{
                        player0_offset[3] += 1
                    }
                    else if player0_offset[3] == 5 && player0_offset[2] != 0{
                        player0_offset[2] -= 1
                    }
                    else if player0_offset[2] == 0 && player0_offset[3] != 0{
                        player0_offset[3] -= 1
                    }
                }
            }*/
            while step_now > 0{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3){
                    if player0_offset[3] == 0 && player0_offset[2] != 5{
                        player0_offset[2] += 1
                    }
                    else if player0_offset[2] == 5 && player0_offset[3] != 5{
                        player0_offset[3] += 1
                    }
                    else if player0_offset[3] == 5 && player0_offset[2] != 0{
                        player0_offset[2] -= 1
                    }
                    else if player0_offset[2] == 0 && player0_offset[3] != 0{
                        player0_offset[3] -= 1
                    }
                    step_now -= 1
                }
            }
        }
        else if player_num == 1{
            for _ in stride(from:0, to: step, by:1){
                if player1_offset[3] == 0 && player1_offset[2] != 5{
                    player1_offset[2] += 1
                }
                else if player1_offset[2] == 5 && player1_offset[3] != 5{
                    player1_offset[3] += 1
                }
                else if player1_offset[3] == 5 && player1_offset[2] != 0{
                    player1_offset[2] -= 1
                }
                else if player1_offset[2] == 0 && player1_offset[3] != 0{
                    player1_offset[3] -= 1
                }
            }
        }
        else if player_num == 2{
            for _ in stride(from:0, to: step, by:1){
                if player2_offset[3] == 0 && player2_offset[2] != 5{
                    player2_offset[2] += 1
                }
                else if player2_offset[2] == 5 && player2_offset[3] != 5{
                    player2_offset[3] += 1
                }
                else if player2_offset[3] == 5 && player2_offset[2] != 0{
                    player2_offset[2] -= 1
                }
                else if player2_offset[2] == 0 && player2_offset[3] != 0{
                    player2_offset[3] -= 1
                }
            }
        }
        else{
            for _ in stride(from:0, to: step, by:1){
                if player3_offset[3] == 0 && player3_offset[2] != 5{
                    player3_offset[2] += 1
                }
                else if player3_offset[2] == 5 && player3_offset[3] != 5{
                    player3_offset[3] += 1
                }
                else if player3_offset[3] == 5 && player3_offset[2] != 0{
                    player3_offset[2] -= 1
                }
                else if player3_offset[2] == 0 && player3_offset[3] != 0{
                    player3_offset[3] -= 1
                }
            }
        }
    }
    
    struct monopoly_grid{
        var color = Color.clear
        var shape = Rectangle()
    }
    
    @State var monopoly:[[monopoly_grid]] = Array(repeating: Array(repeating: monopoly_grid(), count: 6), count: 6)
    @State var monopoly_offset:[[Int]] = Array(repeating: Array(repeating: 0, count: 6), count: 6)
    @State var nowplayer:Int = 0
    @State var player0_offset:[Int] = [-150, -160,0,0]
    @State var player1_offset:[Int] = [-120, -160,0,0]
    @State var player2_offset:[Int] = [-150, -130,0,0]
    @State var player3_offset:[Int] = [-120, -130,0,0]
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0.0) {
                ForEach(0..<6) { i in
                    HStack(spacing: 0.0) {
                        ForEach(0..<6) { j in
                            monopoly[i][j].shape
                                .frame(width: 55, height: 55)
                                .foregroundColor(GridColor(i: i, j: j, color: monopoly[i][j].color))
                        }
                    }
                }
            }
            Image(systemName: "figure.walk")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(slimeGreen)
                .offset(x:CGFloat(player0_offset[0]+player0_offset[2]*55), y:CGFloat(player0_offset[1]+player0_offset[3]*55))
                .animation(.default)
            Image(systemName: "figure.walk")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(pikaPink)
                .offset(x:CGFloat(player1_offset[0]+player1_offset[2]*55), y:CGFloat(player1_offset[1]+player1_offset[3]*55))
            Image(systemName: "figure.walk")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .offset(x:CGFloat(player2_offset[0]+player2_offset[2]*55), y:CGFloat(player2_offset[1]+player2_offset[3]*55))
            Image(systemName: "figure.walk")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.purple)
                .offset(x:CGFloat(player3_offset[0]+player3_offset[2]*55), y:CGFloat(player3_offset[1]+player3_offset[3]*55))
            VStack{
                HStack{
                    Image("dice\(dice_1)")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Image("dice\(dice_2)")
                        .resizable()
                        .frame(width: 70, height: 70)
                }
                Button("click"){
                    dice_1 = Int.random(in: 1...6)
                    dice_2 = Int.random(in: 1...6)
                    count_step(step: dice_1+dice_2, player_num: nowplayer)
                    if nowplayer != 3{
                        nowplayer += 1
                    }
                    else{
                        nowplayer = 0
                    }
                }
            }
        }
    }
}

struct TmpGameVIew_Previews: PreviewProvider {
    static var previews: some View {
        TmpGameVIew()
    }
}
