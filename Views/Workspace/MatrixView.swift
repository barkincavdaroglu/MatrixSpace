//
//  MatrixView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct MatrixView: View {
    @EnvironmentObject var matrixVM: MatrixVM
    var id: Int
    var textFieldWidth: CGFloat?
    var resultingMatrix: [[String]]
    
    var body: some View {
        VStack {
            if matrixVM.matricesValues.count > id && matrixVM.keyboardTracker.count == matrixVM.matricesValues.count {
                
                VStack {
                    ForEach(0..<matrixVM.matricesValues[id].count, id:\.self) { index in
                        HStack {
                            ForEach(0..<matrixVM.matricesValues[id][0].count, id:\.self) {i2 in
                                TextField("", text: Binding(
                                    get: { if matrixVM.matricesValues.count > 0 && matrixVM.matricesValues.count > id  {
                                        return String(matrixVM.matricesValues[id][index][i2])
                                    } else {
                                        return ""
                                    }},
                                    set: { (newValue) in return self.matrixVM.addValueToMatrix(row: index, column: i2, value: newValue, idx: id) }
                                ))
                                .foregroundColor(Color("textfield_text"))
                                .font(.system(size: 18))
                                .frame(width: textFieldWidth ?? 70)
                                .background(Color("textfield_bg"))
                                .cornerRadius(4)
                                
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4).stroke(( matrixVM.keyboardTracker[id][index][i2] == false ? Color("incorrectInput") : Color("textfield_bg") ), lineWidth: 1.5) 
                                )
                                
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
       
    }
}
