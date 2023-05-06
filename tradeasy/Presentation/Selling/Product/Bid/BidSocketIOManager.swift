import Foundation
import SocketIO

class SocketIOManager: ObservableObject {
    @Published var product: ProductModel?
    @Published var message: String = ""
    @Published var refreshUI = false
    @Published var bidEnded: Bool = false
    @Published var bids: [BidderModel] = []


    let managerBid = SocketManager(socketURL: URL(string: kbaseUrl)!, config: [.log(true), .compress])
    lazy var socketBid = managerBid.defaultSocket

    init(product: ProductModel) {
        self.product = product
        self.setupSocket()
    }

    func setupSocket() {
        socketBid.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        socketBid.on(BidPayloadEnum.OUTBID.rawValue) { data, ack in
            print("Received outbid event: \(data)")
            if let message = data.first as? String {
                DispatchQueue.main.async {
                    self.message = message
                }
            }
        }
        socketBid.on(BidPayloadEnum.BID_ENDED.rawValue) { data, ack in
                print("Received bidend event: wfa \(data)")
                    DispatchQueue.main.async { [self] in
                        bidEnded = true
                    }
            }

        socketBid.on(BidPayloadEnum.NEW_BID.rawValue) { data, ack in
            print("Received new bid data: \(data)")
            if let bidData = data.first as? [String: Any],
                let productId = bidData["product_id"] as? String,
                let newPrice = bidData["bid_amount"] as? Double,
                let userName = bidData["user_name"] as? String,
                let userProfilePic = bidData["user_profile_pic"] as? String {
                    if self.product?._id == productId {
                        DispatchQueue.main.async {
                            self.product?.price = Float(newPrice)
                            self.refreshUI.toggle() // Add this line to trigger UI update

                            // Append the new bid to the bids array
                            let newBid = BidderModel(id: UUID().uuidString, userName: userName, userProfilePic: userProfilePic, bidAmount: Float(newPrice))
                            self.bids.append(newBid)

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
    case BID_ENDED = "bid_ended"
}
