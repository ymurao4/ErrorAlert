// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

@available(iOS 15.0, *)
public enum ErrorType {
    case defaultError(viewData: DefaultErrorViewData)
    case multipleButtonError(viewData: MultipleButtonErrorViewData)
    
    public struct DefaultErrorViewData {
        let title: String
        let message: String
        let buttonText: String
        let handler: (() -> Void)?
    }
    
    public struct MultipleButtonErrorViewData {
        let title: String
        let message: String
        let primaryButtonText: String
        let secondaryButtonText: String
        let primaryButtonHandler: (() -> Void)?
        let secondaryButtonHandler: (() -> Void)?
    }
}

@available(iOS 15.0, *)
public struct ErrorAlertModifier: ViewModifier {
    @Binding var errorType: ErrorType?
    
    var isPresentedDefaultError: Binding<Bool> {
        Binding<Bool>(
            get: { errorType?.isDefaultError ?? false },
            set: {
                if !$0 {
                    errorType = nil
                }
            }
        )
    }
    
    var isPresentedMultopleButtonError: Binding<Bool> {
        Binding<Bool>(
            get: { errorType?.isMultipleButtonError ?? false },
            set: {
                if !$0 {
                    errorType = nil
                }
            }
        )
    }
    
    var isPresented: Binding<Bool> {
         Binding<Bool>(
             get: { errorType != nil },
             set: {
                 if !$0 {
                     errorType = nil
                 }
             }
         )
     }
    
    public func body(content: Content) -> some View {
        content
            .alert(
                defaultErrorViewData?.title ?? "エラー",
                isPresented: isPresentedDefaultError
            ) {
                Button(defaultErrorViewData?.buttonText ?? "OK") {
                    defaultErrorViewData?.handler?()
                    errorType = nil
                }
            } message: {
                Text(defaultErrorViewData?.message ?? "")
            }
            .alert(
                multipleButtonErrorViewData?.title ?? "エラー",
                isPresented: isPresentedMultopleButtonError
            ) {
                Button(multipleButtonErrorViewData?.secondaryButtonText ?? "キャンセル") {
                    multipleButtonErrorViewData?.secondaryButtonHandler?()
                    errorType = nil
                }
                Button(multipleButtonErrorViewData?.primaryButtonText ?? "OK") {
                    multipleButtonErrorViewData?.primaryButtonHandler?()
                    errorType = nil
                }
            } message: {
                Text(multipleButtonErrorViewData?.message ?? "")
            }
    }
}

@available(iOS 15.0, *)
public extension ErrorType {
    var isDefaultError: Bool {
        switch self {
        case .defaultError:
            return true
        default:
            return false
        }
    }
    
    var isMultipleButtonError: Bool {
        switch self {
        case .multipleButtonError:
            return true
        default:
            return false
        }
    }
}

@available(iOS 15.0, *)
public extension ErrorAlertModifier {
    var defaultErrorViewData: ErrorType.DefaultErrorViewData? {
        switch errorType {
        case .defaultError(let viewData):
            return viewData
        default:
            return nil
        }
    }
    
    var multipleButtonErrorViewData: ErrorType.MultipleButtonErrorViewData? {
        switch errorType {
        case .multipleButtonError(let viewData):
            return viewData
        default:
            return nil
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    func errorAlert(errorType: Binding<ErrorType?>) -> some View {
        self.modifier(ErrorAlertModifier(errorType: errorType))
    }
}
