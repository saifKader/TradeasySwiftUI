//
//  SearchViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation
enum ChatBotState {
    case idle
    case loading
    case chatBotSucess(String)
    case error(Error)
}



class ChatBotViewModel: ObservableObject {
    @Published var state: ChatBotState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
            if case .loading = state {
                return true
            }
            return false
        }
    var getChatBotUseCase : ChatBotUseCase

    init() {
        @Inject var repository: IUserRepository
        getChatBotUseCase = ChatBotUseCase(repo: repository)
    }



    
    func chatBot(message: ChatBotReq, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            let result = await getChatBotUseCase.chatBot(message)
    
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self.state = .chatBotSucess(message)
                print("message is \(message) ")
                    completion(.success(message))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
}
