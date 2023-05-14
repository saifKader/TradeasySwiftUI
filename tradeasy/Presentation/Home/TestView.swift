
import SwiftUI
import ToastSwiftUI

struct TestView: View {
    @State private var errorMessage: String? = nil
    @State private var responseMessage: String? = nil
    let userApi = UserAPI()
    let message = ChatBotReq(message: "hello")
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Chat") {
                Task {
                    do {
                        let response = try await userApi.chatBot(message)
                        self.responseMessage = response
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            Text(errorMessage ?? "")
                .foregroundColor(.red)
            Text(responseMessage ?? "")
        }
    }
}
