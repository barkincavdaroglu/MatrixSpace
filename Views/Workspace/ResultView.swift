//
//  ResultView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    @Binding var showEigenVectors: Bool
    
    var body: some View {
        
        if matrixVM.showOp {
            VStack(alignment: .leading) {
                HStack {
                    if matrixVM.operation == "Eigenvalues" {
                        
                        EigensResultView(showEigenVectors: $showEigenVectors)
                       
                    }
                    else if matrixVM.operation == "Determinant" {
                        DeterminantResultView()
                    }
                    else if matrixVM.operation == "Linear Equations" {
                        LEQResultView()
                    }
                    else if matrixVM.operation == "SVD" {
                        SVDCard()
                    }
                    else if matrixVM.operation == "Invert" {
                        InverseResultView()
                    }
                }
            }
            .transition(.move(edge: .top))
            .frame(width: UIScreen.main.bounds.size.width-25)
            
            .padding(.vertical, 10)
            .padding(.top, 5)
            
            .background(Color(showEigenVectors ? "blurredBG" : "card_background"))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke((showEigenVectors ? Color("card_background") : Color("card_background")), lineWidth: 0.5)
            )
            .shadow(color: Color("CardShadow"), radius:20, x:0, y:25)
        }
    }
}











