import Foundation
import SocketIO

class SocketIOManager: ObservableObject {
    @Published var product: ProductModel?
    
    let managerBid = SocketManager(socketURL: URL(string: "http://192.168.1.13:9090")!, config: [.log(true), .compress])
    lazy var socketBid = managerBid.defaultSocket

    init(product: ProductModel) {
        self.product = product
        self.setupSocket()
    }

    func setupSocket() {
        socketBid.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }

        socketBid.on(BidPayloadEnum.NEW_BID.rawValue) { data, ack in
            print("Received new bid data: \(data)")
            if let bidData = data.first as? [String: Any],
               let productId = bidData["product_id"] as? String,
               let newPrice = bidData["bid_amount"] as? Double {
                if self.product?._id == productId {
                    DispatchQueue.main.async {
                        self.product?.price = Float(newPrice)
                    }
                    print("Received new bid for product \(productId)")
                    print("Product price updated to \(newPrice)")
                }
            }
        }
    }

    func placeBid(bidData: [String: Any]) {
        print("Placing bid with data: \(bidData)")
        socketBid.emit(BidPayloadEnum.BID_PLACED.rawValue, with: [bidData], completion: nil)
        // Update the product property of SocketIOManager
        if let productId = bidData["product_id"] as? String,
           let newPrice = bidData["bid_amount"] as? Double,
           self.product?._id == productId {
            DispatchQueue.main.async {
                self.product?.price = Float(newPrice)
            }
        }
    }

}

enum BidPayloadEnum: String {
    case BID_PLACED = "bid_placed"
    case NEW_BID = "new_bid"
    case OUTBID = "outbid"
}
