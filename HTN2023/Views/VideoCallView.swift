//
//  VideoCallView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import Foundation
import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct VideoCallView: View {
    @State var callCreated: Bool = false

    @StateObject var viewModel = CallViewModel()

    @State private var client: StreamVideo

    @AppStorage("app.id") var userId: Int?
    @AppStorage("app.name") var name: String?
    @Binding var token: String // The Token can be found in the Credentials section
    @Binding var callId: String

    let time: TimeInterval = Date.now.timeIntervalSince1970
    @State var diff: TimeInterval = 0

    @State var verified: Bool? = false

    var muted: Bool {
        viewModel.call?.microphone.status == .disabled
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(token: Binding<String>, callId: Binding<String>) {
        self._token = token
        self._callId = callId

        let user = User(
            id: String(UserDefaults.standard.integer(forKey: "app.id")),
            name: UserDefaults.standard.string(forKey: "app.name") ?? "", // name and imageURL are used in the UI
            imageURL: nil
        )

        // Initialize Stream Video client
        let tokenObj: UserToken = .init(stringLiteral: token.wrappedValue)
        self.client = StreamVideo(
            apiKey: "aafyv69rrq2b",
            user: user,
            token: tokenObj
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(
                    destination: ConnectView(participants: viewModel.participants.map({
                        (id: Int($0.userId) ?? 0, name: $0.name)
                    })),
                    tag: true,
                    selection: $verified
                ) {
                    EmptyView()
                }
                if callCreated {
                    Group {
                        CallContainer(viewFactory: MyViewFactory.shared, viewModel: viewModel).padding(20)
                        ZStack {
                            RoundedRectangle(cornerRadius: 25).fill(Color.white)
                            HStack {
                                Button {
                                    viewModel.toggleMicrophoneEnabled()
                                } label: {
                                    if muted {
                                        Image(systemName: "mic.slash").font(.system(size: 30))
                                    } else {
                                        Image(systemName: "mic").font(.system(size: 30))
                                    }
                                }.foregroundStyle(Color.black)
                                Spacer()
                                Text(Int(diff).toMinuteSecondString()).font(.system(size: 60)).fontWeight(.heavy).onReceive(timer) { _ in
                                    diff = max(300 - Date.now.timeIntervalSince1970 + time, 0)
                                }.foregroundStyle(diff <= 10 ? Color.red : Color.black)
                                Spacer()
                                Button {
                                    viewModel.toggleCameraPosition()
                                } label: {
                                    Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 30))
                                }.foregroundStyle(Color.black)
                            }.padding(20)
                        }.frame(maxWidth: .infinity, maxHeight: 100)
                    }.background(Color.black)
                } else {
                    ProgressView()
                }
            }.task {
                guard callCreated == false else { return }
                do {
                    viewModel.joinCall(callType: .default, callId: callId)
                    try await viewModel.call?.join()
                    callCreated = true
                } catch {
                    print(error)
                }
            }
        }.navigationBarBackButtonHidden()
            .ignoresSafeArea(.all, edges: .bottom)
            .onChange(of: diff) { _ in
                if diff <= 0 {
                    viewModel.call?.leave()
                    verified = true
                }
            }
    }
}
