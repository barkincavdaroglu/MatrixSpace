//
//  ExpandedSnippetView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct ExpandedSnippet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var matrixVM: MatrixVM
    var notebook: Workspace
    var isNavigationBarHidden = true
        
    var body: some View {
        ScrollView(showsIndicators: false) {
        VStack {
            VStack {
            //MARK: - TOP SECTION OF EXPANDED SNIPPET (PURPLE CARD WITH THE MATRIX)
            VStack {
                
                //MARK: - THE "PURPLE CARD"
                VStack {
                    //MARK: - SUBHEADER
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
                    if notebook.operation != "Invert" {
                    NotebookResult(notebook: notebook)
                    }                    
                }
                .padding(.bottom, 10)
                .frame(width: UIScreen.main.bounds.size.width-60)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color("outline"), lineWidth: 2)
                )
                
                
                NotebookMatrix(matrixVM: matrixVM ,notebook: notebook, isExpandedMode: true)
                    
                
            }.padding(.all, 20)
            .frame(width: UIScreen.main.bounds.size.width-30)
            .background(Color("card_background"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            }
            .frame(width: UIScreen.main.bounds.size.width)
            .shadow(color: Color("CardShadow"), radius:20, x:0, y:30)
            NotesView(notebook: notebook)
            
        }
        .padding(.top, 20)
        .background(Color("background").edgesIgnoringSafeArea(.all))
        }
        
        .navigationBarTitle("Notebook", displayMode: .inline)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("background").edgesIgnoringSafeArea(.all))
        
    }
}
