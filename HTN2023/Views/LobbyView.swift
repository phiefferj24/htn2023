//
//  LobbyView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/17/23.
//

import SwiftUI
import NukeUI

extension Int {
    func toMinuteSecondString() -> String {
        "\(self / 60):\((self % 60 < 10) ? "0\(self % 60)" : "\(self % 60)")"
    }
}

struct LobbyView: View {
    @State var callToken: String
    @State var callId: String = ""
    @State var time: Date
    @State var diff: TimeInterval = 0

    @State var verified: Bool? = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(
                    destination: VideoCallView(token: $callToken, callId: $callId),
                    tag: true,
                    selection: $verified
                ) {
                    EmptyView()
                }
                LazyImage(imageURL: URL(string: "https://assets.simpleviewinc.com/simpleview/image/upload/c_fill,f_jpg,h_962,q_65,w_640/v1/clients/whitemountainsnh/_jasonbosinoff_Mount_Liberty_d08cc584-2be2-47ec-941b-5a75bd096097.jpg"))
                VStack(alignment: .leading) {
                    Spacer(minLength: UIScreen.main.bounds.height * 0.6)
                    ZStack {
                        RoundedRectangle(cornerRadius: 25).fill(Color.white)
                        VStack {
                            Spacer()
                            HStack {
                                Capsule().frame(maxWidth: 6, minHeight: 0)
                                Text("It's time to meet and re-meet friends.")
                                    .font(.largeTitle)
                                    .bold()
                            }.fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Text(Int(diff).toMinuteSecondString()).font(.system(size: 100)).fontWeight(.heavy).onReceive(timer) { _ in
                                diff = max(30 - Date.now.timeIntervalSince(time), 0)
                            }
                            Spacer()
                        }.frame(maxWidth: .infinity)
                            .padding(20)
                    }
                }
            }
        }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(.all)
            .onAppear {
                diff = max(30 - Date.now.timeIntervalSince(time), 0)

                NotificationCenter.default.addObserver(forName: .init("app.startCall"), object: nil, queue: nil) { notification in
                    guard let info = notification.object as? [String: Any],
                          let participants = info["participants"] as? [Int],
                          let callId = info["callId"] as? String else { return }
                    print(participants, callId)
                    self.callId = callId
                    self.verified = true
                }
            }
    }
}
