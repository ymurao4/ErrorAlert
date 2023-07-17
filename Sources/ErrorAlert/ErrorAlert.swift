// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

@available(iOS 15.0, *)
public enum ErrorType {
    case defaultError(viewData: DefaultErrorViewData)
    case multipleButtonError(viewData: MultipleButtonErrorViewData)
    
    public struct DefaultErrorViewData {
        public let title: String
        public let message: String
        public let buttonText: String
        public let handler: (() -> Void)?
        
        public init(
            title: String = "エラー",
            message: String = "",
            buttonText: String = "OK",
            handler: ( () -> Void)? = nil
        ) {
            self.title = title
            self.message = message
            self.buttonText = buttonText
            self.handler = handler
        }
    }
    
    public struct MultipleButtonErrorViewData {
        public let title: String
        public let message: String
        public let primaryButtonText: String
        public let secondaryButtonText: String
        public let primaryButtonHandler: (() -> Void)?
        public let secondaryButtonHandler: (() -> Void)?
        
        public init(
            title: String = "エラー",
            message: String = "",
            primaryButtonText: String = "OK",
            secondaryButtonText: String = "キャンセル",
            primaryButtonHandler: ( () -> Void)? = nil,
            secondaryButtonHandler: ( () -> Void)? = nil
        ) {
            self.title = title
            self.message = message
            self.primaryButtonText = primaryButtonText
            self.secondaryButtonText = secondaryButtonText
            self.primaryButtonHandler = primaryButtonHandler
            self.secondaryButtonHandler = secondaryButtonHandler
        }
        
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
