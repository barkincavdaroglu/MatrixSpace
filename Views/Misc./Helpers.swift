//
//  Helpers.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/5/20.
//

import Foundation
import Combine
//import UIKit
import SwiftUI

enum MatrixError: Error {
    case matrixNotFull
}

extension MatrixError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .matrixNotFull:
            return NSLocalizedString("Seems like you either entered a non-numeric character into the matrix or didn't fill it up. ", comment: "")
        }
    }
}

enum ResultError: Error {
    case failedToCompleteSVD
    case failedToCompleteEigens
}

extension ResultError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToCompleteSVD:
            return NSLocalizedString("For some reason we were unable to compute the SVD of this matrix.", comment: "")
        case .failedToCompleteEigens:
            return NSLocalizedString("For some reason we were unable to compute the eigens of this matrix.", comment: "")
        }
    }
}

enum WorkspaceError: Error {
    case incompatibleOperation
    case LinearSystemOfEquationsIncorrectInput
    case MatrixIndexError
    case MatrixTooLarge
}

extension WorkspaceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incompatibleOperation:
            return NSLocalizedString("Seems like you have multiple matrices in your workspace. Make sure there is only one for this operation.", comment: "")
        case .LinearSystemOfEquationsIncorrectInput:
            return NSLocalizedString("The second matrix needs to have the same number of rows as the first matrix and 1 column to solve the system of linear equations.", comment: "")
        case .MatrixIndexError:
            return NSLocalizedString("Are you sure you have that many matrices in your workspace? Make sure to not enter an index number greater or lesser than the number of matrices you have.", comment: "")
        case .MatrixTooLarge:
            return NSLocalizedString("Unfortunately we currently cannot support matrices larger than 10x10 due to screensize and layout. But we are working to make that possible.", comment: "")
        }
        
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}



struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

//MARK: - HIDE KEYBOARD
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
