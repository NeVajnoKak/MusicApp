//
//  ContentView.swift
//  MusicApp
//
//  Created by Erkebulan Massainov on 03.07.2024.
//

import SwiftUI
import AVKit

struct ContentView: View {
    let audioFileName = "forest"
    
    @State private var player: AVAudioPlayer?
    
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    @Binding var expendSheet: Bool
    var animation: Namespace.ID
    @State private var animationContent: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        Rectangle()
                        Image("mm")
                            .blur(radius: 55)
                    }
                
                VStack(spacing: 15) {
                    GeometryReader { geo in
                        let size = geo.size
                        Image("mm")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    PlayerView(size)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear(perform: setupAudio)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    private func pauseAudio() {
        player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader { geo in
            let size = geo.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Lucid Dreams")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Juice WRLD")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            // Action for ellipsis button
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Circle().fill(.ultraThickMaterial))
                        }
                    }
                    
                    Slider(value: Binding(get: { currentTime }, set: { newValue in seekAudio(to: newValue) }), in: 0...totalTime)
                        .accentColor(.white)
                    
                    HStack {
                        Text(timeString(time: currentTime))
                        Spacer()
                        Text(timeString(time: totalTime))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                HStack(spacing: size.width * 0.18) {
                    Button {
                        // Action for backward button
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button {
                        isPlaying ? pauseAudio() : playAudio()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button {
                        // Action for forward button
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.fill")
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        Button {
                            // Action for quote button
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        VStack(spacing: 6) {
                            Button {
                                // Action for AirPods button
                            } label: {
                                Image(systemName: "airpodspro.chargingcase.wireless.fill")
                                    .font(.title2)
                            }
                            Text("Erke")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Button {
                            // Action for list button
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
    }
}

#Preview {
    ContentView(expendSheet: .constant(true), animation: Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}

