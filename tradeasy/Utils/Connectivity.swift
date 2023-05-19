import Network
import Combine

class ConnectivityMonitor: ObservableObject {
    @Published var isConnected: Bool = false
    let connectivityPublisher = PassthroughSubject<Bool, Never>()

    private var monitor: NWPathMonitor?

    init() {
        startMonitoring()
    }

    public func startMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectivityPublisher.send(self?.isConnected ?? false)
            }
        }
    }

    public func stopMonitoring() {
        monitor?.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
