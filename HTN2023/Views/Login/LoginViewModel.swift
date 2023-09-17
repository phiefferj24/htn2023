//
//  LoginViewModel.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthday: Date?
    @Published var phone: String = ""
    @Published var id: Int?
    @Published var college: String?
    @Published var year: Int?
    @Published var interests: [String] = []
    @Published var isPresented: Bool = true

    @Published var instagram: String = ""
    @Published var tiktok: String = ""
    @Published var snapchat: String = ""
    @Published var twitter: String = ""
}
