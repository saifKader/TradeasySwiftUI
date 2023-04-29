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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    init(socketManager: SocketIOManager, bidEnded: Binding<Bool>) {
        self.socketManager = socketManager
        self._bidEnded = bidEnded
        
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
        VStack( spacing: 20) {
            if let bidEndDate = socketManager.product?.bidEndDate, timerManager.remainingTime > 0 {
                let endDate = Date(timeIntervalSince1970: TimeInterval(bidEndDate / 1000))
                let duration = endDate.timeIntervalSince(Date())
                VStack {
                    ProgressView(value: min(max(0, Double(timerManager.remainingTime)), timerManager.duration), total: timerManager.duration)
                        .padding(.bottom, 5)
                    Text("Bid ends in: \(formatTime(Int(timerManager.remainingTime)))")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color("app_color"))
                .cornerRadius(10)
                
                .padding(.horizontal,15)
            } else {
                VStack {
                    Text("Bid has ended.")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
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

            VStack( spacing: 10) {
                Text("Enter your bid:")
                    .font(.headline)
                TextField("Enter your bid", value: $bidAmount, formatter: NumberFormatter())
                    .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .padding(.horizontal)
            }
            .onChange(of: bidAmount) { newValue in
                canPlaceBid = newValue != 0 && Double(newValue) != Double(socketManager.product?.price ?? 0.0) &&  newValue >=   Double(socketManager.product?.price ?? 0.0)
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
                   
            Spacer()
        }
        
        .onAppear {
            socketManager.socketBid.connect()
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

