//
//  MatrixKeyboard.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/4/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct MatrixKeyboardView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    @State var errorMessage: Error?
    @State var showExponentCard = false
    
    @Binding var isNavigationBarHidden: Bool
    
    @State var showDimensionCard = false
    @State var showEigenVectors = false
    
    @State var collapse = false
    @State var isFirstLoad = true
    @State var showSettings = false
    
    @ViewBuilder var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    //Notebooks link
                    HStack {
                        Image(systemName: "gear")
                            .foregroundColor(Color("text"))
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .onTapGesture {
                                self.showSettings = true
                            }
                            
                        Spacer()
                        NavigationLink(destination: NotebookView(isNavigationBarHidden: $isNavigationBarHidden), label: {
                            Text("Notebooks")
                                .font(.system(size: 16, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(Color("text"))
                                .padding(.trailing, 20)
                                .padding(.top, 10)
                        })
                    }
                    
                    
                    
                    if matrixVM.showOp {
                        
                        ResultView(showEigenVectors: $showEigenVectors)
                            
                            .animation(.default)
                            .zIndex(2)
                    }
                    
                    Spacer()
                    
                    if !showEigenVectors {
                        
                        if UIScreen.main.traitCollection.userInterfaceIdiom != .pad {
                        //MARK: -Matrices Input for more than 2
                            HStack {
                                if !matrixVM.noMatrixView {
                                    if matrixVM.matricesValues[0].count <= 5 && matrixVM.matricesValues.count == 1 && matrixVM.operation != "Multiplication" && matrixVM.operation != "SVD" && matrixVM.operation != "Invert" && matrixVM.operation != "Exp" && matrixVM.operation != "Diagonalization" {
                                    MatrixView(id: 0,textFieldWidth: 60, resultingMatrix: matrixVM.resultingMatrix)
                                        .padding(.bottom, 10)
                                        
                                        
                                       
                                    }
                                    else {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(alignment: .center) {
                                                ForEach(0..<matrixVM.matricesValues.count, id:\.self) { id in
                                                    VStack {
                                                        HStack {
                                                            MatrixView(id: id, textFieldWidth: 60, resultingMatrix: matrixVM.resultingMatrix)
                                                            
                                                        }
                                                        .padding(.bottom, 10)
                                                    }
                                                }
                                                if matrixVM.showResult {
                                                    
                                                    if matrixVM.operation == "SVD" {
                                                        SVDResultView()
                                                    }
                                                    else if matrixVM.operation == "Invert" || matrixVM.operation == "Exp" || matrixVM.operation == "Diagonalization" || matrixVM.operation == "Multiplication" {
                                                        ExpResultView()
                                                            .padding(.trailing, 20)
                                                    }
                                                   
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        } else if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                            HStack {
                                if !matrixVM.noMatrixView {
                                    if matrixVM.matricesValues.count == 1 && matrixVM.operation != "Multiplication" && matrixVM.operation != "SVD" && matrixVM.operation != "Invert" && matrixVM.operation != "Exp" && matrixVM.operation != "Diagonalization" {
                                    MatrixView(id: 0,textFieldWidth: 60, resultingMatrix: matrixVM.resultingMatrix)
                                        .padding(.bottom, 10)
                                        
                                        
                                       
                                    }
                                    else {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(alignment: .center) {
                                                ForEach(0..<matrixVM.matricesValues.count, id:\.self) { id in
                                                    VStack {
                                                        HStack {
                                                            MatrixView(id: id, textFieldWidth: 60, resultingMatrix: matrixVM.resultingMatrix)
                                                            
                                                        }
                                                        .padding(.bottom, 10)
                                                    }
                                                }
                                                if matrixVM.showResult {
                                                    
                                                    if matrixVM.operation == "SVD" {
                                                        SVDResultView()
                                                    }
                                                    else if matrixVM.operation == "Invert" || matrixVM.operation == "Exp" || matrixVM.operation == "Diagonalization" || matrixVM.operation == "Multiplication" {
                                                        ExpResultView()
                                                            .padding(.trailing, 20)
                                                    }
                                                   
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        if showDimensionCard {
                            DimensionCard(showDimensionCard: $showDimensionCard, errorMessage: $errorMessage)
                                .frame(width: 305)
                                .animation(.default)
                                
                        }
                        VStack {
                        //MARK: -Buttons
                        Buttons(showExponentCard: $showExponentCard, errorMessage: $errorMessage, showDimensionCard: $showDimensionCard, collapse: $collapse)
                            .padding(.bottom, 5)
                            .animation(isFirstLoad ? nil : .default)
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                    
                }
                .background(Image("emptybg")
                                .resizable()
                                .scaledToFit()
                )
                

                if showExponentCard {
                    ExponentCard(showExponentCard: $showExponentCard, errorMessage: $errorMessage)
                        .padding(.horizontal, 30)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .background(
                            Color.black.opacity(0.80)
                                .edgesIgnoringSafeArea(.all)
                            
                        )
                }
                if errorMessage != nil {
                    ErrorView(errorMessage: $errorMessage, width: geometry.size.width-125)
                        .padding(.horizontal, 30)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .background(
                            Color("background").opacity(0.95)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    self.errorMessage = nil
                                }
                        )
                    
                }
                
                if showSettings {
                    Settings(showSettings: $showSettings)
                        
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .background(
                            Color("background")
                                .edgesIgnoringSafeArea(.all)
                                
                        )
                }
                                    
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isFirstLoad = false
                }
            }
        }
    }
}


