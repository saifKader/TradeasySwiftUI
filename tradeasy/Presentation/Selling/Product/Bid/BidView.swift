import SwiftUI
import SocketIO

struct BidView: View {
    @ObservedObject var socketManager: SocketIOManager
    @State var bidAmount: Double = 0.0
    @State var refreshUI = false
    
    var body: some View {
        VStack {
            
            Text("Current Price: \(socketManager.product?.price ?? 0.0)")
                .onReceive(socketManager.$refreshUI) { _ in
                    DispatchQueue.main.async {
                        self.bidAmount = Double(socketManager.product?.price ?? 0.0)
                    }
                }

            Text("Enter your bid:")
            TextField("Bid amount", value: $bidAmount, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .padding()

            
                Button(action: {
                    let bidData: [String: Any] = [
                        "user_id": userPreferences.getUser()?._id ?? "",
                        "product_id": socketManager.product?._id ?? "",
                        "bid_amount": Float(bidAmount),
                    ]

                    socketManager.placeBid(bidData: bidData)
                    // Update the trigger to refresh the UI
                    self.refreshUI.toggle()
                }) {
                    Text("Place Bid")
                }
            
           
            .disabled(bidAmount <= Double(socketManager.product?.price ?? 0.0))
        }
        .onAppear {
            socketManager.socketBid.connect()
        }
        // Observe changes to the trigger and refresh the UI
        .onChange(of: refreshUI) { _ in
            DispatchQueue.main.async {
                // Reload the view to reflect the updated product price
                self.bidAmount = Double(socketManager.product?.price ?? 0.0)
            }
        }
    }
}
