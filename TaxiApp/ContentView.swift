//
//  ContentView.swift
//  TaxiApp
//
//  Created by Tello on 25/04/2020.
//  Copyright © 2020 Tello. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





struct MapView: UIViewRepresentable {
    
    func makeCoordinator() -> MapView.Coordinator {
        
        return MapView.Coordinator(parent1: self)
    }
    
    @Binding var map : MKMapView
    @Binding var manager: CLLocationManager
    @Binding var alert : Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var txt : String
    @Binding var name : String
    @Binding var time : String
    @Binding var distance : String
    @Binding var show : Bool
    
    func makeUIView(context: Context) -> MKMapView {
        
        map.delegate = context.coordinator
        manager.delegate = context.coordinator
        map.showsUserLocation = true
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.Tap(ges:)))
        map.addGestureRecognizer(gesture)
        
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
    }
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        var parent : MapView
        
        init(parent1 : MapView) {
            
            parent = parent1
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied {
                
                self.parent.alert.toggle()
            }
            else {
                
                self.parent.manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let region = MKCoordinateRegion(center: locations.last!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.parent.source = locations.last!.coordinate
            
            self.parent.map.region = region
            
        }
        @objc func Tap(ges: UITapGestureRecognizer) {
            let location = ges.location(in: self.parent.map)
            let mplocation = self.parent.map.convert(location, toCoordinateFrom: self.parent.map)
            
            let point = MKPointAnnotation()
            
            //point.title = "Source"
            
            point.subtitle = "Destination"
            
            self.parent.destination = mplocation
            
            let decoder = CLGeocoder()
            
            decoder.reverseGeocodeLocation(CLLocation(latitude: mplocation.latitude, longitude: mplocation.longitude)) { (places, err) in
                
                
                if err != nil {
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                self.parent.name = places?.first?.name ?? ""
                point.title = places?.first?.name ?? ""
                
                self.parent.show = true
            }
            
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: MKPlacemark(coordinate: self.parent.source))
            
            req.destination = MKMapItem(placemark: MKPlacemark(coordinate: mplocation))
            
            let direction = MKDirections(request: req)
            
            direction.calculate { (dir, err) in
                if err != nil {
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                let polyline = dir?.routes[0].polyline
                
                let dis = dir?.routes[0].distance as! Double
                self.parent.distance = String(format: "%.1f", dis / 1000)
                
                let time = dir?.routes[0].expectedTravelTime as! Double
                self.parent.distance = String(format: "%.1f", time / 60)
                
                self.parent.map.removeOverlays(self.parent.map.overlays)
                
                self.parent.map.addOverlay(polyline!)
                
                self.parent.map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
            }
            
            point.coordinate = mplocation
            self.parent.map.removeAnnotations(self.parent.map.annotations)
            self.parent.map.addAnnotation(point)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .blue
            over.lineWidth = 3
            return over
        }
    }
    
}

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
