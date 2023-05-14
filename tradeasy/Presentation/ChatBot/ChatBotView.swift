import SwiftUI
import Combine
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isSentByCurrentUser: Bool
    let userImageUrl: URL?
    
      let botImage: Image?
}


struct ChatBotView: View {
    @State private var messages: [Message] = [
     
    ]
    @State private var newMessageText: String = ""
    @StateObject private var chatBotViewModel = ChatBotViewModel()
    @State private var userProfileImageUrl: URL?
    @State var isLoading: Bool = false
    
    init() {
        _userProfileImageUrl = State(initialValue: URL(string:  kImageUrl+(userPreferences.getUser()?.profilePicture)!))
    }

    var body: some View {
         VStack {
             ScrollView {
                 LazyVStack(alignment: .leading, spacing: 10) {
                     ForEach(messages) { message in
                         ForEach(messages) { message in
                             HStack {
                                 if message.isSentByCurrentUser {
                                     Spacer()
                                 }

                                 if !message.isSentByCurrentUser {
                                     if let botImage = message.botImage {
                                         botImage
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 40, height: 40)
                                             .clipShape(Circle())
                                     }
                                 }

                                 Text(message.text)
                                     .padding(10)
                                     .background(message.isSentByCurrentUser ? Color("app_color") : Color.gray)
                                     .foregroundColor(.white)
                                     .cornerRadius(10)
                                     .frame(maxWidth: .infinity, alignment: message.isSentByCurrentUser ? .trailing : .leading)

                                 if message.isSentByCurrentUser {
                                     if let userImageUrl = message.userImageUrl {
                                         URLImage(url: userImageUrl)
                                             .frame(width: 40, height: 40)
                                             .clipShape(Circle())
                                     }
                                 }

                                 if !message.isSentByCurrentUser {
                                     Spacer()
                                 }
                             }
                         }

                     }

                 }
             }
             .padding()

         
            HStack {
                TextField("Type a message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                if chatBotViewModel.isLoading {
                       TypingAnimationView()
                   }
                else{
                    
                    Button(action: sendMessage) {
                        
                        Image(systemName: "paperplane.fill")  // replace "paperplane.fill" with your desired icon
                            .resizable()
                            .frame(width: 20, height: 20) // adjust the size as needed
                            .padding()
                            .background(Color("app_color"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                  
                    } .padding(.trailing)
                }
             

               
            }
        }
    }

    func sendMessage() {

        guard !newMessageText.isEmpty else { return }

        isLoading = chatBotViewModel.isLoading
     
        let userMessage = Message(text: newMessageText, isSentByCurrentUser: true, userImageUrl: userProfileImageUrl, botImage: Image("app_logo_48"))

        print("Using profile picture URL: \(userProfileImageUrl)")
               messages.append(userMessage)
        messages.append(userMessage)
let req = ChatBotReq(message: newMessageText)

      
        chatBotViewModel.chatBot(message: req) { result in
            switch result {
            case .success(let response):
                print("response is \(response)")
                let botMessage = Message(text: response, isSentByCurrentUser: false, userImageUrl: nil, botImage: Image("app_logo_48"))
                messages.append(botMessage)
            case .failure(let error):
                print("Chatbot error: \(error)")
                // Handle error case if needed
            }
        }
        newMessageText = ""

    }
}



class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    deinit {
        cancellable?.cancel()
    }

    func load(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct URLImage: View {
    @ObservedObject private var loader: ImageLoader

    init(url: URL) {
        loader = ImageLoader()
        loader.load(from: url)
    }

    var body: some View {
        Image(uiImage: loader.image ?? UIImage())
            .resizable()
    }
}
struct TypingAnimationView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.gray)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) / 5))
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}
