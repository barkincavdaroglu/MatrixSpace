//
//  SnippetCard.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct SnippetCard: View {
    @ObservedObject var notebook: Workspace
    @EnvironmentObject var matrixVM: MatrixVM
    var body: some View {
        VStack {
            VStack {

                
                //MARK: - THE "PURPLE CARD"
                HeaderCard(notebook: notebook)
                    .cornerRadius(14)
                    .overlay(
                            RoundedRectangle(cornerRadius: 14).stroke(Color("outline"), lineWidth: 1)
                    )
                NotebookMatrix(matrixVM: matrixVM,notebook: notebook, isExpandedMode: false)
                
                HStack {
                    Button(action: {
                        matrixVM.copiedMatrix = notebook.matrix ?? [[""]]
                        matrixVM.copyToWorkspace(operation: notebook.operation ?? "none")
                    }) {
                        HStack {
                            Image(systemName: "scanner")
                                .font(Font.headline.weight(.semibold))
                                .foregroundColor(Color("text"))
                                .padding(.all, 5)
                            Text("Copy to workspace.")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Color("subtext"))
                            Spacer()
                            
                            
                        }
                        
                    }
                    Spacer()
                    NavigationLink(destination: ExpandedSnippet(notebook: notebook), label: {
                        Image(systemName: "arrow.right")
                            .font(Font.headline.weight(.semibold))
                            .foregroundColor(Color("text"))
                            .padding(.all, 5)
                            
                    })
                    
                }
                .padding(.top, 10)
            }.padding(.all, 15)
            .frame(width: UIScreen.main.bounds.size.width-40)
            .background(Color("card_background"))
            .cornerRadius(20)
            .shadow(color: Color("CardShadow"), radius:20, x:0, y:30)
            
            if notebook.notesArray.count != 0 {
                Capsule()
                    .fill(Color("card_background"))
                    .frame(width: UIScreen.main.bounds.size.width-80, height: 8)
            }
        }
        
        
    }
}

struct HeaderCard: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var notebook: Workspace
    
    var body: some View {
        VStack {
            
            //MARK: - SUBHEADER WITH DELETE BUTTON
            HStack {
                if notebook.operation == "Determinant" {
                    Image("det_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                if notebook.operation == "Eigenvalues" {
                    Image("eigen_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                if notebook.operation == "Linear Equations" {
                    Image("lineq_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                if notebook.operation == "Invert" {
                    Image("inverse_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                if notebook.operation == "SVD" {
                    Image("svd_icon")
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                Button(action: {
                    managedObjectContext.delete(notebook)
                    try? managedObjectContext.save()
                }, label: {
                    Image(systemName: "trash")
                        .font(Font.headline.weight(.semibold))
                        .foregroundColor(Color("text"))
                        .padding(.all, 5)
                        .padding(.trailing, 20)
                })
            }
            .padding(.top, 20)
            
            //MARK: - HEADER
            HStack {
                Text("\(notebook.operation ?? "")")
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("text"))
                    .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, -12)
            
            //MARK: - RESULT
            NotebookResult(notebook: notebook)
            
        }.frame(width: UIScreen.main.bounds.size.width-80)
    }
}
