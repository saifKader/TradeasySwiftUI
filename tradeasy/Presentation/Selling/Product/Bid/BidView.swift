import SwiftUI
import SocketIO


struct BidView: View {
    @ObservedObject var socketManager: SocketIOManager
    @State var bidAmount: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Current Price: \(socketManager.product?.price ?? 0.0)")
                .onReceive(socketManager.$product) { product in
                    if let price = product?.price {
                        DispatchQueue.main.async {
                            self.bidAmount = Double(price)
                        }
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
            }) {
                Text("Place Bid")
            }
        }
        .onAppear {
            socketManager.socketBid.connect()
        }
    }
}
