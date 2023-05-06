//
//  BidListView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import SwiftUI

struct BidListView: View {
    @ObservedObject var viewModel: ProductBidderListViewModel
       let sortedBids: [BidderModel]
       let groupedBids: [String: [BidderModel]]
       let productId: String
    
    var body: some View {
        VStack {
            switch viewModel.bidderListState {
            case .idle, .loading:
                ProgressView()
            case .success(let bidderList):
                if bidderList.isEmpty {
                    Text("No bids yet.")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            Spacer()
                            ForEach(sortedBids.indices, id: \.self) { index in
                                let bid = sortedBids[index]
                                let userName = bid.userName
                                let bidAmount = bid.bidAmount
                                let isPotentialWinner = index == 0

                                Button(action: {
                                    // Add action here to open user profile or perform other custom action
                                }, label: {
                                    HStack(spacing: 10) {

                                        ZStack {
                                            if let url = URL(string: kImageUrl + bid.userProfilePic) {
                                                AsyncImage(url: url) { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle())
                                                } placeholder: {
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle())
                                                }
                                            } else {
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.gray)
                                                    .clipShape(Circle())
                                            }
                                            
                                            if isPotentialWinner {
                                                Image(systemName: "crown.fill")
                                                    .foregroundColor(Color("app_color"))
                                                    .offset(x: 0, y: -35)
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Text(userName)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text("$\(String(format: "%.2f", bidAmount))")
                                                    .font(.headline)
                                                    .foregroundColor(Color("app_color"))
                                            }
                                        }
                                    }
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                })
                                .buttonStyle(PlainButtonStyle())
                                .animation(Animation.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: index)
                                .scaleEffect(isPotentialWinner ? 1.0 : 0.95)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding()
                }
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
}
