//
//  LoginCodeInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginCodeInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    @State var code: String = ""
    @State var verified: Bool? = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Capsule().frame(maxWidth: 6, minHeight: 0)
                    VStack(alignment: .leading) {
                        Text("Input the code below.")
                            .font(.title2)
                            .bold()
                        TextField("", text: $code, prompt: Text("••••••")
                            .font(.largeTitle)
                            .bold()
                        ).textContentType(.oneTimeCode)
                            .padding(.top, -10)
                            .font(.largeTitle)
                            .bold()
                    }
                }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(
                    destination: LoginNameInputView().environmentObject(loginViewModel),
                    tag: true,
                    selection: $verified
                ) {
                    Button {
                        Task {
                            if let id = await APIManager.shared.verifyCode(phone: loginViewModel.phone, code: code) {
                                loginViewModel.id = id
                                verified = true
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).fill(code.count != 6 ? Color.gray : Color.black)
                            Text("Verify")
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }.disabled(code.count != 6)
                }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.task {
            await APIManager.shared.sendCode(phone: loginViewModel.phone)
        }.onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginCodeInputView()
}
