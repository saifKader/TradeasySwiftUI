
import SwiftUI
import ToastSwiftUI

struct NavObj: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct TestView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack() {
            VStack {
                NavigationLink(destination: T0121(test: 1), label: {Text("Click")})

            }
            .navigationDestination(for: NavObj.self) { item in
                T0121(test: 2)
            }
        }
    }
}

struct T0121: View{
    @State var test: Int
    var body: some View{
        VStack{
            Text(String(test))
            NavigationLink(value: NavObj.init(name: "Next"), label: {Text("Click")})
        }
    }
}
