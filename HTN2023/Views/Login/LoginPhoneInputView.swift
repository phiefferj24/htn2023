//
//  LoginPhoneInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginPhoneInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    var isValidPhone: Bool {
        loginViewModel.phone.first == "+" && loginViewModel.phone.dropFirst(1).allSatisfy({ $0.isNumber })
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Capsule().frame(maxWidth: 6, minHeight: 0)
                    VStack(alignment: .leading) {
                        Text("What's your phone number?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.phone, prompt: Text("+12223334444")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.telephoneNumber)
                            .padding(.top, -10)
                            .font(.largeTitle)
                            .bold()
                    }
                }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(destination: LoginCodeInputView().environmentObject(loginViewModel)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).fill(!isValidPhone ? Color.gray : Color.black)
                        Text("Send Me a Code")
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
                    .disabled(!isValidPhone)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginPhoneInputView()
}
