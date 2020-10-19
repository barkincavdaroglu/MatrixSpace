//
//  NotebookView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct NotebookView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Workspace.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Workspace.date, ascending: false)
    ]) var notebooks: FetchedResults<Workspace>
    
    @Binding var isNavigationBarHidden: Bool
    @EnvironmentObject var matrixVM: MatrixVM
    
    @State var show = false
    
        
    var body: some View {
        
        //MARK: - SAVED WORKSPACES SCROLL VIEW
            ZStack {
                Color("background")
                VStack {
                    if notebooks.count > 0 {
                        
                        ScrollView(showsIndicators: false) {
                            
                                ForEach(notebooks, id: \.self) { notebook in
                                    
                                    NavigationLink(destination: ExpandedSnippet(notebook: notebook).navigationBarTitle("Notebook", displayMode: .inline)) {
                                        SnippetCard(notebook: notebook)
                                            .frame(width: UIScreen.main.bounds.width)
                                    }
                                    .padding(.bottom, 30)
                                }
                        }
                        
                    } else {
                        VStack {
                            Image("empty_workspace")
                            Text("You do not have any saved workspace.")
                                .font(.system(size: 18, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                                .padding(.top, 10)
                        }
                        .padding(.top, -150)
                    }
                }
            }
            
            .navigationBarTitle("Saved Notebooks", displayMode: .large)

            .background(Color("background").edgesIgnoringSafeArea(.all))
                    .onAppear {
                        self.isNavigationBarHidden = false
                    }
        }
}



struct NotebookResult: View {
    @ObservedObject var notebook: Workspace
    
    var body: some View {
        VStack {
            HStack {
                switch notebook.operation {
                case "Eigenvalues":
                    NotebookEigenvalues(notebook: notebook)
                case "Determinant":
                    Group {
                        Text("\(notebook.result?[0] ?? "")").font(.system(size: 18, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(Color("text"))
                        Spacer()
                        }
                    .padding(.bottom, 10)
                case "Linear Equations":
                    
                    VStack {
                            if (notebook.result?.count ?? 0) <= 3 {
                                HStack {
                                    ForEach(0..<(notebook.result?.count)!, id:\.self) { i in
                                        HStack {
                                            Text("x").font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-6.0)
                                            Text(": \(String((notebook.result?[i].prefix(5))!))")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                            
                                        }
                                        
                                    }
                                    Spacer()
                                }
                            }
                            else if (notebook.result?.count ?? 0) <= 6 {
                                HStack {
                                    ForEach(0..<3, id:\.self) { i in
                                        HStack {
                                            Text("x").font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-6.0)
                                            Text(": \(String((notebook.result?[i].prefix(5))!))")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                            
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                
                                HStack {
                                    ForEach(3..<(notebook.result?.count)!, id:\.self) { i in
                                        HStack {
                                            Text("x").font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 12, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                                .baselineOffset(-6.0)
                                            Text(": \(String((notebook.result?[i].prefix(5))!))")
                                                .font(.system(size: 16, design: .rounded))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("text"))
                                            
                                        }
                                        
                                    }
                                    Spacer()
                                }
                            }
                            
                        
                    }
                    .padding(.bottom, 10)
                    Spacer()
                case "SVD":
                    Text("Rank: \(notebook.result?[0] ?? "")").font(.system(size: 18, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(Color("text"))
                    Spacer()
                case "Invert":
                    Text("")
                default:
                    HStack {
                        Text("No result was found.")
                        Spacer()
                    }
                }

            }
            .padding(.top, notebook.operation != "Invert" ? 5 : 0)
            .padding(.leading, 20)
        }
    }
}

struct NotebookMatrix: View {
    @ObservedObject var matrixVM: MatrixVM
    @ObservedObject var notebook: Workspace
    var isExpandedMode: Bool
    
    var body: some View {
        if (notebook.matrix?.count ?? 0) <= 4 && notebook.operation != "Linear Equations" && notebook.operation != "Invert" {
            VStack {
                ForEach(0..<(notebook.matrix?.count ?? 0), id:\.self) { index1 in
                    HStack {
                        ForEach(0..<(notebook.matrix?[0].count ?? 0), id:\.self) { index2 in
                            Text("\(notebook.matrix?[index1][index2] ?? "")")
                                .foregroundColor(Color("text"))
                                .padding(.all, 5)
                                .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                .background(Color("card_matrix_textfield_bg"))
                                .cornerRadius(4)
                            
                        }
                    }
                }
            }
            .frame(width: isExpandedMode ? UIScreen.main.bounds.size.width-60 : UIScreen.main.bounds.size.width-80)
            .padding(.top, 20)
        }
        else if (notebook.operation == "Linear Equations" ) {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                        ForEach(0..<(notebook.matrix?.count ?? 0), id:\.self) { index1 in
                            HStack {
                                ForEach(0..<(notebook.matrix?[0].count ?? 0), id:\.self) { index2 in
                                    if index2 != (notebook.matrix?.endIndex ?? 0) {
                                        Text("\(notebook.matrix?[index1][index2] ?? "")")
                                            .foregroundColor(Color("text"))
                                            .padding(.all, 5)
                                            .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                            .background(Color("card_matrix_textfield_bg"))
                                            .cornerRadius(4)
                                    } else {
                                        Text("\(notebook.matrix?[index1].last ?? "")")
                                            .foregroundColor(Color("text"))
                                            .padding(.all, 5)
                                            
                                            .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                            .background(Color("card_matrix_textfield_bg"))
                                            .cornerRadius(4)
                                            .padding(.leading, 30)
                                    }
                                    
                                }
                            }
                        }
                }
            }
            .frame(width: isExpandedMode ? UIScreen.main.bounds.size.width-60 : UIScreen.main.bounds.size.width-80)
            .padding(.top, 20)
        }
        else if (notebook.operation == "Invert") {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                        ForEach(0..<(notebook.matrix?.count ?? 0), id:\.self) { index1 in
                            HStack {
                                ForEach(0..<(notebook.matrix?[0].count ?? 0), id:\.self) { index2 in
                                    if index2 != (((notebook.matrix?[0].count ?? 0)/2) ) {
                                        
                                        Text("\(notebook.matrix?[index1][index2] ?? "")")
                                            .foregroundColor(Color("text"))
                                            .padding(.all, 5)
                                            .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                            .background(Color("card_matrix_textfield_bg"))
                                            .cornerRadius(4)
                                    }
                                    else {
                                        HStack {
                                        Text("\(notebook.matrix?[index1][index2] ?? "")")
                                            .foregroundColor(Color("text"))
                                            .padding(.all, 5)
                                            .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                            .background(Color("card_matrix_textfield_bg"))
                                            .cornerRadius(4)
                                        }.padding(.leading, 40)
                                    }
                                    
                                }
                            }
                        }
                }
            }
            .frame(width: isExpandedMode ? UIScreen.main.bounds.size.width-60 : UIScreen.main.bounds.size.width-80)
            .padding(.top, 20)
        }
        else {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    ForEach(0..<(notebook.matrix?.count ?? 0), id:\.self) { index1 in
                        HStack {
                            ForEach(0..<(notebook.matrix?[0].count ?? 0), id:\.self) { index2 in
                                Text("\(notebook.matrix?[index1][index2] ?? "")")
                                    .foregroundColor(Color("text"))
                                    .padding(.all, 5)
                                    .frame(width: (isExpandedMode ? 70 : 50), height: 23, alignment: .center)
                                    .background(Color("card_matrix_textfield_bg"))
                                    .cornerRadius(4)
                                
                            }
                        }
                    }
                }
            }
            .frame(width: isExpandedMode ? UIScreen.main.bounds.size.width-60 : UIScreen.main.bounds.size.width-80)
            .padding(.top, 20)
        }
    }
}

