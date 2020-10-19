//
//  Exp.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/9/20.
//

import SwiftUI

struct ExpResultView: View {
    @EnvironmentObject var matrixVM: MatrixVM
    
    var body: some View {
        if matrixVM.showResult {
        HStack {
            
                Text("= ")
                VStack(spacing: 7) {
                    ForEach(0..<matrixVM.resultingMatrix.count, id:\.self) { index1 in
                        HStack {
                            ForEach(0..<matrixVM.resultingMatrix[0].count, id:\.self) { index2 in
                                Text("\(matrixVM.resultingMatrix[index1][index2])")
                                    .foregroundColor(Color("textfield_text"))
                                    
                                    .frame(width: 90, height: 23)
                                    .background(Color("textfield_bg"))
                                    .cornerRadius(4)
                            }
                            
                        }
                    }
                    
                }
                .padding(.horizontal, 15)
            
        }
        .padding(.bottom, 10)
        }
    }
}
