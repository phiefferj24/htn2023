//
//  LoginSocialsInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginSocialsInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    @State var verified: Bool? = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Capsule().frame(maxWidth: 6, minHeight: 0)
                    VStack(alignment: .leading) {
                        Text("What's your Instagram?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.instagram, prompt: Text("OPTIONAL")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.name)
                        .padding(.top, -10)
                        .font(.largeTitle)
                        .bold()
                        Text("What's your TikTok?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.tiktok, prompt: Text("OPTIONAL")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.name)
                        .padding(.top, -10)
                        .font(.largeTitle)
                        .bold()
                        Text("What's your Snapchat?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.snapchat, prompt: Text("OPTIONAL")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.name)
                        .padding(.top, -10)
                        .font(.largeTitle)
                        .bold()
                        Text("What's your X (Twitter)?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.twitter, prompt: Text("OPTIONAL")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.name)
                        .padding(.top, -10)
                        .font(.largeTitle)
                        .bold()
                    }
                }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(
                    destination: HomeView(),
                    tag: true,
                    selection: $verified
                ) {
                    Button {
                        Task {
                            guard let id = loginViewModel.id else { return }
                            UserDefaults.standard.setValue(loginViewModel.id, forKey: "app.id")
                            UserDefaults.standard.setValue(loginViewModel.name, forKey: "app.name")
                            UserDefaults.standard.setValue(loginViewModel.phone, forKey: "app.phone")
                            UserDefaults.standard.setValue(loginViewModel.birthday, forKey: "app.birthday")
                            UserDefaults.standard.setValue(loginViewModel.college, forKey: "app.college")
                            UserDefaults.standard.setValue(loginViewModel.year, forKey: "app.year")
                            UserDefaults.standard.setValue(loginViewModel.interests, forKey: "app.interests")
                            if !loginViewModel.instagram.isEmpty {
                                UserDefaults.standard.setValue(loginViewModel.instagram, forKey: "app.instagram")
                                await APIManager.shared.setSocial(id: id, service: "instagram", username: loginViewModel.instagram)
                            }
                            if !loginViewModel.tiktok.isEmpty {
                                UserDefaults.standard.setValue(loginViewModel.tiktok, forKey: "app.tiktok")
                                await APIManager.shared.setSocial(id: id, service: "tiktok", username: loginViewModel.tiktok)
                            }
                            if !loginViewModel.snapchat.isEmpty {
                                UserDefaults.standard.setValue(loginViewModel.snapchat, forKey: "app.snapchat")
                                await APIManager.shared.setSocial(id: id, service: "snapchat", username: loginViewModel.snapchat)
                            }
                            if !loginViewModel.twitter.isEmpty {
                                UserDefaults.standard.setValue(loginViewModel.twitter, forKey: "app.twitter")
                                await APIManager.shared.setSocial(id: id, service: "twitter", username: loginViewModel.twitter)
                            }
                            if let ntoken = UserDefaults.standard.string(forKey: "app.notification.id") {
                                await APIManager.shared.setDeviceId(id: id, deviceId: ntoken)
                            }
                            loginViewModel.isPresented = false
                            verified = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).fill(loginViewModel.name.isEmpty ? Color.gray : Color.black)
                            Text("Finish")
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }.disabled(loginViewModel.name.isEmpty)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }.frame(maxWidth: .infinity, maxHeight: 50)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginSocialsInputView()
}
