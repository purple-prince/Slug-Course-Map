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
            
            BackButton {
                degreeTitle = nil
            }
            .padding()
        }
        .foregroundStyle(Color.appPrimary)
        .onAppear {
            getDegreeInfo()
        }
    }
}

extension DegreeDetail {
        
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
            
            Text(degreeTitle ?? "")
                .font(.largeTitle)
                .padding(.leading, (degreeTitle ?? "").count > 15 ? 32 : 0)
            
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
                                    
                                    if let ploDict = degree.ploDict {
                                        ForEach(Array(ploDict.keys), id: \.self) { key in
                                            VStack(alignment: .leading) {
                                                Text(key)
                                                    .bold()
                
                                                Text(ploDict[key]!)
                                                    .font(.callout)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    } else if let ploArr = degree.ploArr {
                                        ForEach(ploArr, id: \.self) { plo in
                                            VStack(alignment: .leading) {
                
                                                Text(plo)
                                                    .font(.callout)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                }
                            }
                            
                            dropdownItem(buttonStateKey: "gettingStarted", title: "Freshmen: Getting Started") {
                                VStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(height: 1)
                                    
                                    if let isIntensive = degree.isIntensive {
                                        if isIntensive {
                                            Text("This major **is** high sequential or course intensive. Students who intend to pursue this major must begin taking classes for the major in their first quarter at UCSC.")
                                        } else {
                                            Text("This major is **not** highly sequential or course intensive.")
                                        }
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
                        ploDict: doc["plo"] as? [String : String],
                        ploArr: doc["plo"] as? [String],
                        isIntensive: doc["isIntensive"] as? Bool,
                        websiteUrl: doc["website"] as? String
                    )
                }
            }
    }
}

struct Degree {
    let description: String
    let title: String
    let ploDict: [String : String]?
    let ploArr: [String]?
    let isIntensive: Bool?
    let websiteUrl: String?
}

#Preview {
    DegreeDetail(degreeTitle: .constant("Applied Linguistics and Multilingualism"), degreeType: "ba")
}
