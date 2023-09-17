//
//  VideoParticipantView.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

class MyViewFactory: ViewFactory {
    static let shared = MyViewFactory()

    func makeCallControlsView(viewModel: CallViewModel) -> some View {
        EmptyView()
    }

    func makeCallTopView(viewModel: CallViewModel) -> some View {
        EmptyView()
    }

    func makeVideoParticipantView(participant: CallParticipant, id: String, availableSize: CGSize, contentMode: UIView.ContentMode, customData: [String : RawJSON], call: Call?) -> some View {
        EmptyView()
    }

    func makeVideoParticipantsView(
        viewModel: CallViewModel,
        availableSize: CGSize,
        onViewRendering: @escaping (VideoRenderer, CallParticipant) -> Void,
        onChangeTrackVisibility: @escaping @MainActor(CallParticipant, Bool) -> Void
    ) -> some View {
        Group {
            let participants = viewModel.participants + (viewModel.localParticipant.flatMap({ [ $0 ] }) ?? [])
            let availableSize = CGSize(width: availableSize.width, height: availableSize.height)
            if participants.count < 4 {
                VStack(spacing: 10) {
                    ForEach(participants) { participant in
                        ZStack(alignment: .bottom) {
                            VideoCallParticipantView(
                                participant: participant,
                                id: participant.id,
                                availableSize: CGSize(
                                    width: availableSize.width - 10,
                                    height: availableSize.height / CGFloat(participants.count) - 10
                                ),
                                contentMode: .scaleAspectFill,
                                customData: [:],
                                call: viewModel.call
                            ).frame(width: availableSize.width - 10, height: availableSize.height / CGFloat(participants.count) - 10).clipShape(RoundedRectangle(cornerRadius: 15)).overlay {
                                if participant.id == viewModel.localParticipant?.id {
                                    RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 6)
                                    RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2)
                                }
                            }
                            Text(participant.name.uppercased())
                                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                .foregroundStyle(Color.black)
                                .font(.caption).fontWeight(.bold)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding(10)
                        }
                    }
                }
            } else {
                LazyVGrid(columns: [.init(), .init()], spacing: 10) {
                    ForEach(participants) { participant in
                        ZStack(alignment: .bottom) {
                            VideoCallParticipantView(
                                participant: participant,
                                id: participant.id,
                                availableSize: CGSize(
                                    width: availableSize.width / 2 - 10,
                                    height: availableSize.height / CGFloat(participants.count) * 2 - 10
                                ),
                                contentMode: .scaleAspectFill,
                                customData: [:],
                                call: viewModel.call
                            ).frame(width: availableSize.width / 2 - 10, height: availableSize.height / CGFloat(participants.count) * 2 - 10).clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    if participant.id == viewModel.localParticipant?.id {
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 6)
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2)
                                    }
                                }
                            Text(participant.name.uppercased())
                                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                .foregroundStyle(Color.black)
                                .font(.caption).fontWeight(.bold)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding(10)
                        }
                    }
                }
            }
        }
    }

    func makeCallView(viewModel: CallViewModel) -> some View {
        CallView(viewFactory: self, viewModel: viewModel)
    }

    func makeLocalParticipantViewModifier(localParticipant: CallParticipant, callSettings: Binding<CallSettings>) -> some ViewModifier {
        EmptyModifier()
    }

    func makeVideoCallParticipantModifier(participant: CallParticipant, call: Call?, availableSize: CGSize, ratio: CGFloat, showAllInfo: Bool) -> some ViewModifier {
        EmptyModifier()
    }
}
