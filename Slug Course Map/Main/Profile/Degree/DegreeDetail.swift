//
//  DegreeDetail.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/8/23.
//

import SwiftUI
import FirebaseFirestore
//Color(red: 0.2, green: 0.2, blue: 0.2)

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
            
            Color.supaDark.ignoresSafeArea()
            
            main
            
            BackButton {
                degreeTitle = nil
            }
            .padding()
        }
        .onAppear {
            getDegreeInfo()
        }
    }
}

extension DegreeDetail {
        
    func dropdownItem<Content: View>(buttonStateKey: String, title: String, @ViewBuilder body: () -> Content) -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.supaDark28)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                )
            
            VStack {
                Button(action: {
                    withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.4)) {
                        dropdownStates[buttonStateKey]!.toggle()
                    }
                }) {
                    HStack {
                        Text(title)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(Angle(degrees: dropdownStates[buttonStateKey]! ? -270 : 0))
                    }
                    .foregroundStyle(Color.supaWhite)
                    .font(.tTitle2)
                    .padding()
                }
                
                if dropdownStates[buttonStateKey]! {
                    body()
                }
            }
        }
    }
    
    var tabPicker: some View {
        VStack(spacing: 8) {
            
            HStack {
                
                HStack {
                    Spacer()
                    Text("Info")
                        .foregroundStyle(tabSelected == .info ? Color.supaGreen : Color.gray)
                        .bold(tabSelected == .info)
                        .onTapGesture {
                            tabSelected = .info
                        }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Requirements")
                        .foregroundStyle(tabSelected == .requirements ? Color.supaGreen : Color.gray)
                        .bold(tabSelected == .requirements)
                        .onTapGesture {
                            tabSelected = .requirements
                        }
                        .font(.tCallout)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Progress")
                        .foregroundStyle(tabSelected == .progress ? Color.supaGreen : Color.gray)
                        .bold(tabSelected == .progress)
                        .onTapGesture {
                            tabSelected = .progress
                        }
                    Spacer()
                }
            }
            .font(.tTitle3)
            
            
            HStack(spacing: 0) {
                ForEach(DetailTab.allCases, id: \.self ) { type in
                    Rectangle()
                        .frame(height: 3)
                        .foregroundStyle(tabSelected == type ? Color.supaGreen : Color(red: 0.2, green: 0.2, blue: 0.2))
                }
            }
        }
        .padding(.top)
    }
    
    var main: some View {
        VStack {
            
            Text(degreeTitle ?? "")
                .font(.tLargeTitle)
                .padding(.leading, (degreeTitle ?? "").count > 15 ? 32 : 0)
                .foregroundStyle(Color.supaWhite)
            
            tabPicker
            
            if let degree = degree {
                if tabSelected == .info {
                    ScrollView {
                        VStack {
                            
                            if let description = degree.description {
                                dropdownItem(buttonStateKey: "description", title: "Description") {
                                    VStack {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                                        Text(description)
                                            .foregroundStyle(Color.supaWhite)
                                            .padding(.horizontal)
                                            .padding(.vertical)
                                    }
                                }
                            }
                            
                            if degree.ploArr != nil || degree.ploDict != nil {
                                dropdownItem(buttonStateKey: "plo", title: "Learning Outcomes") {
                                    VStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        
                                        if let ploDict = degree.ploDict {
                                            ForEach(Array(ploDict.keys), id: \.self) { key in
                                                VStack(alignment: .leading) {
                                                    Text(key)
                                                        .font(.tTitle3)
                                                        .padding(.bottom, 8)
                    
                                                    Text(ploDict[key]!)
                                                        .font(.tBody)
                                                }
                                                .foregroundStyle(Color.supaWhite)
                                                .padding()
                                            }
                                        } else if let ploArr = degree.ploArr {
                                            ForEach(ploArr, id: \.self) { plo in
                                                VStack(alignment: .leading) {
                    
                                                    Text(" - " + plo)
                                                        .font(.tBody)
                                                }
                                                .foregroundStyle(Color.supaWhite)
                                                .padding()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if let isIntensive = degree.isIntensive {//
                                dropdownItem(buttonStateKey: "gettingStarted", title: "Freshmen: Getting Started") {
                                    VStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        
                                        ZStack {
                                            if isIntensive {
                                                Text("This major **is** high sequential or course intensive. Students who intend to pursue this major must begin taking classes for the major in their first quarter at UCSC.")
                                            } else {
                                                Text("This major is **not** highly sequential or course intensive.")
                                            }
                                        }
                                        .font(.tBody)
                                        .foregroundStyle(Color.supaWhite)
                                        .padding()
                                    }
                                }
                            }
                            
                            if let url = degree.websiteUrl {
                                Link(destination: URL(string: url)!, label: {
                                    Text("Program Website")
                                        .font(.tTitle2)
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
                        description: (doc["intro"] as? String ?? "Error").replacingOccurrences(of: "\\n", with: "\n"),
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
    let description: String?
    let title: String
    let ploDict: [String : String]?
    let ploArr: [String]?
    let isIntensive: Bool?
    let websiteUrl: String?
}

#Preview {
    DegreeDetail(degreeTitle: .constant("Biochemistry and Molecular Biology"), degreeType: "bs")
}
