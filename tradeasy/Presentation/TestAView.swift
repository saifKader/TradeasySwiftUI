
import SwiftUI

struct TestViewz: View {
    let images = ["furniture", "electronics", "clothing"] // Replace with your image names

    @State private var currentIndex = 0

    var body: some View {
        VStack {
            Image(images[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 200)
            
            HStack {
                Button(action: {
                    withAnimation {
                        currentIndex = (currentIndex - 1 + images.count) % images.count
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentIndex = (currentIndex + 1) % images.count
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}


