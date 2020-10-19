//
//  NotesView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI
import UIKit
import Introspect

struct NotesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var notebook: Workspace
    @State var showAddNote = false
    @State var title = ""
    @State var noteDetail = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            //MARK: - HEADER
            HStack {
                Text("Notes")
                    .font(.system(size: 22, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("text"))
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.size.width-70)
            
            //MARK: - NOTES LIST
            ForEach(notebook.notesArray, id: \.self) { note in
                NoteView(workspace: notebook, note: note)
                    .frame(width: UIScreen.main.bounds.width)
                    .shadow(color: Color("CardShadow"), radius:20, x:0, y:30)
            }
            .padding(.bottom, 20)
            
            //MARK: - NEW NOTE SECTION
            VStack {
                VStack {
                    TextField("Title", text: $title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(Color("text"))
                    MultilineTextField("Note", text: $noteDetail)
                        .font(Font.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color("lighter_text"))
                    
                    HStack {
                        Spacer()
                        Button(action: {
                                let note = Note(context: self.managedObjectContext)
                                
                                note.id = UUID()
                                note.date = Date()
                                note.title = title
                                note.note = noteDetail
                                
                                notebook.addToNotes(note)
                                
                                try? self.managedObjectContext.save()
                                title = ""
                                noteDetail = ""}, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .regular, design: .rounded))
                                .foregroundColor(Color("lighter_text"))
                        })
                        .padding(.all, 8)
                        .background(Color("background"))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .padding(.all, 20)
                .frame(width: UIScreen.main.bounds.size.width-30)
                .background(Color("card_background"))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color("CardShadow"), radius:20, x:0, y:30)
            }
            
        }
        .padding(.top, 15)
    }
}


struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = true

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(Color("lighter_text"))
                    .font(.system(size: 16, design: .rounded))
                    .fontWeight(.regular)
            }
        }
    }
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.textContainerInset = UIEdgeInsets.zero
        textField.textContainer.lineFragmentPadding = 0
        textField.font = .rounded(ofSize: 16, weight: .regular)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor(named: "lighter_text")

        
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
        }

        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height 
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if (text == "\n") {
                    textView.resignFirstResponder()
                    return false
                }
                return true
        }
    }

}

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}
