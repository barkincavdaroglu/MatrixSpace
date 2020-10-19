//
//  Buttons.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/4/20.
//

import SwiftUI

struct Buttons: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @Binding var showExponentCard: Bool
    @Binding var errorMessage: Error?
    @Binding var showDimensionCard: Bool
    @Binding var collapse: Bool
    
    @State var collapseUpDown = "chevron.down"
    @State var tap = false
    
    var body: some View {
        VStack {
        if collapse {
            VStack {

                
                HStack {
                    //ADD MATRIX BUTTON
                    AddMatrixButton(showDimensionCard: $showDimensionCard)
                        
                    Spacer()
                    //DELETE MATRIX
                    DeleteButton()
                    
                    Spacer()
                    
                    CollapseButton(collapse: $collapse)
                }
                
                // BUTTON ROW 1
                HStack {
                    Group {
                        // Diagonal Button
                        DiagonalButton(errorMessage: $errorMessage)
                        
                    }
                    
                    Group {
                        Spacer()
                        //linear equations button
                        LEQButton(errorMessage: $errorMessage, collapse: $collapse)
                    }
                    
                    Group {
                        Spacer()
                        //DETERMINANT BUTTON
                        DeterminantButton(errorMessage: $errorMessage, collapse: $collapse)
                    }
                    
                    Group {
                        Spacer()
                        //CLEAR BUTTON
                        ClearButton(errorMessage: $errorMessage, showDimensionCard: $showDimensionCard)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width-50)
                .padding(.top, 5)
                
                
                // BUTTON ROW 2
                HStack {
                    Group {
                        //EIGENVALUES BUTTON
                        EigenButton(errorMessage: $errorMessage, collapse: $collapse)
                    }
                
                    //INVERT
                    Group {
                        Spacer()
                        // Invert Button
                        InvertButton(errorMessage: $errorMessage, collapse: $collapse)
                    }
                    
                    //MULTIPLY
                    Group {
                        Spacer()
                        // Multiply Button
                        MultiplyButton(errorMessage: $errorMessage)
                    }
                    
                    //EXP
                    Group {
                        Spacer()
                        // Exp Button
                        ExpButton(errorMessage: $errorMessage, showExponentCard: $showExponentCard)
                    }
                    
                    //SVD
                    Group {
                        Spacer()
                        // SVD Button
                        SVDButton(errorMessage: $errorMessage, collapse: $collapse)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width-50)
                .padding(.top, 5)
                
            }
            .padding(.all, 15)
            .frame(width: UIScreen.main.bounds.width-25)
            .background(Color("card_background"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.top, 5)
        } else {
            HStack {
                Spacer()
                //ADD MATRIX BUTTON
                AddMatrixButton(showDimensionCard: $showDimensionCard)
                Spacer()
                
                //DELETE MATRIX
                DeleteButton()
                Spacer()
                
                CollapseButton(collapse: $collapse)
                Spacer()
            }
            .padding(.all, 15)
            .frame(width: UIScreen.main.bounds.width-25)
            .background(Color("card_background"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.top, 5)
        }
        }
        
    }
}

struct AddMatrixButton: View {
    @State var tap = false
    @Binding var showDimensionCard: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            showDimensionCard.toggle()
            
        }, label: {
            Text("Add Matrix")
                
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
            
        })
        .frame(width: (UIScreen.main.bounds.width - 80 - (UIScreen.main.bounds.width - 80)/4)/2, height: 40, alignment: .center)
        .background(Color(tap ? "darker_button" : "darker_button"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 16, x: 0, y: 10)
    }
}

struct DeleteButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            
            matrixVM.deleteMatrix(idx: matrixVM.matricesValues.endIndex - 1)
            
        }, label: {
            Text("Delete")
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80 - (UIScreen.main.bounds.width - 80)/4)/2, height: 40, alignment: .center)
        .background(Color(tap ? "darker_button2" : "darker_button"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 16, x: 0, y: 10)
    }
}

