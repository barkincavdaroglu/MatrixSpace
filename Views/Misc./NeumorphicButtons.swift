//
//  Buttons.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/8/20.
//

import SwiftUI


struct CircleButton: View {
    @State var tap = false
    @State var press = false
    @State var isDark: Bool = ((UserDefaults.standard.integer(forKey: "LastStyle")) != 1) {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = isDark ? .dark : .light
            UserDefaults.standard.setValue(isDark ? UIUserInterfaceStyle.dark.rawValue : UIUserInterfaceStyle.light.rawValue, forKey: "LastStyle")
        }
    }
    
    var body: some View {
        Group {
            ZStack {
                    Image(systemName: !isDark ? "sun.max.fill" : "moon.stars.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("NoteColor1"))
                        .offset(x: tap ? -180 : 0, y: tap ? 0 : 0)
                        
                        .rotation3DEffect(
                            Angle(degrees: tap ? 20 : 0),
                            axis: (x: 10.0, y: -10.0, z: 0.0)
                        )
                
                    Image(systemName: isDark ? "moon.stars.fill" : "sun.max.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("NoteColor1"))
                        .offset(x: tap ? 0 : 180, y: tap ? 0 : 0)
                        
                        .rotation3DEffect(
                            Angle(degrees: tap ? 0 : 20),
                            axis: (x: -10.0, y: 10.0, z: 0.0)
                        )
                
            }
            .frame(width: 80, height: 35)
            .background(
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color( press ? "card_background" : "card_background"), Color(press ? "card_background" : "card_background")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                    
                }
                
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(tap ? 1.1 : 1)
            .onTapGesture {
                self.tap.toggle()
                self.isDark.toggle()
            }
        }
        
       
    }
}
