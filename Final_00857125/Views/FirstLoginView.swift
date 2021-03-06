//
//  FirstLoginView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/28.
//
import SwiftUI
import FirebaseAuth

struct FirstLoginView: View {
    
    @StateObject var myUserData = MyUserData()
    @State private var currentUser = Auth.auth().currentUser
    @State private var userDisplayName = ""
    @State private var userGender = ""
    @State private var userFirstLoginStr = ""
    @State private var userBD = Date()
    @State private var currentDate = Date()
    @State private var genderSelect = 0
    @State private var userCountrySelect = 0
    //@State private var bodyColorSelect = 0
    @State private var faceSelect = 0
    @State private var hairSelect = 0
    @State private var accessoriesSelect = 0
    @State private var overAllSelect = 0
    @State private var skinSlider: CGFloat = 0
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var showContentView = false
    @State private var myAlert = Alert(title: Text(""))
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var skinColor = [Color(red: 1, green: 255/255, blue: 247/255), Color(red: 1, green: 175/255, blue: 185/255), Color(red: 1, green: 238/255, blue: 221/255), Color(red: 187/255, green: 153/255, blue: 102/255)]
    
    @State private var styleCategory:[String] = ["accessories","face","facial_hair","head","pose"]
    
    
    var gender = ["男", "女"]
    var face = ["可愛", "老", "大笑", "十分憤怒"]
    //男生髮型圖片名稱記得要index+1
    var maleHair = ["時尚型男", "潮流男孩", "極品紳士"]
    var femaleHair = ["時尚短髮", "鄰家女孩", "運動女神"]
    var accessories = ["無", "眼鏡", "墨鏡"]
    var overAll = ["休閒", "時尚"]
    let myDateFormatter = DateFormatter()
    let flgFormatter = DateFormatter()
    var userEmail: String
    var userPW: String
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    HStack{
                        Text("設定個人資料")
                            .font(.system(size: 27))
                            .bold()
                        Image("ms")
                            .resizable()
                            .scaledToFit()
                            .offset(x: 50)
                    }
                    .frame(height: 100)
                    //基本資料
                    Group{
                        HStack{
                            Image(systemName: "person.crop.circle")
                            TextField("輸入暱稱", text: $userDisplayName, onCommit: { UIApplication.shared.endEditing() })
                        }
                        HStack{
                            Image(systemName: "g.circle")
                            Text("性別")
                            Spacer()
                            Picker(selection: $genderSelect, label: Text("性別")) {
                                Text(gender[0]).tag(0)
                                Text(gender[1]).tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 100)
                            .shadow(radius: 5)
                        }
                        HStack{
                            Image(systemName: "calendar")
                            Text("生日")
                            Spacer()
                            Text(myDateFormatter.string(from: userBD))
                        }
                        DatePicker("生日", selection: $userBD, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        Picker(selection: $userCountrySelect, label: Text("來自哪個國家")) {
                            ForEach(countries.indices) { (index) in
                                Text(countries[index])
                            }
                        }
                    }
                    //紙娃娃
                    Group{
                        HStack {
                            Spacer()
                            if genderSelect == 0 {
                                Image("m" + String(hairSelect+4) + String(faceSelect) + String(accessoriesSelect) + String(overAllSelect))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 230)
                                /*VStack{
                                    ZStack{
                                        Image("head-" + String(hairSelect+4))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                        Image("face_" + String(faceSelect))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23, height: 23)
                                        Image("accessories-" + String(accessoriesSelect))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23, height: 23)
                                            .offset(x:-3, y:-1)
                                            .padding()
                                        
                                    }
                                    .offset(x:-5, y:53)
                                    .padding()
                                    Image("pose-" + String(overAllSelect))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 200)
                                        .offset(y:-22)
                                        .padding()
                                }*/
                                    
                            } else {
                                Image("f" + String(hairSelect+1) + String(faceSelect) + String(accessoriesSelect) + String(overAllSelect+2))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 230)
                                /*VStack{
                                    ZStack{
                                        Image("head-" + String(hairSelect+1))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                        Image("face_" + String(faceSelect))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23, height: 23)
                                        Image("accessories-" + String(accessoriesSelect))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23, height: 23)
                                            .offset(x:-3, y:-1)
                                            .padding()
                                    }
                                    .offset(x:-5, y:53)
                                    .padding()
                                    Image("pose-" + String(overAllSelect+2))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 200)
                                        .offset(y:-22)
                                        .padding()
                                }*/
                            }
                            Spacer()
                        }
                        HStack {
                            Image("666")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 50)
                            Spacer()
                            Button(action:{
                                randomDoll()
                            }){
                                Text("隨機")
                                .font(.title3)
                                .foregroundColor(.primary)
                            }
                            Spacer()
                            Image("666")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 50)
                        }.frame(height: 50)
                        VStack(alignment: .leading) {
                            Text("心情選擇")
                                .font(.system(size: 14))
                            ZStack{
                                LinearGradient(gradient: Gradient(colors: skinColor), startPoint: .leading, endPoint: .trailing)
                                    .cornerRadius(15)
                                Slider(value: $skinSlider, in: 0...3, step: 1, minimumValueLabel: Text("好").foregroundColor(.black), maximumValueLabel: Text("不好").foregroundColor(.black)) {
                                }.accentColor(Color.black)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                            }
                        }
                        VStack(alignment: .leading){
                            Text("髮型選擇")
                                .font(.system(size: 14))
                            Picker(selection: $hairSelect, label: Text("髮型選擇")) {
                                if genderSelect == 0 {
                                    ForEach(maleHair.indices) { (index1) in
                                        Text(maleHair[index1])
                                    }
                                } else {
                                    ForEach(femaleHair.indices) { (index1) in
                                        Text(femaleHair[index1])
                                    }
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        VStack(alignment: .leading){
                            Text("臉型選擇")
                                .font(.system(size: 14))
                            Picker(selection: $faceSelect, label: Text("臉型選擇")) {
                                ForEach(face.indices) { (index2) in
                                    Text(face[index2])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        VStack(alignment: .leading){
                            Text("飾品選擇")
                                .font(.system(size: 14))
                            Picker(selection: $accessoriesSelect, label: Text("飾品選擇")) {
                                ForEach(accessories.indices) { (index3) in
                                    Text(accessories[index3])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        VStack(alignment: .leading){
                            Text("套服選擇")
                                .font(.system(size: 14))
                            Picker(selection: $overAllSelect, label: Text("套服選擇")) {
                                Text(overAll[0]).tag(0)
                                Text(overAll[1]).tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    HStack{
                        Button(action:{
                            if userDisplayName == "" {
                                alertMsg = NSLocalizedString("暱稱不得為空", comment: "")
                                self.myAlert = Alert(title: Text("錯誤"), message: Text(alertMsg), dismissButton: .default(Text("好")))
                                showAlert = true
                            }
                            else{
                                uploadDollPhoto()
                                FireBase.shared.setUserDisplayName(userDisplayName: userDisplayName)
                            }
                        }){
                            HStack{
                                Image("pb")
                                    .resizable()
                                    .scaledToFit()
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .frame(width: 200, height: 100)
                                    .offset(x:-20)
                                Spacer()
                                Text("完成")
                                    .font(.system(size: 27))
                                    .bold()
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(.red)
                            }
                        }
//                        .fullScreenCover(isPresented: $showContentView, content: {
//                            ContentView()
//                        })
                        .alert(isPresented: $showAlert) { () -> Alert in
                            return self.myAlert
                        }
                    }
                }
            }
            .background(
                Image("bg")
                    .contrast(0.8)
            )
            .navigationBarHidden(true)
            .onAppear{
                myDateFormatter.dateFormat = "y MMM dd"
                flgFormatter.dateFormat = "y MMM dd HH:mm"
                //記錄第一次登入時間
                self.userFirstLoginStr = flgFormatter.string(from: currentDate)
                self.customSegmentListStyle()
            }
        }
    }

    func randomDoll() -> Void {
        hairSelect = Int.random(in: 0...2)
        faceSelect = Int.random(in: 0...3)
        overAllSelect = Int.random(in: 0...1)
        skinSlider = CGFloat(Int.random(in: 0...3))
    }
    
    func showAlertMsg(msg: String) -> Void {
        self.alertMsg = msg
        if alertMsg == "設置基本資料成功" {
            self.myAlert = Alert(title: Text("成功"), message: Text(alertMsg), dismissButton: .default(Text("請重新登入"), action: {
                //FireBase.shared.userSingOut()
                self.presentationMode.wrappedValue.dismiss()}))
            self.showAlert = true
        }
        else {
            self.myAlert = Alert(title: Text("錯誤"), message: Text(alertMsg), dismissButton:
                .cancel(Text("重新輸入")))
            self.showAlert = true
        }
    }
    
    func uploadDollPhoto() -> Void {
        var gs = "m"
        var hs = 4
        var cloth = 0
        if genderSelect == 1 {
            gs = "f"
            hs = 1
            cloth = 2
        }
        let image = Image(gs + String(hairSelect+hs) + String(faceSelect) + String(accessoriesSelect) + String(overAllSelect+cloth)).snapshot()
        FireBase.shared.uploadPhoto(image: image) { result in
            switch result {
            case .success(let url):
                print("上傳照片成功")
                FireBase.shared.setUserPhoto(url: url) { result in
                    switch result {
                    case .success(let msg):
                        print(msg)
                        let newUser = UserData(userID: myUserData.currentUser?.uid, userName: userDisplayName, userPhotoURL: url.absoluteString, userGender: gender[genderSelect], userBD: myDateFormatter.string(from: userBD), userFirstLogin: userFirstLoginStr, userCountry: countries[userCountrySelect])
                        FireBase.shared.createUserData(ud: newUser, uid: myUserData.currentUser!.uid) {
                            (result) in
                            switch result {
                            case .success(let sucmsg):
                                print(sucmsg)
                                FireBase.shared.userSingOut()
                                showAlertMsg(msg: NSLocalizedString("設置基本資料成功", comment: ""))
                            case .failure(_):
                                print("上傳錯誤")
                                showAlertMsg(msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                            }
                        }
                    case .failure(_):
                        print("設置頭像錯誤")
                    }
                }
            case .failure(let error):
               print(error)
            }
        }
    }
    
    private func customSegmentListStyle() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.white)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.clear)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(Color.primary)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(Color.black)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .body)], for: .normal)
    }
    
}

struct FirstLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLoginView(userEmail: "", userPW: "")
    }
}

//convert a SwiftUI view to an image
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
