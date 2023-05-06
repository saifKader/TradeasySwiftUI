//
// BidderViewModel.swift
// tradeasy
//
// Created by Abdelkader Seif Eddine on 5/5/2023.
//

import Foundation

enum BidderListState {
    case idle
    case loading
    case success([BidderModel])
    case error(Error)
}

class ProductBidderListViewModel: ObservableObject {
    @Published var state: ProductDetailsViewState = .idle
    @Published var bidderListState: BidderListState = .idle
    @Published var bidders: [BidderModel] = []
    
    @Published var socketManager: SocketIOManager

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    private let bidderUseCase: BidderUseCase
    
    init(socketManager: SocketIOManager, productId: String, bidderRepository: IBidderRepository = BidderRepositoryImpl(bidderApi: BidderAPI())) {
        self.socketManager = socketManager
        self.bidderUseCase = BidderUseCase(repo: bidderRepository)
        self.fetchBids(forProduct: productId)
    }

    
    func fetchBids(forProduct productId: String) {
        DispatchQueue.main.async {
            self.bidderListState = .loading
        }

        Task {
            let result = await bidderUseCase.fetchBids(forProduct: productId)

            DispatchQueue.main.async {
                switch result {
                case .success(let bidderList):
                    self.bidderListState = .success(bidderList)
                    for bidder in bidderList {
                        print("Bidder username: \(bidder.userProfilePic)")
                    }
                case .failure(let error):
                    print("hehe boy\(error)")
                    print("Error: \(error)")
                    self.bidderListState = .error(error)
                }
            }
        }
    }
}
