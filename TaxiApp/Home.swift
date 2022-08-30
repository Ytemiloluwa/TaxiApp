//
//  Home.swift
//  TaxiApp
//
//  Created by Temiloluwa on 30/08/2022.
//  Copyright © 2022 Tello. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import UIKit

struct Home: View {
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source :CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var txt = ""
    @State var name = ""
    @State var distance = ""
    @State var time = ""
    @State var show = false
    @State var loading = false
    
    var body : some View {
        
        ZStack {
            
            ZStack(alignment: .bottom){
                
                VStack(spacing: 0){
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text(self.destination != nil ? "Destination" : "Pick a Location").font(.system(size: 23))
                            
                            if self.destination != nil {
                                
                                Text(self.name).font(.system(size: 23))
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color(.black).opacity(0.2))
                    
                    MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, txt: self.$txt, name: self.$name, time: self.$time, distance: self.$distance, show: self.$show)
                        .onAppear{
                            
                            self.manager.requestAlwaysAuthorization()
                    }
                }
                
                if self.destination != nil && self.show {
                    
                    ZStack(alignment: .topTrailing) {
                        
                        VStack(spacing: 20){
                            
                            HStack {
                                
                                VStack(alignment: .leading , spacing: 15) {
                                    
                                    Text("Destination").font(.system(size: 23))
                                    
                                    Text(self.name)
                                    
                                    Text("Distance - "+self.distance+" KM")
                                    
                                    Text("Expected Time"+self.time+" Min")
                                    
                                    
                                }
                                Spacer()
                            }
                            
                            Button(action: {
                                
                                
                                
                            }) {
                                
                                Text("Book now").foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .frame(width: UIScreen.main.bounds.width / 2)
                                
                                
                            }
                            .background(Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)))
                            .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            
                            self.map.removeOverlays(self.map.overlays)
                            self.map.removeAnnotations(self.map.annotations)
                            self.destination = nil
                            
                            self.show.toggle()
                            
                        }) {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                            
                        }
                        
                    }
                        
                        
                        
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .background(Color.white)
                }
                
            }
            
            if self.loading {
                
                Loader()
                
            }
            
        }
            
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: self.$alert) { () -> Alert in
            
            
            Alert(title: Text("Error"), message: Text("Please Enable Location in Setings ! "), dismissButton: .destructive(Text("OK")))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
