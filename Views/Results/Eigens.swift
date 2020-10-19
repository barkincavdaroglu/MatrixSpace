//
//  Eigens.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/9/20.
//

import SwiftUI

struct EigensResultView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    
    @Binding var showEigenVectors: Bool
    @State var collapseUpDown = "chevron.down"
    @State var tap = false
    @State var saved = false
    @State var tapped = 0
        
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("eigen_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                    Spacer()
                    
                    //SAVE BUTTON
                    Button(action: {
                        self.tapped += 1
                        if tapped <= 1 {
                            self.tap = true
                            self.saved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.tap = false
                            }
                            
                            let workspace = Workspace(context: self.managedObjectContext)
                            
                            workspace.id = UUID()
                            workspace.matrix = matrixVM.matricesValues[0]
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
                    Text("Eigenvalues")
                        .font(.system(size: 18, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color("text"))
                    Spacer()
                }
                .padding(.bottom, 12)
                .padding(.leading, 20)
                
                VStack {
                    if matrixVM.eigenvals.count <= 3 {
                        HStack {
                            ForEach(0..<matrixVM.eigenvals.count, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-6.0)
                                    Text(": \(String(matrixVM.eigenvals[i]))")
                                        .font(.system(size: 13, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text"))
                                }
                                .frame(height: 20)
                            }
                            Spacer()
                        }
                        
                    }
                    else if matrixVM.eigenvals.count <= 6 && matrixVM.eigenvals.count >= 3 {
                        VStack {
                            HStack {
                                ForEach(0..<3, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-6.0)
                                        Text(":\(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                Spacer()
                            }
                            HStack {
                                ForEach(3..<matrixVM.eigenvals.count, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-6.0)
                                        Text(":\(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                Spacer()
                            }
                            //.frame(height: 25)
                            
                        }
                    }
                    else if matrixVM.eigenvals.count <= 9 && matrixVM.eigenvals.count >= 6 {
                        VStack {
                            HStack {
                                ForEach(0..<3, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                Spacer()
                            }
                            HStack {
                                ForEach(3..<6, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                
                                Spacer()
                            }
                            HStack {
                                ForEach(6..<matrixVM.eigenvals.count, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    else if matrixVM.eigenvals.count == 10 {
                        VStack {
                            HStack {
                                ForEach(0..<3, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                Spacer()
                            }
                            HStack {
                                ForEach(3..<6, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                
                                Spacer()
                            }
                            HStack {
                                ForEach(6..<9, id:\.self) { i in
                                    HStack {
                                        Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                            .foregroundColor(Color("text"))
                                            .baselineOffset(-4.0)
                                        Text(": \(String(matrixVM.eigenvals[i]))")
                                            .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                    }
                                    .frame(height: 20)
                                }
                                
                                Spacer()
                            }
                            HStack {
                                Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white) + Text("\(10)").font(.system(size: 10, design: .rounded))
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-4.0)
                                Text(": \(String(matrixVM.eigenvals[9]))")
                                    .font(.system(size: 13, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                Spacer()
                            }
                            .frame(height: 20)
                            Spacer()
                        }
                    }
                }
                .padding(.leading, 20)
                
                VStack {
                    HStack {
                        Button(action: {
                            self.showEigenVectors.toggle()
                            self.collapseUpDown = (showEigenVectors ? "chevron.up" : "chevron.down")
                        }, label: {
                            Image(systemName: collapseUpDown)
                                .frame(width: 100, height: 20)
                                .foregroundColor(Color("text"))
                            
                        })
                    }
                    //.padding(.top, 5)
                    
                    
                    if showEigenVectors {
                        
                        HStack {
                            Text("Eigenvectors")
                                .font(.system(size: 18, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color("text"))
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        
                        if matrixVM.eigenvectors.count <= 3 {
                            HStack {
                                HStack {
                                    ForEach(0..<matrixVM.eigenvectors.count, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                        .font(.system(size: 14, design: .rounded))
                                                        .fontWeight(.medium)
                                                        .foregroundColor(Color("text"))
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        else if matrixVM.eigenvectors.count <= 6 && matrixVM.eigenvectors.count >= 3{
                            VStack {
                                HStack {
                                    ForEach(0..<2, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            
                                            VStack {
                                                
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 14, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                }
                                .padding(.bottom, 15)
                                
                                HStack {
                                    ForEach(2..<4, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 14, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                        //Spacer()
                                    }
                                    Spacer()
                                    
                                }
                                .padding(.bottom, 15)
                                
                                HStack {
                                    ForEach(4..<matrixVM.eigenvectors.count, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 14, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 15)
                                
                            }
                        }
                        else if matrixVM.eigenvectors.count <= 9 && matrixVM.eigenvectors.count >= 6 {
                            VStack {
                                HStack {
                                    ForEach(0..<3, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.bottom, 15)
                                HStack {
                                    ForEach(3..<6, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 15)
                                HStack {
                                    ForEach(6..<matrixVM.eigenvectors.count, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        else if matrixVM.eigenvectors.count == 10 {
                            VStack {
                                HStack {
                                    ForEach(0..<2, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    ForEach(2..<4, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    ForEach(4..<6, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                HStack {
                                    ForEach(6..<8, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 15)
                                
                                HStack {
                                    ForEach(8..<10, id: \.self) {vectorIndex in
                                        HStack {
                                            Text("\u{1D463}")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                + Text("\(vectorIndex+1):").font(.system(size: 10, design: .rounded))
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-4.0)
                                            VStack {
                                                ForEach(0..<matrixVM.eigenvectors[vectorIndex].count, id: \.self) { index1 in
                                                    HStack {
                                                        Text("\(matrixVM.eigenvectors[vectorIndex][index1])")
                                                            .font(.system(size: 13, design: .rounded))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(Color("text"))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                }
                .padding(.leading, 20)
                
            }
        }
        .frame(maxHeight: (showEigenVectors ? ((125 + (40 * CGFloat(matrixVM.eigenvals.count / 2))) + (100 * CGFloat(matrixVM.eigenvectors.count / 2))) : (110 + (28 * CGFloat(matrixVM.eigenvals.count / 2))) ))
    }
}

