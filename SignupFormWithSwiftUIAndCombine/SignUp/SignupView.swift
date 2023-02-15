//
//  SignupView.swift
//  SignupFormWithSwiftUIAndCombine
//
//  Created by Ibrahim Hosseini on 2/16/23.
//

import SwiftUI

struct SignupView: View {
    @StateObject var viewModel = SignUpFromViewModel()

    var body: some View {

        Form {
            // username
            Section {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundColor(.red)
            }

            // password
            Section {
                SecureField("Password", text: $viewModel.password)
                SecureField("Password Confirmation", text: $viewModel.passwordConfirmation)
            } footer: {
                Text(viewModel.passwordMessage)
                    .foregroundColor(.red)
            }

            // submit button
            Section {
                Button("Sign Up") {
                    print("Sign up as \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

