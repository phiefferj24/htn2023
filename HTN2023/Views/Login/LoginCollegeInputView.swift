//
//  LoginCollegeInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginCollegeInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Capsule().frame(maxWidth: 6, minHeight: 0)
                    VStack(alignment: .leading) {
                        Text("Which university do you attend?")
                            .font(.title2)
                            .bold()
                        Menu {
                            ForEach(CollegeList.list, id: \.self) { college in
                                Button {
                                    if college == loginViewModel.college {
                                        loginViewModel.college = nil
                                    } else {
                                        loginViewModel.college = college
                                    }
                                } label: {
                                    if college == loginViewModel.college {
                                        Label(college, systemImage: "checkmark")
                                    } else {
                                        Text(college)
                                    }
                                }
                            }
                        } label: {
                            Text(loginViewModel.college ?? "SELECT")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(loginViewModel.college == nil ? Color.gray : Color.black)
                                .multilineTextAlignment(.leading)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Text("What year are you?")
                            .font(.title2)
                            .bold()
                        Menu {
                            ForEach([4, 3, 2, 1], id: \.self) { year in
                                Button {
                                    if year == loginViewModel.year {
                                        loginViewModel.year = nil
                                    } else {
                                        loginViewModel.year = year
                                    }
                                } label: {
                                    if year == loginViewModel.year {
                                        Label("Year \(year)", systemImage: "checkmark")
                                    } else {
                                        Text("Year \(year)")
                                    }
                                }
                            }
                        } label: {
                            Text(loginViewModel.year.flatMap({ "Year \($0)" }) ?? "SELECT")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(loginViewModel.year == nil ? Color.gray : Color.black)
                                .multilineTextAlignment(.leading)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(destination: LoginInterestInputView().environmentObject(loginViewModel)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15).fill((loginViewModel.college == nil || loginViewModel.year == nil) ? Color.gray : Color.black)
                        Text("Next")
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
                    .disabled(loginViewModel.college == nil || loginViewModel.year == nil)
            }.frame(maxWidth: .infinity)
                .padding(30)
        }.onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginCollegeInputView().environmentObject(LoginViewModel())
}
