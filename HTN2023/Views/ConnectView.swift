//
//  ConnectView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct ConnectView: View {
    @State var participants: [(id: Int, name: String)]

    @AppStorage("app.id") var id: Int?

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Capsule().frame(maxWidth: 6, minHeight: 0)
                            VStack(alignment: .leading) {
                                Text("SUMMARY").font(.largeTitle).bold()
                                Text("You completed today's Kickback!").fontWeight(.semibold)
                            }
                        }.fixedSize(horizontal: false, vertical: true).foregroundStyle(Color.black)
                        Spacer(minLength: 40)
                        Text("TODAY").foregroundStyle(Color(uiColor: .secondaryLabel)).bold().font(.headline).padding(.bottom, -8)
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(participants, id: \.id) { participant in
                                Button {
                                    Task {
                                        if let id {
                                            await APIManager.shared.connect(id: id, otherId: participant.id)
                                            
                                        }
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(participant.name.uppercased()).bold()
                                            Text("Waiting...").foregroundStyle(Color(uiColor: .secondaryLabel))
                                        }
                                        Spacer()
                                        Image(systemName: "checkmark.circle").font(.system(size: 20))
                                    }.frame(maxWidth: .infinity, idealHeight: 50)
                                        .padding(10)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                }
                            }.frame(maxWidth: .infinity)
                        }.frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }.frame(maxWidth: .infinity)
                    Spacer(minLength: 40)
                    Text("You've kicked it 1 day in a row!").font(.headline).bold()
                    Spacer(minLength: 40)
                    Button {
                        print("done")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).fill(Color.black)
                            Text("Finish")
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }.foregroundStyle(Color.black).frame(maxWidth: .infinity, maxHeight: 50)
                }.frame(maxWidth: .infinity)
                    .padding(10)
            }.frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity).navigationBarBackButtonHidden()
    }
}

