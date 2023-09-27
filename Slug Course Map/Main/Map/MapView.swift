import SwiftUI
import MapKit
import CoreLocation


// TODO: Next

struct MapView: View {//36.99635341383817, -122.05936389431821
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.996, longitude: -122.06) ,
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.02) // span = bounds of where user can pan to on the map
    )
    
    @State var pos: MapCameraPosition = .rect(MKMapRect(
        origin: MKMapPoint(CLLocationCoordinate2D(latitude: 38, longitude: -122.074)), // changing lat to 38 gives more north-centered view of campus
        size: MKMapSize(width: 20_000, height: 20_000)
    ))
    
        
    var body: some View {
        ZStack(alignment: .bottomLeading) {
                        
            
            Map(
                position: $pos,
                bounds: MapCameraBounds(centerCoordinateBounds: region, maximumDistance: 7_000) // maximum distance = max zoom level
            )
                .mapControls {
                    MapUserLocationButton()
                }
        }
        .onAppear {
//            if !(locationManager.locationManager.authorizationStatus == .authorizedWhenInUse) {
//                
//            }
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var location: CLLocation?

    let locationManager = CLLocationManager()

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}

#Preview {
    MapView()
}
