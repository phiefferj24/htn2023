//
//  ContentView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()

    @StateObject var viewModel = ContentViewModel()

    @AppStorage("app.id") var id: Int?
    @AppStorage("app.phone") var phone: String?

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            if id == nil || phone == nil {
                LoginWelcomeView().environmentObject(loginViewModel)
            } else if let videoData = viewModel.videoData {
                LobbyView(callToken: videoData.token, time: videoData.kickbackTime)
            } else {
                HomeView()
            }
        }.task {
            if let id {
                viewModel.videoData = await APIManager.shared.joinLobby(id: id)
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var showLogin: Bool = false
    @Published var path = NavigationPath()

    @Published var videoData: APIManager.ResponseBody2?
}
