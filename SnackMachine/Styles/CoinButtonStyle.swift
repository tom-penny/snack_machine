import SwiftUI

struct CoinButtonStyle : ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(width: 70, height: 80)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(configuration.isPressed ? Color(.white).opacity(0.5) : Color(.white).opacity(0.8))
            .background(Circle()
                .fill(.gray)
                .overlay {
                    Circle()
                        .stroke(.black.opacity(0.5), lineWidth: 5)
                        .blur(radius: 2)
                        .offset(x: 2, y: 2)
                }
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.5), lineWidth: 5)
                        .blur(radius: 2)
                        .offset(x: -2, y: -2)
                }
                .overlay {
                    Rectangle()
                        .rotation(.init(degrees:45))
                        .fill(.thinMaterial.opacity(0.5))
                        .frame(width: 30)
                        .blur(radius: 5)
                        .blendMode(.overlay)
                        .offset(x: configuration.isPressed ? -20 : 10, y: configuration.isPressed ? -20 : 10)
                    
                }
                .mask(Circle())
                .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 2)
            )
            .rotation3DEffect(.degrees(configuration.isPressed ? 15 : 0), axis: (x: -20, y: 20, z: 0))
            .animation(.spring(response: 0.3, dampingFraction: 0.15), value: configuration.isPressed)
    }
}
