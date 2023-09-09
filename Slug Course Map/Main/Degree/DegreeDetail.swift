//
//  DegreeDetail.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/8/23.
//

import SwiftUI
import FirebaseFirestore

struct DegreeDetail: View {
    
    @Binding var degreeTitle: String?
    let degreeType: String
    
    enum DetailTab: CaseIterable { case info, requirements, progress }
    @State var tabSelected: DetailTab = .info
    
    @State var degree: Degree?
    
    @State var dropdownStates: [String : Bool] = [
        "description" : false,
        "plo" : false,
        "gettingStarted" : false
    ]
}

extension DegreeDetail {
    var body: some View {
        ZStack {
            
            main
            
            backButton
        }
        .foregroundStyle(Color.appPrimary)
        .onAppear {
            getDegreeInfo()
        }
    }
}




extension DegreeDetail {
    
//    var poop: some View {
//        VStack {
//            VStack {
//                
//                Button(action: {
//                    withAnimation { dropdownStates["description"]!.toggle() }
//                }) {
//                    HStack {
//                        Text("Description")
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chevron.right")
//                            .rotationEffect(Angle(degrees: dropdownStates["description"]! ? -270 : 0))
//                    }
//                    .font(.title2)
//                }
//                
//                if dropdownStates["description"]! {
//                    VStack {
//                        Rectangle()
//                            .frame(height: 1)
//                        
//                        Text(degree.description)
//                            .padding(.top, 8)
//                    }
//
//                }
//                
//            }
//            
//            
//            VStack {
//                
//                Button(action: {
//                    withAnimation { dropdownStates["plo"]!.toggle() }
//                }) {
//                    HStack {
//                        Text("Learning Outcomes")
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chevron.right")
//                            .rotationEffect(Angle(degrees: dropdownStates["plo"]! ? -270 : 0))
//                    }
//                    .font(.title2)
//                }
//                
//                if dropdownStates["plo"]! {
//                    VStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(height: 1)
//                        
//                        ForEach(Array(degree.plo.keys), id: \.self) { key in
//                            VStack(alignment: .leading) {
//                                Text(key)
//                                    .bold()
//                                
//                                Text(degree.plo[key]!)
//                                    .font(.callout)
//                            }
//                            .padding(.vertical, 4)
//                        }
//                    }
//                    
//                        
//                }
//                
//            }
//            
//            VStack {
//                
//                Button(action: {
//                    withAnimation { dropdownStates["gettingStarted"]!.toggle() }
//                }) {
//                    HStack {
//                        Text("Freshmen: Getting Started")
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chevron.right")
//                            .rotationEffect(Angle(degrees: dropdownStates["gettingStarted"]! ? -270 : 0))
//                    }
//                    .font(.title2)
//                }
//                
//                if dropdownStates["gettingStarted"]! {
//                    VStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(height: 1)
//                        
//                        if degree.isIntensive {
//                            Text("intensive lol")
//                        } else {
//                            Text("This major is **not** highly sequential or course intensive.")
//                        }
//                    }
//                    
//                        
//                }
//                
//            }
//        }
//    }
    
    func dropdownItem<Content: View>(buttonStateKey: String, title: String, @ViewBuilder body: () -> Content) -> some View {
        VStack {
            Button(action: {
                withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.4)) { dropdownStates[buttonStateKey]!.toggle() }
            }) {
                HStack {
                    Text(title)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(Angle(degrees: dropdownStates[buttonStateKey]! ? -270 : 0))
                }
                .font(.title2)
            }
            
            if dropdownStates[buttonStateKey]! {
                body()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Color.white.cornerRadius(12)
                .shadow(color: .gray, radius: 4)
        )
    }
    
    var tabPicker: some View {
        VStack(spacing: 8) {
            
            HStack {
                
                HStack {
                    Spacer()
                    Text("Info")
                        .foregroundStyle(tabSelected == .info ? Color.appPrimary : Color.gray)
                        .bold(tabSelected == .info)
                        .onTapGesture {
                            tabSelected = .info
                        }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Requirements")
                        .foregroundStyle(tabSelected == .requirements ? Color.appPrimary : Color.gray)
                        .bold(tabSelected == .requirements)
                        .onTapGesture {
                            tabSelected = .requirements
                        }
                        .font(Font.system(size: 16))
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Progress")
                        .foregroundStyle(tabSelected == .progress ? Color.appPrimary : Color.gray)
                        .bold(tabSelected == .progress)
                        .onTapGesture {
                            tabSelected = .progress
                        }
                    Spacer()
                }
            }
            .font(.title3)
            
            
            HStack(spacing: 0) {
                ForEach(DetailTab.allCases, id: \.self ) { type in
                    Rectangle()
                        .frame(height: 3)
                        .foregroundStyle(tabSelected == type ? Color.appPrimary : Color.gray)
                }
            }
        }
        .padding(.top)
    }
    
    var main: some View {
        VStack {
            Text(degreeTitle!)
                .font(.largeTitle)
            
            tabPicker
            
            if let degree = degree {
                if tabSelected == .info {
                    ScrollView {
                        VStack {
                            
                            dropdownItem(buttonStateKey: "description", title: "Description") {
                                VStack {
                                    Rectangle()
                                        .frame(height: 1)
            
                                    Text(degree.description)
                                        .padding(.top, 8)
                                }
                            }
                            dropdownItem(buttonStateKey: "plo", title: "Learning Outcomes") {
                                VStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(height: 1)
            
                                    ForEach(Array(degree.plo.keys), id: \.self) { key in
                                        VStack(alignment: .leading) {
                                            Text(key)
                                                .bold()
            
                                            Text(degree.plo[key]!)
                                                .font(.callout)
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                            dropdownItem(buttonStateKey: "gettingStarted", title: "Freshmen: Getting Started") {
                                VStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(height: 1)
            
                                    if degree.isIntensive {
                                        Text("intensive lol")
                                    } else {
                                        Text("This major is **not** highly sequential or course intensive.")
                                    }
                                }
                            }
                            
                            if let url = degree.websiteUrl {
                                Link(destination: URL(string: url)!, label: {
                                    Text("Program Website")
                                        .font(.title2)
                                        .underline()
                                })
                                .padding(.vertical)
                            }
                        }
                        .padding()
                    }
                    
                }
            }
            
            Spacer()
        }
        .padding(.top, 12)
    }
    
    var backButton: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.appPrimary)
                    .onTapGesture {
                        degreeTitle = nil
                    }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
    }
}

extension DegreeDetail {
    func getDegreeInfo() {
        
        let db = Firestore.firestore()
        db.collection("degree")
            .document("undergradDegreeInfo")
            .collection(degreeType)
            .document(degreeTitle!.lowercased())
            .getDocument { snapshot, error in
                if let error = error { print(error.localizedDescription); return }
                if let doc = snapshot {
                    self.degree = Degree(
                        description: doc["intro"] as? String ?? "Error",
                        title: degreeTitle ?? "Error",
                        plo: doc["plo"] as? [String : String] ?? ["Error loading data :(":""],
                        isIntensive: doc["isIntensive"] as? Bool ?? false,
                        websiteUrl: doc["website"] as? String ?? ""
                    )
                }
            }
    }
}

struct Degree {
    let description: String
    let title: String
    let plo: [String : String]
    let isIntensive: Bool
    let websiteUrl: String?
}

#Preview {
    DegreeDetail(degreeTitle: .constant("Anthropology"), degreeType: "ba")
}
