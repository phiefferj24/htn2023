//
//  LoginWelcomeView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI
import NukeUI

struct LoginWelcomeView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                LazyImage(imageURL: URL(string: "https://assets.simpleviewinc.com/simpleview/image/upload/c_fill,f_jpg,h_962,q_65,w_640/v1/clients/whitemountainsnh/_jasonbosinoff_Mount_Liberty_d08cc584-2be2-47ec-941b-5a75bd096097.jpg"))
                VStack(alignment: .leading) {
                    Spacer(minLength: UIScreen.main.bounds.height * 0.6)
                    ZStack {
                        RoundedRectangle(cornerRadius: 25).fill(Color.white)
                        VStack {
                            Spacer()
                            HStack {
                                Capsule().frame(maxWidth: 6, minHeight: 0)
                                Text("Within 5 minutes, meet and reconnect with friends")
                                    .font(.largeTitle)
                                    .bold()
                            }.fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            NavigationLink(
                                destination: LoginPhoneInputView().environmentObject(loginViewModel)
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15).fill(Color.black)
                                    Text("Get Started")
                                        .padding(10)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                }
                            }.isDetailLink(false)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            Spacer()
                        }.frame(maxWidth: .infinity)
                            .padding(30)
                    }
                }
            }
        }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(.all).onDisappear {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview {
    LoginWelcomeView()
}
