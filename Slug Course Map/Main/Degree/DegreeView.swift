//
//  DegreeView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/7/23.
//

import SwiftUI
import FirebaseFirestore

struct DegreeView: View {
    
    @Binding var showDegreeView: Bool
    
    enum DegreeType: String, CaseIterable {
        case ba = "ba", bs = "bs", minor = "minor"
    }
    @State var degreeTypeSelected: DegreeType = .ba
    
    @State var allBa: [String] = []
    @State var allBs: [String] = []
    @State var allMinor: [String] = []
    
    var selectedDegrees: [String] {
        switch degreeTypeSelected {
            case .ba: return allBa
            case .bs:  return allBs
            case .minor: return allMinor
        }
    }
    
    
    @State var degreeToShow: String?
    
    
}

extension DegreeView {
    var body: some View {
        
        ZStack {
            if let _ = degreeToShow {
                DegreeDetail(degreeTitle: $degreeToShow, degreeType: degreeTypeSelected.rawValue)
            } else {
                ZStack {
                    
                    main
                    
                    BackButton {
                        showDegreeView = false
                    }
                    .padding()
                }
                .onAppear {
                    loadDegrees()
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

extension DegreeView {
    
    func degreeCard(degree: String) -> some View {
        
        VStack(spacing: 8) {
            HStack {
                Text(degree)
                    .font(.tTitle)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.tTitle2)
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 1)
        }
        .padding(.top, 4)
        .onTapGesture {
            degreeToShow = degree
        }
    }
    
    var main: some View {
        VStack {
            
            Text("Degrees")
                .font(.tLargeTitle)
                
                .padding(.top, 8)
            
            VStack(spacing: 8) {
                HStack {
                    
                    Spacer()
                    
                    Text("B.A.")
                        .foregroundStyle(degreeTypeSelected == .ba ? Color.appPrimary : Color.gray)
                        .bold(degreeTypeSelected == .ba)
                        .onTapGesture { degreeTypeSelected = .ba }
                    
                    Spacer()
                    
                    Text("B.S.")
                        .foregroundStyle(degreeTypeSelected == .bs ? Color.appPrimary : Color.gray)
                        .bold(degreeTypeSelected == .bs)
                        .onTapGesture { degreeTypeSelected = .bs }
                    
                    Spacer()
                    
                    Text("Minor")
                        .foregroundStyle(degreeTypeSelected == .minor ? Color.appPrimary : Color.gray)
                        .bold(degreeTypeSelected == .minor)
                        .onTapGesture { degreeTypeSelected = .minor }
                    
                    Spacer()
                }
                .font(.tTitle2)
                
                HStack(spacing: 0) {
                    ForEach(DegreeType.allCases, id: \.self ) { type in
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(degreeTypeSelected == type ? Color.appPrimary : Color.gray)
                    }
                }
            }
            .padding(.top)
            
            ScrollView {
                if allBa.isEmpty {
                    Text("Loading 😐")
                        .font(.tTitle)
                        .padding(.top)
                } else {
                    ForEach(selectedDegrees, id: \.self) { degree in
                        degreeCard(degree: degree)
                    }
                }
            }
            
            Spacer()
        }
        .foregroundStyle(Color.appPrimary)
    }
}

extension DegreeView {
    func loadDegrees() {
        let db = Firestore.firestore()
        db.collection("degree").document("undergradDegreeInfo").getDocument { snapshot, error in
                        
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let doc = snapshot {
                self.allBa = (doc["allBA"] as? [String] ?? ["Error"]).sorted()
                self.allBs = (doc["allBS"] as? [String] ?? ["Error"]).sorted()
                self.allMinor = (doc["allMinors"] as? [String] ?? ["Error"]).sorted()
            }
        }
        
    }
}

#Preview {
    DegreeView(showDegreeView: .constant(true))
}
