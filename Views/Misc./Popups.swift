//
//  Popups.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct ErrorView: View {
    @Binding var errorMessage: Error?
    @State var isExpanded = false
    @State var expandedHeight = 150
    @State var collapseUpDown = "chevron.down"
    var width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "xmark")
                    .font(Font.headline.weight(.bold))
                    .foregroundColor(Color(#colorLiteral(red: 0.9440508485, green: 0.1448372006, blue: 0.4506054521, alpha: 1)))
                    .padding(.all, 10)
                    .background(Color(#colorLiteral(red: 1, green: 0.843492806, blue: 0.9043439627, alpha: 1)))
                    .cornerRadius(30)
                Spacer()
            }
            .padding(.bottom, 10)
            HStack {
                Text("Error")
                    .font(.system(size: 20, design: .rounded))
                    .foregroundColor(Color("text"))
                Spacer()
            }
            .padding(.bottom, 6)
            VStack {
                Text(errorMessage?.localizedDescription ?? "")
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(Color("lighter_text"))
            }
            .padding(.bottom, 15)
            HStack() {
                Button(action: {
                    errorMessage = nil
                }, label: {
                    Text("Ok")
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(Color("text"))
                })
                .padding(.all, 6)
                .padding(.horizontal, 20)
                .background(Color("background"))
                .cornerRadius(6)
                Spacer()
            }
            
        }
        .frame(width: width)
        .padding(30)
        .background(Color("errorbg"))
        .cornerRadius(20)
        .shadow(color: Color(#colorLiteral(red: 0.2823529412, green: 0.2930266261, blue: 0.3416666687, alpha: 0.1)), radius:20, x:0, y:10)
    }
}

struct Settings: View {
    @Binding var showSettings: Bool
    @State var collapseUpDown = "chevron.down"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Settings")
                    .font(.system(size: 26,weight: .bold, design: .rounded))
                    .foregroundColor(Color("text"))
                Spacer()
                Image(systemName: "xmark")
                    .onTapGesture {
                        showSettings = false
                    }
            }
            .padding(.bottom, 6)
            
            HStack {
                CircleButton()
                    .padding(.top, 10)
                    .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 0))
                    
                Spacer()
                
            }
            .padding(.bottom, 12)
            
            VStack(alignment: .leading) {
                Text("Privacy Policy")
                    .font(.system(size: 20,weight: .bold, design: .rounded))
                    .foregroundColor(Color("textfield_text"))
                    .padding(.bottom, 10)
                    .lineSpacing(10)
                
                Text("Overview")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("textfield_text"))
                    .padding(.bottom, 2)
                Text("This Privacy Policy describes how your personal information is handled in MatrixSpace.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Color("text"))
                    .lineSpacing(4)
                    .padding(.bottom, 10)
                
                Text("We Collect No Personal Information Using Our Applications")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("textfield_text"))
                    .padding(.bottom, 2)
                Text("We do not collect, use, save, or have access to any of your personal data recorded in MatrixSpace. The notebooks and notes that you save are stored only on your device and are accessible only by you.")
                    .font(.system(size: 14, design: .rounded))
                    .lineSpacing(4)
                    .foregroundColor(Color("text"))
                    .padding(.bottom, 10)
                
                Text("Contact")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("textfield_text"))
                    .padding(.bottom, 2)
                Text("If you have any questions about this Privacy Policy, feel free to get in touch with us at info@matrixspace.app")
                    .font(.system(size: 14, design: .rounded))
                    .lineSpacing(4)
                    .foregroundColor(Color("text"))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.all, 20)
        .background(Color("background"))
        
    }
}

struct DimensionCard: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @Binding var showDimensionCard: Bool
    @State var row: String = ""
    @State var column: String = ""
    @Binding var errorMessage: Error?
    
    var body: some View {
        VStack {
            
            HStack {
                
                TextField("Row", text: $row)
                    .frame(width: 40, height: 30, alignment: .center)
                Text("x")
                    .padding(.trailing, 10)
                TextField("Column", text: $column)
                    .frame(width: 60, height: 30, alignment: .center)
                Spacer()
                Button(action: {
                    do {
                        try matrixVM.setDimensions(row: Int(row) ?? 2, column: Int(column) ?? 2)
                        showDimensionCard.toggle()
                        row = ""
                        column = ""
                    } catch {
                        errorMessage = error
                    }
                }, label: {
                    Text("Add")
                        .font(Font.system(size: 16.0))
                        .fontWeight(.medium)
                        .foregroundColor(Color("text"))
                })
                .padding(.all, 10)
                .background(Color("background"))
                .cornerRadius(10)
            }
        }
        .padding(.all, 20)
        .frame(width: (UIScreen.main.traitCollection.userInterfaceIdiom != .pad) ? UIScreen.main.bounds.width-25 : UIScreen.main.bounds.width-150, height: 80, alignment: .center)
        .background(Color("card_background"))
        .cornerRadius(14)
    }
}


struct ExponentCard: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var exponent: String = ""
    @Binding var showExponentCard: Bool
    @Binding var errorMessage: Error?
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    CustomTextField(
                                placeholder: Text("Enter the exponent here").foregroundColor(Color("lighter_text")),
                                text: $exponent
                    )
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(Color("text"))
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundColor(Color("text"))
                        .padding(.leading, 10)
                        .onTapGesture {
                            showExponentCard.toggle()
                        }
                }
                
                Button(action: {
                    do {
                        try matrixVM.matrixExp(of: exponent)
                        showExponentCard.toggle()
                    } catch {
                        errorMessage = error
                    }
                }, label: {
                       Text("Solve")
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(Color("text"))
                })
                .padding(.all, 6)
                .padding(.horizontal, 20)
                .background(Color("background"))
                .cornerRadius(6)

            }
            .padding(30)
            .background(Color("card_background"))
            .cornerRadius(20)
            .shadow(color: Color(#colorLiteral(red: 0.2823529412, green: 0.2930266261, blue: 0.3416666687, alpha: 0.1)), radius:20, x:0, y:10)
        }
    }
}
