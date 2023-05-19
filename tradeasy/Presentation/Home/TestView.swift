import SwiftUI

struct Testttt: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack {
                // Your existing code here...

                Button(action: {
                    toggleTheme()
                }) {
                    Text("Switch to Dark Mode")
                        .foregroundColor(Color("font_color"))
                        .font(.custom("AvenirNext-DemiBold", size: 16))
                }
                .padding()
                .background(Color("button_color"))
                .cornerRadius(8)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom, 50)
        }
    }
    
    func toggleTheme() {
        if colorScheme == .dark {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
    }
}
