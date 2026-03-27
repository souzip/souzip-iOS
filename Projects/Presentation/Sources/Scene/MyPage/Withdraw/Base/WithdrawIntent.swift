import Foundation

enum WithdrawAction {
    case tapContinue
    case tapWithdraw
}

struct WithdrawState {
    var isLoading: Bool = false
}

enum WithdrawEvent {}
