//
//  ViewModel.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/29.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds
import Combine

var titleColor = Color(red: 255/255, green: 255/255, blue: 255/255)
var midNightBlue = Color(red: 58/255, green: 69/255, blue: 79/255)
var cbg0 = Color(red: 235/255, green: 178/255, blue: 125/255)
var cbg1 = Color(red: 164/255, green: 122/255, blue: 85/255)
var pikaPink = Color(red: 255/255, green: 198/255, blue: 201/255)
var dpPikaPink = Color(red: 255/255, green: 150/255, blue: 150/255)
var slimeGreen = Color(red: 133/255, green: 193/255, blue: 34/255)
var dpSlimeGreen = Color(red: 95/255, green: 178/255, blue: 0)


struct MyTextFieldStyle: TextFieldStyle {
    var bgBlue = Color(red: 203/255, green: 217/255, blue: 228/255)
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.black)
            .padding(20)
            .background(bgBlue)
                .opacity(0.8)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color(red: 121/255, green: 124/255, blue: 177/255), lineWidth: 2)
            ).padding()
    }
}

struct SearchRoomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(midNightBlue)
            .padding(20)
            .background(Color.blue)
            .opacity(0.8)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(midNightBlue, lineWidth: 5)
            ).padding()
    }
}
struct ADBannerView: UIViewRepresentable {

func makeUIView(context: Context) -> GADBannerView {
let bannerView = GADBannerView(adSize: GADAdSizeBanner)
bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
bannerView.rootViewController =
UIViewController.getLastPresentedViewController()
GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
let request = GADRequest()
bannerView.load(request)
return bannerView
}

func updateUIView(_ uiView: GADBannerView, context: Context) {
}

typealias UIViewType = GADBannerView
    
}


struct ButtonView: View {
    var buttonText: String
    //var buttonTextSize: Int = 25
    var body: some View {
        Text(buttonText)
            .font(.title3)
            .bold()
            .foregroundColor(Color(red: 214/255, green: 225/255, blue: 229/255))
            .padding(.horizontal, 50)
            .padding(.vertical, 16)
            .background(midNightBlue)
            .cornerRadius(20)
            .padding(2)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 134/255, green: 185/255, blue: 196/255), lineWidth: 5)
            )
    }
}

struct Button2View: View {
    var buttonText: String
    var body: some View {
        Text(buttonText)
            .font(.title3)
            .bold()
            .foregroundColor(midNightBlue)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background(Color.blue)
            .cornerRadius(20)
            .padding(2)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 5)
            )
    }
}

struct UserDataView: View {
    var dataIconStr: String
    var dataInfo: String
    var data: String
    var body: some View {
        HStack{
            Image(systemName: dataIconStr)
                .frame(width: 25)
            Text(dataInfo + ": " + data)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical,2)
    }
}

struct PiecePhoto: View {
    var strokeCol: Int
    var body: some View {
        if strokeCol == 0 {
            Image("cbbg" + String(strokeCol))
            .resizable()
            .frame(width: 43, height: 43)
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(red: 146/255, green: 127/255, blue: 105/255), lineWidth: 5))
            .cornerRadius(5)
        } else {
            Image("cbbg" + String(strokeCol))
            .resizable()
            .frame(width: 43, height: 43)
            .cornerRadius(5)
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(red: 204/255, green: 182/255, blue: 139/255), lineWidth: 5))
            .cornerRadius(5)
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { UIApplication.shared.endEditing() }
    var secure: Bool
    var isEmail: Bool
    var isNum: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            if secure {
                SecureField("", text: $text, onCommit: commit)
                    .textFieldStyle(MyTextFieldStyle())
            } else {
                if isEmail {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                        .keyboardType(.emailAddress)
                } else if isNum {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                        .keyboardType(.numberPad)
                } else {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                }
            }
            if text.isEmpty {
                placeholder
                    .font(.system(size: 17))
                    .offset(x: 40)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("", text: $text)
                .textFieldStyle(SearchRoomTextFieldStyle())
                .foregroundColor(.black)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                //.padding(10)
                //.padding(.vertical, 2)
                //.padding(.horizontal, 25)
                //.background(Color(red: 1, green: 247/255, blue: 235/255, opacity: 0.5))
                .cornerRadius(8)
                //.padding(.horizontal, 10)
                .keyboardType(.numberPad)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        if self.text == "" {
                            Text("輸入房號..")
                                .foregroundColor(midNightBlue)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 25)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                        } else {
                            Image(systemName: "")
                                .foregroundColor(midNightBlue)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 15)
                        }
                            
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(midNightBlue)
                                    .padding(.trailing, 15)
                            }
                        }
                    }.padding(.horizontal)
                )
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("取消")
                }.foregroundColor(midNightBlue)
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct LiquidSwipe: Shape {
    var offset: CGSize
    var animatableData: CGSize.AnimatableData {
        get{return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let from = 80 + offset.width
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            var to = 190 + offset.height + (-offset.width)
            to = to < 180 ? 180 : to
            
            let mid: CGFloat = 80 + ((to - 80) / 2)
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x:width - 50, y: mid), control2: CGPoint(x:width - 50, y: mid))
        }
    }
}

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: midNightBlue))
                        .scaleEffect(1.8)
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct dashLine: View {
    var dashNum: Int
    var body: some View {
        HStack {
            ForEach(0..<dashNum) {_ in
                Rectangle()
                    .foregroundColor(midNightBlue)
                    .padding(.horizontal, 1)
                    .frame(width: 10, height: 3)
            }
        }
    }
}

