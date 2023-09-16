import SwiftUI
import MapKit
import CoreLocation


// TODO: Next

struct MapView: View {//36.99635341383817, -122.05936389431821
    
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.996, longitude: -122.06) ,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)
    )
    
    @State var pos: MapCameraPosition = .rect(MKMapRect(
        origin: MKMapPoint(CLLocationCoordinate2D(latitude: 37, longitude: -122.074)),
        size: MKMapSize(width: 20_000, height: 20_000)
    ))
    
        
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            Map(
                position: $pos,
                bounds: MapCameraBounds(centerCoordinateBounds: region, maximumDistance: 5_000)
            )
                .frame(maxHeight: 600)
                .mapControls {
                    MapUserLocationButton()
                }
            
//            ZStack {
//                Circle()
//                    .aspectRatio(1, contentMode: .fit)
//                    .frame(width: 64)
//                    .foregroundStyle(.regularMaterial)
//                    .shadow(color: .gray, radius: 4)
//                    
//                
//                Image(systemName: "location.fill")
//                    .font(.title)
//                    .foregroundStyle(.blue)
//                    .padding()
//                
//            }
//            .onTapGesture {
//                pos = .userLocation(followsHeading: true, fallback: .automatic)
//            }
//            .padding()
        }
        .onAppear {
//            if !(locationManager.locationManager.authorizationStatus == .authorizedWhenInUse) {
//                
//            }
        }
    }
}

#Preview {
    MapView()
}
