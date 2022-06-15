//
//  RoomRowView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI

struct RoomRowView: View {
    @State var room: RoomData
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(room.id!)
                        .bold()
                        .font(.title)
                    if room.roomPassWord != "" {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(midNightBlue)
                    }
                }
                HStack {
                    Text(NSLocalizedString("房主: ", comment: "") + room.user0.userName)
                }.font(.system(size: 15))
            }
            Spacer()
            if people_count() < 4{
                Image(systemName: "person")
                    .font(.title3)
                Text("\(people_count())/4")
                    .font(.title3)
            } else{
                Image(systemName: "person.fill")
                    .font(.title3)
                Text("4/4")
                    .font(.title3)
            }
            if room.roomGameStatus {
                HStack {
                    Text("遊戲中..")
                        .bold()
                    Image(systemName: "gamecontroller.fill")
                }.font(.title3)
                .frame(width: 120)
            } else {
                HStack {
                Text("進入房間")
                    .bold()
                Image(systemName: "chevron.right.circle.fill")
                }.font(.title3)
                .frame(width: 120)
            }
        }.padding()
        .foregroundColor(midNightBlue)
        .background(Color.blue)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(midNightBlue, lineWidth: 10))
        .cornerRadius(20)
    }
    
    func people_count() -> Int{
        var count = 0
        if room.user0.userName != ""{
            count += 1
        }
        if room.user1.userName != ""{
            count += 1
        }
        if room.user2.userName != ""{
            count += 1
        }
        if room.user3.userName != ""{
            count += 1
        }
        return count
    }
}

struct RoomRowView_Previews: PreviewProvider {
    static var previews: some View {
        RoomRowView(room: RoomData(id: "1234", user0: UserData(id: "", userID: "", userName: "你好", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "22", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, user2: UserData(id: "", userID: "", userName: "33", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user2ready: false, user3: UserData(id: "", userID: "", userName: "44", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user3ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false))
            .previewLayout(.sizeThatFits)
    }
}
