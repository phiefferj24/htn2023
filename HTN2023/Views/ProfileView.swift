//
//  ProfileView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/17/23.
//

import SwiftUI
import NukeUI

struct Social: Codable {
    let service: String
    let username: String
    let url: String
}

struct ProfileView: View {
    @State var id: Int
    @State var name: String
    @State var avatar: String

    @State var socials: [Social] = []

    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyImage(imageURL: URL(string: avatar)).scaledToFit().frame(height: 250).clipShape(Circle()).overlay {
                        Circle().stroke(Color.white, lineWidth: 6)
                        Circle().stroke(Color.black, lineWidth: 2)
                    }
                    Text(name.uppercased()).font(.largeTitle).bold()
                    Text("University of Waterloo").bold()
                    ForEach(socials, id: \.service) { connection in
                        Button {
                            if let url = URL(string: connection.url) {
                                openURL(url)
                            }
                        } label: {
                            ZStack {
                                HStack {
                                    Group {
                                        switch connection.service {
                                        case "twitter": Image(ImageResource.X).resizable().scaledToFit()
                                        case "tiktok": Image(ImageResource.tikTok).resizable().scaledToFit()
                                        case "instagram": Image(ImageResource.instagram).resizable().scaledToFit()
                                        case "snapchat": Image(ImageResource.snapchat).resizable().scaledToFit()
                                        default: EmptyView()
                                        }
                                    }.frame(width: 25, height: 25)
                                    VStack(alignment: .leading) {
                                        Text("@\(connection.username)")
                                        Text(connection.url).underline().font(.subheadline).lineLimit(1).truncationMode(.middle)
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square")
                                }.padding(10)
                                RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)
                            }
                        }.foregroundStyle(Color.black)
                    }
                }.padding(20)
            }
        }.task {
            self.socials = await APIManager.shared.getSocials(id: id)
        }
    }
}
