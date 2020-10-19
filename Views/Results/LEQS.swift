//
//  LEQS.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/9/20.
//

import SwiftUI

struct LEQResultView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    @State var tap = false
    @State var saved = false
    @State var tapped = 0
    
    var body: some View {
        VStack {
            HStack {
                Image("lineq_icon")
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                Spacer()
                Button(action: {
                    self.tapped += 1
                    if tapped <= 1 {
                        self.tap = true
                        self.saved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.tap = false
                        }
                        
                        matrixVM.composeLEQSForNotebookView()
                        let workspace = Workspace(context: self.managedObjectContext)
                        
                        workspace.id = UUID()
                        workspace.matrix = matrixVM.LEQSResult
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
                .scaleEffect(tap ? 1.2 : 1)
                .shadow(color:  Color( tap ? "CardShadow" : "card_background"), radius: 12, x: 0, y: 12)
            }
            HStack {
                Text("Linear Equations")
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("text"))
                Spacer()
                
            }
            .padding(.bottom, 12)
            .padding(.leading, 20)
            
            VStack {
                if matrixVM.linEqSolver.count <= 3 {
                    HStack {
                        ForEach(0..<matrixVM.linEqSolver.count, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                else if matrixVM.linEqSolver.count <= 6 {
                    HStack {
                        ForEach(0..<3, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    HStack {
                        ForEach(3..<matrixVM.linEqSolver.count, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                else if matrixVM.linEqSolver.count <= 9 {
                    HStack {
                        ForEach(0..<3, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    HStack {
                        ForEach(3..<6, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    HStack {
                        ForEach(3..<matrixVM.linEqSolver.count, id:\.self) { i in
                            HStack {
                                Text("x").font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(matrixVM.linEqSolver[i].prefix(5)))")
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                
            }
        }
    }
}
