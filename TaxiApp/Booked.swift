//
//  Booked.swift
//  TaxiApp
//
//  Created by Temiloluwa on 30/08/2022.
//  Copyright © 2022 Tello. All rights reserved.
//

import SwiftUI

struct Booked: View {

    @Binding var data : Data
    @Binding var doc : String
    @Binding var book: Bool
    
    
    var body : some View {
        
        GeometryReader { _ in
            
            VStack(spacing: 25){
                
                Image(uiImage: UIImage(data: self.data)!)
                
                Button(action: {
                    
                }) {
                    
                    Text("Cancel")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 15)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    
                    
                }
                .background(Color.red)
                .clipShape(Capsule())
                
            }
                
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            
        }
        .background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
    }
}
