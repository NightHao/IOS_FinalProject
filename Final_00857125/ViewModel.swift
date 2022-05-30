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
}
