//
//  HelpView.swift
//  NrvMap 3D
//
//  Created by Ian So on 27/3/2025.
//

import SwiftUI

struct HelpView: View {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen = false
    @State private var currentPage = 0
    @Environment(\.dismissWindow) private var  dismiss
    @Environment(\.openWindow) public var open
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var isVisible = false
    @State private var isTapped: Bool = true
    @State private var isShow: Bool = false

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {

                // Page 1
                HStack {
                    VStack(alignment: .leading, spacing: 40) {
                        Text("Nerve Map")
                            .font(
                                .system(
                                    size: 80,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .opacity(isVisible ? 1 : 0)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .blue,
                                        .purple
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 420, height: 100)
                                    .padding()
                            }



                        Text("Learn with realistic 3D models")
                            .opacity(isVisible ? 1 : 0)
                            .font(
                                .system(
                                    size: 40,
                                    weight: .semibold,
                                    design: .rounded
                                )
                            )
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 560, height: 60)
                                    .foregroundStyle(Color.gray.opacity(0.7))
                                    .padding()
                            }

                        Text("Digital Anatomy Dermatomes Map Solution")
                            .opacity(isVisible ? 1 : 0)
                            .font(
                                .system(
                                    size: 30,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                            .multilineTextAlignment(.leading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 570, height: 60)
                                    .foregroundStyle(Color.gray.opacity(0.7))
                                    .padding()
                            }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image("onboard1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isVisible ? 1 : 0)
                        .frame(width: 300, height: 500)
                        .padding()
                }
                .frame(width: 1000)
                .tag(0)


                // Page 2
                HStack(alignment: .center, spacing: 40) {
                    ZStack {
                        GeometryReader { geometry in
                            ZStack {
                                let spacingY: CGFloat = 80
                                let centerX = geometry.size.width * 0.4

                                // Rotate
                                Image("rotateIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX - 150, y: spacingY)
                                    .opacity(isVisible ? 1 : 0)

                                // Zoom In
                                Image("zoomInIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX-25, y: spacingY * 1.8)
                                    .opacity(isVisible ? 1 : 0)

                                // Zoom Out
                                Image("zoomOutIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX + 80 , y: spacingY * 3)
                                    .opacity(isVisible ? 1 : 0)

                                // Move Icon
                                Image("moveIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX + 170, y: spacingY * 4.4)
                                    .opacity(isVisible ? 1 : 0)

                                // Hand Gesture
                                Image("handGesture")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.90)
                                    .opacity(isVisible ? 1 : 0)
                            }
                        }
                        .frame(width: 400, height: 450)
                    }

                    VStack(spacing: 40) {
                        Text("Interactive Dermatome Map")
                            .opacity(isVisible ? 1 : 0)
                            .font(
                                .system(
                                    size: 80,
                                    weight: .semibold,
                                    design: .rounded
                                )
                            )


                        HStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 90)
                                .foregroundStyle(Color.gray.opacity(0.6))
                                .overlay {
                                    Text("Rotate")
                                        .font(
                                            .system(
                                                size: 30,
                                                weight: .semibold,
                                                design: .rounded
                                            )
                                        )
                                }
                                .hoverEffect { effect, isActive, geometry in
                                    effect.animation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        $0
                                            .rotationEffect(.degrees(isActive ? 15 : 0))
                                            .scaleEffect(isActive ? 1.2 : 1.0)
                                    }
                                }

                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 90)
                                .foregroundStyle(Color.gray.opacity(0.6))
                                .overlay {
                                    Text("Zoom-In")
                                        .font(
                                            .system(
                                                size: 30,
                                                weight: .semibold,
                                                design: .rounded
                                            )
                                        )
                                }
                                .hoverEffect { effect, isActive, geometry in
                                    effect.animation(.spring(duration: 1)) {
                                        $0.scaleEffect(isActive ? 1.2 : 1.0)
                                    }
                                }

                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 90)
                                .foregroundStyle(Color.gray.opacity(0.6))
                                .overlay {
                                    Text("Zoom-Out")
                                        .font(
                                            .system(
                                                size: 30,
                                                weight: .semibold,
                                                design: .rounded
                                            )
                                        )
                                }
                                .hoverEffect { effect, isActive, geometry in
                                    effect.animation(.spring(duration: 0.5)) {
                                        $0.scaleEffect(isActive ? 0.8 : 1.0)
                                    }
                                }

                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 160, height: 90)
                                .foregroundStyle(Color.gray.opacity(0.6))
                                .overlay {
                                    Text("Moving")
                                        .font(
                                            .system(
                                                size: 30,
                                                weight: .semibold,
                                                design: .rounded
                                            )
                                        )
                                }
                                .hoverEffect { effect, isActive, geometry in
                                    effect.animation(.spring(duration: 1)) {
                                        $0.offset(y: isActive ? -50 : 0)
                                    }
                                }
                        }
                    }
                    .multilineTextAlignment(.center)
                }
                .tag(1)

                // Page 3

                //                    Image("onboard3")
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: 450, height: 450)
                //                        .padding(-30)
                //                        .opacity(isVisible ? 1 : 0)

                VStack(spacing: 30) {
                    Text("Immersive & Learning")
                        .opacity(isVisible ? 1 : 0)
                        .font(
                            .system(
                                size: 60,
                                weight: .semibold,
                                design: .rounded
                            )
                        )
                        .multilineTextAlignment(.center)

                    Text("With One Powerful App")
                        .font(
                            .system(
                                size: 80,
                                weight: .heavy,
                                design: .rounded
                            )
                        )
                        .foregroundColor(
                            Color.mint.mix(with: .red, by: 0.8)
                        )
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.white)
                                .frame(width: 950, height: 100)
                        }

                    VStack {
                        Text("Try glancing at these buttons and see what they do!")
                            .font(
                                .system(
                                    size: 40,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )

                        HStack(spacing: 55) {
                            Button {
                                isTapped.toggle()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(isTapped ? Color.maleBule : Color.femalePink)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: isTapped ? "figure.stand" : "figure.stand.dress")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonBorderShape(.circle)
                            .help("Gender")


                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "square.stack.3d.up.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .buttonBorderShape(.circle)
                            .help("Immersive")

                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "note.text")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .buttonBorderShape(.circle)
                            .help("Notes")

                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 5, height: 100)

                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "graduationcap.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .buttonBorderShape(.circle)
                            .help("Learn")
                        }

                                                Text("To access this help anytime, tap the 'i' button.")
                                                    .font(
                                                        .system(
                                                            size: 30,
                                                            weight: .semibold,
                                                            design: .rounded
                                                        )
                                                    )
                    }
                }
                .frame(maxWidth: .infinity)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Navigation Arrows
            HStack {
                Button {
                    if currentPage > 0 { currentPage -= 1 }
                } label: {
                    if currentPage > 0{
                        Image(systemName: "arrow.left.circle.fill")

                            .resizable()
                            .frame(width: 40, height: 40)
                            .opacity(isVisible ? 1 : 0)
                    } else {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .opacity(isVisible ? 1 : 0)
                    }
                }
                .buttonBorderShape(.circle)
                .disabled(currentPage == 0)

                Spacer()

                if currentPage < 2 {
                    Button {
                        currentPage += 1
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .opacity(isVisible ? 1 : 0)
                            .frame(width: 40, height: 40)
                        //                            .foregroundColor(.blue)
                    }
                    .buttonBorderShape(.circle)

                } else {
                    Button {
                        dismiss(id: "HelpWindow")
                        if hasSeenWelcomeScreen == false{
                            open(id: "ModelDM")
                            dismiss(id: "WelcomeView")
                            hasSeenWelcomeScreen = true
                        }
                    } label: {
                        Text("Begin")
                            .padding(.horizontal, 30)
                            .opacity(isVisible ? 1 : 0)
                            .padding(.vertical, 12)
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
        }
        .background(Color.clear)
        .onAppear {
            self.isVisible = true
        }
    }
}

#Preview(windowStyle: .automatic) {
    HelpView()
        .environment(AppModel())
}
