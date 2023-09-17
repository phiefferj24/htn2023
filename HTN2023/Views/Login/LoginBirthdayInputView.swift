//
//  LoginBirthdayInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginBirthdayInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Capsule().frame(maxWidth: 6, minHeight: 0)
                    VStack(alignment: .leading) {
                        Text("When's your birthday?")
                            .font(.title2)
                            .bold()
                        TextField("", value: $loginViewModel.birthday, formatter: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyyMMdd"
                            return formatter
                        }(), prompt: Text("YYYYMMDD")
                            .font(.largeTitle)
                            .bold()
                        )
                            .padding(.top, -10)
                            .font(.largeTitle)
                            .bold()
                    }
                }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(destination: LoginCollegeInputView().environmentObject(loginViewModel)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).fill(loginViewModel.birthday == nil ? Color.gray : Color.black)
                        Text("Next")
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
                    .disabled(loginViewModel.birthday == nil)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginBirthdayInputView()
}