struct NotebookEigenvalues: View {
    @ObservedObject var notebook: Workspace
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
        HStack {
            VStack {
                if (notebook.result?.count ?? 0) <= 3 {
                    HStack {
                        ForEach(0..<(notebook.result?.count ?? 0), id:\.self) { i in
                            HStack {
                                Text("\u{1D740}").font(.system(size: 18, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                    .foregroundColor(Color("text"))
                                    .baselineOffset(-6.0)
                                Text(": \(String(notebook.result?[i] ?? ""))")
                                    .font(.system(size: 13, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text"))
                            }
                            .frame(height: 25)
                        }
                        Spacer()
                    }
                    
                }
                else if (notebook.result?.count ?? 0) <= 6 && (notebook.result?.count ?? 0) >= 3 {
                    VStack {
                        HStack {
                            ForEach(0..<3, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-6.0)
                                    Text(":\(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }
                            Spacer()
                        }
                        HStack {
                            ForEach(3..<(notebook.result?.count ?? 0), id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-6.0)
                                    Text(":\(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }
                            Spacer()
                        }
                    }
                }
                else if (notebook.result?.count ?? 0) <= 9 && (notebook.result?.count ?? 0) >= 6 {
                    VStack {
                        HStack {
                            ForEach(0..<3, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }
                            Spacer()
                        }
                        HStack {
                            ForEach(3..<6, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }

                            Spacer()
                        }
                        HStack {
                            ForEach(6..<(notebook.result?.count ?? 0), id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }

                            Spacer()
                        }
                    }
                }
                else if (notebook.result?.count ?? 0) == 10 {
                    VStack {
                        HStack {
                            ForEach(0..<3, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }
                            Spacer()
                        }
                        HStack {
                            ForEach(3..<6, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }

                            Spacer()
                        }
                        HStack {
                            ForEach(6..<9, id:\.self) { i in
                                HStack {
                                    Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("text")) + Text("\(i+1)").font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Color("text"))
                                        .baselineOffset(-4.0)
                                    Text(": \(String(notebook.result?[i] ?? ""))")
                                        .font(.system(size: 13, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("text"))
                                }
                                .frame(height: 25)
                            }

                            Spacer()
                        }
                        HStack {
                            Text("\u{1D740}").font(.system(size: 16, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(Color("text")) + Text("\(10)").font(.system(size: 10, design: .rounded))
                                .foregroundColor(Color("text"))
                                .baselineOffset(-4.0)
                            Text(": \(String(notebook.result?[9] ?? ""))")
                                .font(.system(size: 13, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("text"))
                            Spacer()
                        }
                        .frame(height: 25)
                        Spacer()
                    }
                }
            }
            .padding(.bottom, 10)            
        }
        }
    }
}

