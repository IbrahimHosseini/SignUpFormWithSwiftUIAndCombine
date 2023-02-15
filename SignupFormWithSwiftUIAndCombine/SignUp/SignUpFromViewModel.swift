//
//  SignUpFromViewModel.swift
//  SignupFormWithSwiftUIAndCombine
//
//  Created by Ibrahim Hosseini on 2/16/23.
//

import Combine

class SignUpFromViewModel: ObservableObject {
    // Input
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation = ""

    // output
    @Published var usernameMessage: String = ""
    @Published var passwordMessage = ""
    @Published var isValid: Bool = false


    // Use the 'lazy' keyword to prevent call property more than once and increase memory
    private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
        $username
            .map { $0.count >= 8 }
            .eraseToAnyPublisher()
    }()

    private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
        $password
            .map (\.isEmpty)
            .eraseToAnyPublisher()
    }()

    private lazy var isPasswordMatch: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .map(==)
            .eraseToAnyPublisher()
    }()

    private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatch)
            .map { !$0 && $1 }
            .eraseToAnyPublisher()
    }()

    private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isPasswordValidPublisher, isUsernameLengthValidPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }()

    init() {

        isUsernameLengthValidPublisher
            .map {
                $0 ? ""
                : "Username too short, Needs at least to be 8 characters."
            }
            .assign(to: &$usernameMessage)


        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatch)
            .map { isPasswordEmpty, isPasswordMatching in
                if isPasswordEmpty {
                    return "Password must not be empty."
                } else if !isPasswordMatching {
                    return "Password do not match!"
                }
                return ""
            }
            .assign(to: &$passwordMessage)

        isFormValidPublisher
            .assign(to: &$isValid)
        
    }
}

