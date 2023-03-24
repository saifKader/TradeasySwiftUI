//
//  otptest.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 24/3/2023.
//

/*import SwiftUI

struct otptest: View {
    //view properties
    @State var otpText: String = ""
    //keyboard state
    @FocusState private var isKeyBoardShowing: Bool
    var body: some View {
        VStack{
            Text("Verify OTP")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
            HStack(spacing: 0){
                ForEach(0..<6,id: \.self){index in
                    OTPTextBox(index)
                }
            }
            .background(content:{
                TextField("", text: $otpText.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                //hiding it out
                    .frame(width: 1,height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyBoardShowing)
            })
            .contentShape(Rectangle())
            //opening keyboard when tap
            .onTapGesture {
                isKeyBoardShowing.toggle()
            }
            .padding(.bottom,20)
            .padding(.top,10)
            Button { 
                
            }label:{
                Text("verify")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius:6 ,style: .continuous)
                            .fill(.blue)
                    }
                
                
            }
            .disableWithOpacity(otpText.count < 6 )
            	
        }
        .padding(.all)
        .frame(maxHeight: .infinity,alignment: .top)
    }
    //otp tex box builder
    @ViewBuilder
    func OTPTextBox(_ index: Int)->some View{
        ZStack{
            if otpText.count > index {
                //char on index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                
            }else{
                Text(" ")
            }
        }
        .frame(width: 45,height: 45)
        .background{
            RoundedRectangle(cornerRadius: 6,style: .continuous)
                .stroke(.gray,lineWidth: 0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

struct otptest_Previews: PreviewProvider {
    static var previews: some View {
        otptest()
    }
}

//view extensions

extension View{
    func disableWithOpacity(_ condition:Bool)->some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
}

//binding string extension
extension Binding where Value == String{
    func limit(_ length: Int)-> Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}*/


/*import SwiftUI
 
 struct OTPVerificationView: View {
     @StateObject var viewModel = ForgetPasswordViewModel()
     @State private var otpText: String = ""
     @FocusState private var isKeyBoardShowing: Bool
     let email: String
     @EnvironmentObject var navigationController: NavigationController
     @State private var showError = false
     @State private var errorMessage = ""
     
     @State private var otpVerified = false
     
     var body: some View {
         NavigationView {
             VStack(spacing: 30) {
                 Text("Verify OTP")
                     .font(.largeTitle)
                 
                 Text("Enter the 6-digit OTP sent to your email")
                     .font(.headline)
                     .multilineTextAlignment(.center)
                     .padding(.horizontal)
                 
                 HStack(spacing: 0) {
                     ForEach(0..<6, id: \.self) { index in
                         OTPTextBox(index)
                     }
                 }
                 .background(content: {
                     TextField("", text: $otpText.limit(6))
                         .keyboardType(.numberPad)
                         .textContentType(.oneTimeCode)
                         .frame(width: 1, height: 1)
                         .opacity(0.001)
                         .blendMode(.screen)
                         .focused($isKeyBoardShowing)
                 })
                 .contentShape(Rectangle())
                 .onTapGesture {
                     isKeyBoardShowing.toggle()
                 }
                 .padding(.bottom, 20)
                 .padding(.top, 10)
                 
                 Button {
                     verifyOTP()
                 } label: {
                     Text("Verify")
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                         .padding(.vertical, 12)
                         .frame(maxWidth: .infinity)
                         .background {
                             RoundedRectangle(cornerRadius: 6, style: .continuous)
                                 .fill(.blue)
                         }
                 }
                 .disableWithOpacity(otpText.count < 6)
             }
             .padding()
             .frame(maxHeight: .infinity, alignment: .top)
             .alert(isPresented: $showError) {
                 Alert(title: Text("Error"), message: Text(errorMessage))
             }
             .background(
                 NavigationLink(
                     destination: ResetPasswordView(email: email, otp: otpText),
                     isActive: $otpVerified,
                     label: { EmptyView() }
                 )
             )
         }
     }
     
     private func verifyOTP() {
         viewModel.verifyOtp(email: email, otp: otpText) { result in
             switch result {
             case .success:
                 viewModel.state = .success
                 otpText = ""
                 otpVerified = true
             case .failure(let error):
                 if case let UseCaseError.error(message) = error {
                     errorMessage = message
                     showError = true
                 } else {
                     print("Error verifying OTP: \(error)")
                 }
             }
         }
     }
     
     @ViewBuilder
     func OTPTextBox(_ index: Int)->some View{
         ZStack{
             if otpText.count > index {
                 //char on index
                 let startIndex = otpText.startIndex
                 let charIndex = otpText.index(startIndex, offsetBy: index)
                 let charToString = String(otpText[charIndex])
                 Text(charToString)
                 
             }else{
                 Text(" ")
             }
         }
         .frame(width: 45,height: 45)
         .background{
             RoundedRectangle(cornerRadius: 6,style: .continuous)
                 .stroke(.gray,lineWidth: 0.5)
         }
         .frame(maxWidth: .infinity)
     }
 }
 struct otpview: PreviewProvider {
     static var previews: some View {
         OTPVerificationView(email: "")
     }
 }

 extension View{
     func disableWithOpacity(_ condition:Bool)->some View {
         self
             .disabled(condition)
             .opacity(condition ? 0.6 : 1)
     }
     
 }

 //binding string extension
 extension Binding where Value == String{
     func limit(_ length: Int)-> Self{
         if self.wrappedValue.count > length{
             DispatchQueue.main.async {
                 self.wrappedValue = String(self.wrappedValue.prefix(length))
             }
         }
         return self
     }
 }
*/
