import SwiftUI
import SocketIO

struct BidView: View {
    @ObservedObject var socketManager: SocketIOManager
    @State var bidAmount: Double = 0.0
    @State var refreshUI = false
    @Binding var bidEnded: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var canPlaceBid = false
    @StateObject var timerManager: TimerManager
    @State private var potentialWinner: BidderModel?
    @State private var step: Double = 1.0
    @StateObject private var bidderListViewModel: ProductBidderListViewModel

    let productId: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
   

    init(socketManager: SocketIOManager, bidEnded: Binding<Bool>, productId: String) {
        self.socketManager = socketManager
        self._bidEnded = bidEnded
        self.productId = productId
        self._bidderListViewModel = StateObject(wrappedValue: ProductBidderListViewModel(socketManager: socketManager, productId: productId))

        if let bidEndDate = socketManager.product?.bidEndDate {
            let endDate = Date(timeIntervalSince1970: TimeInterval(bidEndDate / 1000))
            self._timerManager = StateObject(wrappedValue: TimerManager(endDate: endDate))
        } else {
            self._timerManager = StateObject(wrappedValue: TimerManager(endDate: Date()))
        }
    }

    
    func formatTime(_ seconds: Int) -> String {
        let days = seconds / (24 * 3600)
        let remainingSeconds = seconds % (24 * 3600)
        let hours = remainingSeconds / 3600
        let remainingMinutes = remainingSeconds % 3600
        let minutes = remainingMinutes / 60
        let remainingSeconds2 = remainingMinutes % 60
        
        if days > 0 {
            return String(format: "%d days, %02d:%02d:%02d", days, hours, minutes, remainingSeconds2)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds2)
        }
    }
    
    var body: some View {
        VStack( spacing: 5) {
            if let bidEndDate = socketManager.product?.bidEndDate, timerManager.remainingTime > 0 {
                let endDate = Date(timeIntervalSince1970: TimeInterval(bidEndDate / 1000))
                let duration = endDate.timeIntervalSince(Date())
                VStack {
                    ProgressView(value: min(max(0, Double(timerManager.remainingTime)), timerManager.duration), total: timerManager.duration)
                        .padding(.bottom, 5)
                        //.tint(Color.white)
                    Text("Bid ends in: \(formatTime(Int(timerManager.remainingTime)))")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color("app_color"))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray5), lineWidth: 1))
                    .padding(.horizontal)
            } else {
                VStack {
                    Text("Bid has ended.")
                        .font(.headline)
                }
                .frame(width: 100, height: 100)
                .background(Color.white)
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.systemGray5), lineWidth: 1))
                .padding(.horizontal, 20)
            }
            
            Text("Current Price:")
                .font(.headline)
                .foregroundColor(.gray)
            HStack(alignment: .center, spacing: 5) {
                Text("$")
                    .font(.system(size: 20, weight: .medium, design: .default))
                Text(String(format: "%.2f", socketManager.product?.price ?? 0.0))
                    .font(.system(size: 40, weight: .bold, design: .default))
            }
            .onReceive(socketManager.$refreshUI) { _ in
                DispatchQueue.main.async {
                    self.bidAmount = Double(socketManager.product?.price ?? 0.0)
                }
            }
            
            

            

            VStack(spacing: 5) {
                Text("Enter your bid:")
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack {
                        Button(action: {
                            if bidAmount - step >= 0 {
                                bidAmount -= step
                            }
                        }, label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        })
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            UIApplication.shared.endEditing()
                        })

                        TextField("Enter your bid", value: $bidAmount, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 40)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5), lineWidth: 1))
                            .keyboardType(.decimalPad)
                        
                        Button(action: {
                            bidAmount += step
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        })
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            UIApplication.shared.endEditing()
                        })
                    }
               
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .padding(.horizontal)

                VStack(spacing: 20) {
                    Text("Increment/Decrement Step")
                        .font(.callout)
                        .fontWeight(.medium)

                    Picker("", selection: $step) {
                        Text("1").tag(1.0)
                        Text("5").tag(5.0)
                        Text("10").tag(10.0)
                        Text("20").tag(20.0)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
            }
            .onChange(of: bidAmount) { newValue in
                canPlaceBid = newValue != 0 && Double(newValue) != Double(socketManager.product?.price ?? 0.0) && newValue >= Double(socketManager.product?.price ?? 0.0)
                print("used to avoid bug")
            }


            
            ActionButton(text: "Place bid", action: {
                let bidData: [String: Any] = [
                    "user_id": userPreferences.getUser()?._id ?? "",
                    "product_id": socketManager.product?._id ?? "",
                    "bid_amount": Float(bidAmount),
                ]
                
                socketManager.placeBid(bidData: bidData)
                // Update the trigger to refresh the UI
                self.refreshUI.toggle()
            }, height: 20.0, width: .infinity, isEnabled: canPlaceBid && !bidEnded)
            .padding(.bottom, 10)
            
            
            // ...

            // Bid list
            let highestBidsByUser = Dictionary(grouping: socketManager.bids, by: { $0.userName }).map { $0.value.max(by: { $0.bidAmount < $1.bidAmount })! }
            let sortedBids = highestBidsByUser.sorted(by: { $0.bidAmount > $1.bidAmount })
            let groupedBids = Dictionary(grouping: sortedBids, by: { $0.userName })
            BidListView(viewModel: bidderListViewModel, sortedBids: sortedBids, groupedBids: groupedBids, productId: productId)





            // ...


            
            Spacer()
            
        }
        
        .onAppear {
            socketManager.socketBid.connect()
            bidderListViewModel.fetchBids(forProduct: productId)
           
            print( bidderListViewModel.fetchBids(forProduct: productId))
        }
        .onChange(of: socketManager.bidEnded) { newValue in
            if newValue {
                bidEnded = newValue
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        .onChange(of: refreshUI) { _ in
            DispatchQueue.main.async {
                self.bidAmount = Double(socketManager.product?.price ?? 0.0)
            }
        }
    }
    
    
    
}
class TimerManager: ObservableObject {
    let endDate: Date
    private var timer: Timer?
    
    @Published var remainingTime: TimeInterval
    let duration: Double
    
    init(endDate: Date) {
        self.endDate = endDate
        self.remainingTime = max(0, endDate.timeIntervalSinceNow)
        self.duration = max(0, endDate.timeIntervalSinceNow)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime = max(0, self.endDate.timeIntervalSinceNow)
        }
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
