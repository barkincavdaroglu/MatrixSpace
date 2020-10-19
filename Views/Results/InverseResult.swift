//
//  InverseResult.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/11/20.
//

import SwiftUI

struct InverseResultView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @State var saved = false
    @State var tapped = 0
    
    var body: some View {
        VStack {
            HStack {
                Image("inverse_icon")
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                Spacer()
                // SAVE BUTTON
                Button(action: {
                    self.tapped += 1
                    if tapped <= 1 {
                        self.tap = true
                        self.saved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.tap = false
                        }
                        
                        
                        let workspace = Workspace(context: self.managedObjectContext)
                        matrixVM.composeInverse()
                        workspace.id = UUID()
                        workspace.matrix = matrixVM.inverseComposition
                        workspace.result = matrixVM.result
                        workspace.date = Date()
                        workspace.operation = matrixVM.operation
                        
                        try? self.managedObjectContext.save()
                    }
                    
                }, label: {
                    Image(systemName: !saved ? "folder.badge.plus" : "checkmark")
                        
                        .font(Font.headline.weight( !saved ? .semibold : .bold))
                        .foregroundColor(Color( !saved ? "badge_text" : "Tick"))
                        .padding(.all, !saved ? 7 : 10)
                        .padding(.vertical, !saved ? 3 : 0)
                        .background(Color("badge_bg"))
                        .cornerRadius(50)
                        .padding(.trailing, 20)
                })
                .scaleEffect(tap ? 1.5 : 1)
                .shadow(color: tap ? Color("blurredBG").opacity(0.8) : Color("blurredBG").opacity(0), radius: 8, x: 0, y: 10)
            }
            HStack {
                Text("Inverse")
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("text"))
                Spacer()
                
            }
            .padding(.bottom, 12)
            .padding(.leading, 20)
            
        }
    }
}
