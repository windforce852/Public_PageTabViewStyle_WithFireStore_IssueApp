//
//  SignInWithAppleView.swift
//  Public_PageTabViewStyle_WithFireStore_Issue
//
//  Created by Kwan Ho Leung on 29/1/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import CryptoKit
import AuthenticationServices

struct SignInWithAppleView: View {
    
    @State var currentNonce: String? //keep track of Nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                let nonce = randomNonceString() //gen random srring - nonce
                currentNonce = nonce //assign nonce as @state var
                request.requestedScopes = [.fullName, .email] //request name and email
                request.nonce = sha256(nonce) //encrypt nonce
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        
                        guard let nonce = currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        //MARK: SIGN IN
                        let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                        Auth.auth().currentUser?.link(with: credential, completion: { (authResult, error) in
                            if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue{
                                print("This Apple acc has already been linked")
                                if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential{
                                    print("Sign in with updated credential")
                                    Auth.auth().signIn(with: updatedCredential) { (authResult, error) in
                                        if let error = error {
                                            print(error)
                                        }
                                    }
                                }
                            }
//                            if (error != nil) {
//                                print(error?.localizedDescription as Any)
//                                return
//                            }
                            print("signed in")
                        })
                        
                        print("\(String(describing: Auth.auth().currentUser?.uid))")
                    default:
                        break
                        
                    }
                default:
                    break
                }
            }
        )
            .frame(width: 280, height: 45, alignment: .center)
            //.padding(.init(top: 400, leading: 50, bottom: 20, trailing: 50))
    }
}

struct SignInWithAppleView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleView()
    }
}
