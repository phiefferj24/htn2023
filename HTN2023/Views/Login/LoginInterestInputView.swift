//
//  LoginInterestInputView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct LoginInterestInputView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @State var verified: Bool? = false

    @Environment(\.presentationMode) var presentationMode

    static let interests: [String: [String]] = [
        "News": [
            "Tech",
            "Gaming",
            "Cars",
            "Crypto",
            "U.S. Politics", 
            "Int'l Politics",
            "Health",
            "Space",
            "Science",
            "Stocks & Investing",
            "Career",
            "Finance",
            "Climate Change",
            "Pop Culture"
        ],
        "Lifestyle": [
            "Books",
            "Travel",
            "TV & Movies",
            "Nature",
            "Internet Culture",
            "Recipes & Cooking",
            "Design",
            "Shopping",
            "Men's Fashion",
            "Exercise",
            "Women's Fashion",
            "Art",
            "Restaurants",
            "Relationships",
            "Comedy"
        ],
        "Sports": [
            "NBA",
            "NFL",
            "MLB",
            "F1",
            "NHL",
            "College Football",
            "College Basketball",
            "Golf",
            "Tennis",
            "Soccer",
            "Cycling",
            "Swimming",
            "Skiing",
            "Track & Field",
            "Rowing"
        ]
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Capsule().frame(maxWidth: 6, minHeight: 0)
                        VStack(alignment: .leading) {
                            Text("Personalize your match choices")
                                .font(.title2)
                                .bold()
                            Text("Select at least 5 items")
                        }.frame(maxWidth: .infinity)
                    }.fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity)
                    ForEach(Array(Self.interests.keys), id: \.self) { key in
                        Text(key.uppercased()).foregroundStyle(Color(uiColor: .secondaryLabel))
                        FlowLayout(spacing: 10) {
                            ForEach(Self.interests[key] ?? [], id: \.self) { value in
                                Button {
                                    if let index = loginViewModel.interests.firstIndex(where: { $0 == value }) {
                                        loginViewModel.interests.remove(at: index)
                                    } else {
                                        loginViewModel.interests.append(value)
                                    }
                                } label: {
                                    if loginViewModel.interests.contains(value) {
                                        ZStack {
                                            Capsule().fill(Color.black)
                                            Text(value)
                                                .foregroundStyle(Color.white)
                                                .padding(10)
                                        }
                                    } else {
                                        Text(value)
                                            .foregroundStyle(Color.black)
                                            .padding(10)
                                            .overlay {
                                                Capsule().stroke(Color.gray, lineWidth: 2)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(
                        destination: LoginSocialsInputView().environmentObject(loginViewModel),
                        tag: true,
                        selection: $verified
                    ) {
                        Button {
                            Task {
                                if let id = loginViewModel.id {
                                    await APIManager.shared.setInterests(id: id, interests: loginViewModel.interests)
                                    verified = true
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(loginViewModel.interests.count < 5 ? Color.gray : Color.black)
                                Text("Next")
                                    .padding(10)
                                    .foregroundStyle(Color.white)
                                    .bold()
                            }
                        }.disabled(loginViewModel.interests.count < 5)
                    }.isDetailLink(false).frame(maxWidth: .infinity, maxHeight: 50)
                }.frame(maxWidth: .infinity)
                    .padding(30)
            }
        }.onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    LoginInterestInputView().environmentObject(LoginViewModel())
}
