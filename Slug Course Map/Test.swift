


import SwiftUI

struct Test: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: H()) {
                Text("CLICK ME")
            }
            .simultaneousGesture(TapGesture().onEnded{
                print("Hello world!")
            })
        }
    }
}

struct H: View {
    
    init() {
        print("h initialized")
    }
    
    var body: some View {
        ZStack {
            
        }
        .onAppear {
            print("APPEARES")
        }
    }
}