class TextLimit: ObservableObject {
    let charLimit = 6
    @Published var userInput = "" {
        didSet {
            if userInput.count > charLimit {
                userInput = String(userInput.prefix(charLimit))
            }
        }
    }
}

struct YellowShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(Color.yellow)
            .scaleEffect(x: 1, y: 4, anchor: .center)
            .shadow(color: midNightBlue,
                    radius: 20.0, x: 1.0, y: 4.0)
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

extension AVPlayer {
static let sharedDingPlayer: AVPlayer = {
guard let url = Bundle.main.url(forResource: "game-start", withExtension:
"mp3") else { fatalError("Failed to find sound file.") }
return AVPlayer(url: url)
}()

func playFromStart() {
seek(to: .zero)
play()
}
 static var bgQueuePlayer = AVQueuePlayer()

 static var bgPlayerLooper: AVPlayerLooper!

 static func setupBgMusic() {
    guard let url = Bundle.main.url(forResource: "game-bgm",
    withExtension: "mp3") else { fatalError("Failed to find sound file.") }
    let item = AVPlayerItem(url: url)
    bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}
var dingPlayer: AVPlayer {AVPlayer.sharedDingPlayer}

/*import Foundation
import SwiftUI
import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import Combine

var midNightBlue = Color(red: 58/255, green: 69/255, blue: 79/255)

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ButtonView: View {
    var buttonText: String
    //var buttonTextSize: Int = 25
    var body: some View {
        Text(buttonText)
            .font(.title3)
            .bold()
            .foregroundColor(Color(red: 214/255, green: 225/255, blue: 229/255))
            .padding(.horizontal, 50)
            .padding(.vertical, 16)
            .background(midNightBlue)
            .cornerRadius(20)
            .padding(2)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 134/255, green: 185/255, blue: 196/255), lineWidth: 5)
            )
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { UIApplication.shared.endEditing() }
    var secure: Bool
    var isEmail: Bool
    var isNum: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            if secure {
                SecureField("", text: $text, onCommit: commit)
                    .textFieldStyle(MyTextFieldStyle())
            } else {
                if isEmail {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                        .keyboardType(.emailAddress)
                } else if isNum {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                        .keyboardType(.numberPad)
                } else {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textFieldStyle(MyTextFieldStyle())
                }
            }
            if text.isEmpty {
                placeholder
                    .font(.system(size: 17))
                    .offset(x: 40)
            }
        }
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    var bgBlue = Color(red: 203/255, green: 217/255, blue: 228/255)
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.black)
            .padding(20)
            .background(bgBlue)
                .opacity(0.8)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color(red: 121/255, green: 124/255, blue: 177/255), lineWidth: 2)
            ).padding()
    }
}

struct UserDataView: View {
    var dataIconStr: String
    var dataInfo: String
    var data: String
    var body: some View {
        HStack{
            Image(systemName: dataIconStr)
                .frame(width: 25)
            Text(dataInfo + ": " + data)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical,2)
    }
}*/
