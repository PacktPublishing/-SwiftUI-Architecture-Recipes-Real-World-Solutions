//
//  ContentView.swift
//  ClusteringMap
//
//  Created by Mohammad Azam on 10/14/25.
//

import SwiftUI
import MapKit

struct ClusteredMapView: UIViewRepresentable {
    
    let annotations: [MapPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        context.coordinator.mapView = map
        map.delegate = context.coordinator
        map.showsUserLocation = true
        // Register marker view (needed for clustering + reuse)
        map.register(MKMarkerAnnotationView.self,
                forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKMarkerAnnotationView.self))
        return map
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
        // remove old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // add new annotations
        mapView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

struct BikeStation: Decodable, Identifiable {
    
    var id: String { name }
    let name: String
    let lat: Double
    let lng: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

final class MapPointAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

final class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    weak var mapView: MKMapView?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        // Define a region centered on the user's location
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 2000,
                                        longitudinalMeters: 2000)
        
        // Apply region change on main thread (UI update)
        DispatchQueue.main.async {
            self.mapView?.setRegion(region, animated: true)
            self.mapView?.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        /*
        if let cluster = annotation as? MKClusterAnnotation {
            // return the view for cluster
            
            let identifier = NSStringFromClass(MKMarkerAnnotationView.self)
            let view =  mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as! MKMarkerAnnotationView
            view.markerTintColor = .blue
            view.glyphText = "❤️"
            return view
        } */
        
        let identifier = NSStringFromClass(MKMarkerAnnotationView.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation) as! MKMarkerAnnotationView
        view.canShowCallout = true
        view.titleVisibility = .adaptive
        view.glyphImage = UIImage(systemName: "bicycle")
        view.markerTintColor = .systemGreen
        view.clusteringIdentifier = "bike"
        return view
    }
}

struct ContentView: View {

    @State private var annotations: [MapPointAnnotation] = []
    
    var body: some View {
        ClusteredMapView(annotations: annotations)
            .onAppear {
                do {
                    let stations = try loadBikeStations()
                    annotations = stations.map {
                        MapPointAnnotation(title: $0.name, coordinate: $0.coordinate)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    private func loadBikeStations() throws -> [BikeStation] {
        let url = Bundle.main.url(forResource: "bike_rentals_houston", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let stations: [BikeStation] = try JSONDecoder().decode([BikeStation].self, from: data)
        return stations
    }
}

#Preview {
    ContentView()
}