struct CollapseButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var collapse: Bool
    @State var collapseUpDown = "chevron.up"
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            
            self.collapse.toggle()
        }, label: {
            Image(systemName: collapseUpDown)
                .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40)
                .foregroundColor(Color("text"))
                .rotationEffect(.degrees(collapse ? 180 : 0))
                .animation(.easeInOut)
            
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40, alignment: .center)
        .background(Color(tap ? "darker_button2" : "darker_button"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct DiagonalButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            if matrixVM.dimensions.count > 1 {
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
            
            } else if matrixVM.dimensions.count == 1 {
                do {
                    try matrixVM.diagonalizeSelf()
                } catch {
                    errorMessage = error
                }
                self.hideKeyboard()
            }
            
        }, label: {
            Text("Diag")
                .font(.system(size: 16, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct LEQButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var collapse: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            if matrixVM.matricesValues.count == 2 || matrixVM.matricesForCalc.count == 2 {
                do {
                    try matrixVM.solVector()
                    do {
                        if matrixVM.matricesValues[0].count > 6 {
                            collapse = false
                        }
                        try matrixVM.solveLEQ()
                    } catch {
                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                        errorMessage = error
                    }
                    
                } catch {
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                    errorMessage = error
                    self.hideKeyboard()
                }
            }
        }, label: {
            Text("Ax = b")
                .font(.system(size: 16, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct DeterminantButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var collapse: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            
            if matrixVM.dimensions.count > 1 {
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
            
            } else if matrixVM.dimensions.count == 1 {
                do {
                    if matrixVM.matricesValues[0].count > 6 {
                        collapse = false
                    }
                    try matrixVM.getDeterminant()
                } catch {
                    errorMessage = error
                }
            }
            self.hideKeyboard()
        }, label: {
            Text("det(A)")
                .font(.system(size: 16, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct ClearButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var showDimensionCard: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            showDimensionCard = false
            matrixVM.clear()
        }, label: {
            Text("Clear")
                .font(.system(size: 16, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/4, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct EigenButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var collapse: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            
            if matrixVM.dimensions.count > 1 {
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
                
            } else if matrixVM.dimensions.count == 1 {
                if matrixVM.matricesValues[0].count > 6 {
                    collapse = false
                }
                do {
                    try matrixVM.getEigenvalues()
                } catch {
                    errorMessage = error
                }
                self.hideKeyboard()
            }
        }, label: {
            Text("\u{1D740}")
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/5, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct InvertButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var collapse: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            
            if matrixVM.dimensions.count > 1 {
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
            
            } else if matrixVM.dimensions.count == 1 {
                if matrixVM.matricesValues[0].count > 6 {
                    collapse = false
                }
                do {
                    try matrixVM.invertSelf()
                } catch {
                    errorMessage = error
                }
            }
        }, label: {
            Group {
                Text("A").font(.system(size: 20, design: .rounded)).fontWeight(.medium) + Text("-1")
                    .font(.system(size: 10, design: .rounded)).fontWeight(.medium)
                    .baselineOffset(10.0)
            }
            .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/5, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct MultiplyButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            do {
                try matrixVM.multiply()
            } catch {
                errorMessage = error
            }
        }, label: {
            Text("x")
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/5, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}

struct ExpButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var showExponentCard: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            if matrixVM.dimensions.count > 1 {
                
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
            } else if matrixVM.dimensions.count == 1 && matrixVM.isMatrixFull {
                if matrixVM.matricesValues[0].count == matrixVM.matricesValues[0][0].count {
                    self.showExponentCard = true
                } else {
                    errorMessage = InputMatrixError.notSquare
                }
            }
            
        }, label: {
            Group {
                Text("A").font(.system(size: 20, design: .rounded)).fontWeight(.medium) + Text("x")
                    .font(.system(size: 10, design: .rounded)).fontWeight(.medium)
                    .baselineOffset(10.0)
            }
            .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/5, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}


struct SVDButton: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @Binding var errorMessage: Error?
    @Binding var collapse: Bool
    
    var body: some View {
        Button(action: {
            self.tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.tap = false
            }
            if matrixVM.dimensions.count > 1 {
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
                errorMessage = WorkspaceError.incompatibleOperation
                self.hideKeyboard()
            } else if matrixVM.dimensions.count == 1 {
                do {
                    try matrixVM.svd()
                } catch {
                    errorMessage = error
                }
                self.hideKeyboard()
            }
            
        }, label: {
            Text("SVD")
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color("text"))
        })
        .frame(width: (UIScreen.main.bounds.width - 80)/5, height: 40, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("outline"), lineWidth: 2)
        )
        .background(Color(tap ? "outline" : "card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(tap ? 1.15 : 1)
        .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
    }
}
