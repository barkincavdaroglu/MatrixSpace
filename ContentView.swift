//
//  ContentView.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @EnvironmentObject var matrixVM: MatrixVM
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        ZStack {
            NavigationView {
                MatrixKeyboardView(isNavigationBarHidden: $isNavigationBarHidden)
                    
                    .navigationBarHidden(self.isNavigationBarHidden)
                    .onAppear {
                        self.isNavigationBarHidden = true
                }
            }
            .navigationBarTitle("")
            .introspectNavigationController { navigationController in
                navigationController.navigationBar.barTintColor = UIColor(named: "background")
                navigationController.navigationBar.tintColor = UIColor(named: "text")
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "text") ?? UIColor.white]
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "text") ?? UIColor.white]
            }
            
        }
    }
}
