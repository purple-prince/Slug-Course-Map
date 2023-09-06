import SwiftUI
import Combine


class Object: ObservableObject {
    
    @Published var title: String = "old title"
    
    init() {        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.title = "new title"
        }
    }
}

class AllObjects: ObservableObject {

    @Published var allObjects: [Object] = []
    
    var objectStorage: [AnyCancellable] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else {return}

            let object = Object()
            
            object.objectWillChange.sink {
                self.objectWillChange.send()
            }
            .store(in: &self.objectStorage)

            self.allObjects.append(object)
        }
    }
}

struct hDegreeProgressView: View {
    @StateObject var allObjects = AllObjects()
    
    var body: some View {
        VStack {
            ForEach(allObjects.allObjects, id: \.title) { degree in
                Text(degree.title)
            }
        }
    }
}
