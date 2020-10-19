//
//  NoteView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var workspace: Workspace
    var note: Note
    let NoteColors = [Color("NoteColor1"), Color("NoteColor2"), Color("NoteColor3"), Color("NoteColor4"), Color("NoteColor5")]
    var body: some View {
        VStack {
            
            //MARK: - HEADER WITH DELETE BUTTON
            HStack {
                VStack {
                    if note.title != "" {
                        HStack {
                            
                            Text("\(note.title ?? "")")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(Font.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color("text"))
                            Spacer()
                            
                        }
                    }
                    
                    //CAPSULE
                    HStack {
                        if workspace.operation == "Eigenvalues" {
                            Capsule()
                                .fill(NoteColors[0])
                                .frame(width: 30, height: 3)
                            
                        }
                        else if workspace.operation == "Determinant" {
                            Capsule()
                                .fill(NoteColors[1])
                                .frame(width: 30, height: 3)
                        }
                        else if workspace.operation == "Linear Equations" {
                            Capsule()
                                .fill(NoteColors[2])
                                .frame(width: 30, height: 3)
                        }
                        else if workspace.operation == "Invert" {
                            Capsule()
                                .fill(NoteColors[3])
                                .frame(width: 30, height: 3)
                        }
                        else if workspace.operation == "SVD" {
                            Capsule()
                                .fill(NoteColors[4])
                                .frame(width: 30, height: 3)
                        }
                        Spacer()
                    }
                    
                }
                Button(action: {
                    workspace.removeFromNotes(note)
                    try? managedObjectContext.save()
                }, label: {
                    Image(systemName: "trash")
                        .font(Font.headline.weight(.semibold))
                        .foregroundColor(Color("text"))
                })
                
            }
            
            
            //MARK: - NOTE'S MAIN TEXT
            HStack {
                Text("\(note.note ?? "")")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color("lighter_text"))
                Spacer()
            }
            .padding(.top, note.title != "" ? 5 : 0)

        }
        .padding(.all, 20)
        .frame(width: UIScreen.main.bounds.size.width-30)
        .background(Color("card_background"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
