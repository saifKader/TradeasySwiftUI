import SwiftUI

struct BidView: View {
    @State private var bidAmount = ""
    @State private var isCountingDown = true
    @State private var remainingTime = TimeInterval(10 * 60 * 60) // 10 hours in seconds
    @State var lastBid = 10.0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: remainingTime) ?? ""
    }

    var body: some View {
        VStack {
            
            HStack{
                Text("Time left:")
                
                Text(formattedTime)
                    .font(.headline)
                    .onReceive(timer) { _ in
                        if isCountingDown && remainingTime > 0 {
                            remainingTime -= 1
                        }
                    }
                
                
                
            }
      
            Text(String(format: "Last bid: %.1f TND", lastBid))

            
            HStack {
                TextField("Enter your bid", text: $bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.trailing, 8)
                    .keyboardType(.numberPad)
                Button(action: {
                    // Action to perform when the "Bid" button is tapped
                    print("Bid button tapped")
                }, label: {
                    Text("Bid")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
            }
        }
        .padding()
    }
}
