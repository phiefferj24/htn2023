//
//  LoginNameInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginNameInputView: View {
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
                        Text("What's your name?")
                            .font(.title2)
                            .bold()
                        TextField("", text: $loginViewModel.name, prompt: Text("YOUR NAME")
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
                    destination: LoginBirthdayInputView().environmentObject(loginViewModel),
                    tag: true,
                    selection: $verified
                ) {
                    Button {
                        Task {
                            if let id = loginViewModel.id {
                                await APIManager.shared.setName(id: id, phone: loginViewModel.phone, name: loginViewModel.name)
                                verified = true
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).fill(loginViewModel.name.isEmpty ? Color.gray : Color.black)
                            Text("Verify")
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }.disabled(loginViewModel.name.isEmpty)
                }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.navigationBarBackButtonHidden().onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginNameInputView()
}
