//
//  HomeView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/17/23.
//

import SwiftUI
import NukeUI

struct HomeView: View {
    @AppStorage("app.id") var id: Int?
    @AppStorage("app.name") var name: String?

    @State var user: APIManager.User?

    @State var connections: [APIManager.Connection] = []

    @State var sheetShown = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Capsule().frame(maxWidth: 6, minHeight: 0)
                                VStack(alignment: .leading) {
                                    Text("HOME").font(.largeTitle).bold()
                                    Text("Let's Kickback.").fontWeight(.semibold)
                                }
                            }.fixedSize(horizontal: false, vertical: true).foregroundStyle(Color.black)
                            Spacer(minLength: 40)
                            Text("CONTACTS").foregroundStyle(Color(uiColor: .secondaryLabel)).bold().font(.headline).padding(.bottom, -8)
                            VStack(alignment: .leading, spacing: 1) {
                                ForEach(connections, id: \.id) { connection in
                                    NavigationLink(destination: ProfileView(id: connection.id, name: connection.name, avatar: connection.avatar_url)) {
                                        HStack {
                                            LazyImage(url: URL(string: connection.avatar_url)).frame(width: 50, height: 50).clipShape(Circle())
                                            VStack(alignment: .leading) {
                                                Text(connection.name.uppercased()).bold()
                                                Text(connection.connectionAge).foregroundStyle(Color(uiColor: .secondaryLabel)).font(.caption2)
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity, idealHeight: 50)
                                            .padding(10)
                                            .background(Color(uiColor: .secondarySystemBackground))
                                    }.foregroundStyle(Color.black)
                                }.frame(maxWidth: .infinity)
                            }.frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }.frame(maxWidth: .infinity)
                        Spacer(minLength: 40)
                        Text("You've kicked it 1 day in a row!").font(.headline).bold()
                        Spacer(minLength: 40)
                        Button {
                            sheetShown = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(Color.black)
                                Text("My Profile")
                                    .padding(10)
                                    .foregroundStyle(Color.white)
                                    .bold()
                            }
                        }.frame(maxWidth: .infinity, maxHeight: 50)
                    }.frame(maxWidth: .infinity)
                        .padding(10)
                }.frame(maxWidth: .infinity)
            }.sheet(isPresented: $sheetShown) {
                if let id, let name {
                    ProfileView(id: id, name: name, avatar: user?.avatar_url ?? "").presentationDetents([ .large ])
                }
            }.frame(maxWidth: .infinity).navigationBarBackButtonHidden()
        }.task {
            if let id {
                connections = await APIManager.shared.getConnections(id: id)
                user = await APIManager.shared.getUser(id: id)
            }
        }
    }
}

#Preview {
    HomeView()
}
