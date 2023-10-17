//
//  DiningView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 10/16/23.
//

import SwiftUI
import FirebaseFirestore

struct DiningView: View {
    let allDhNames = [
        "C9 / JRL",
        "Cowell / Stevenson",
        "Crown / Merrill",
        "Porter / Kresge",
        "RC / Oakes"
    ]
    
    let dhHours : [String : [String : String]] = [
        "C9 / JRL" : [
            "Monday" : "7am - 11pm",
            "Tuesday" : "7am - 11pm",
            "Wednesday" : "7am - 11pm",
            "Thursday" : "7am - 11pm",
            "Friday" : "7am - 11pm",
            "Saturday" : "7am - 11pm",
            "Sunday" : "7am - 11pm",
        ],
        
        "Cowell / Stevenson" : [
            "Monday" : "7am - 11pm",
            "Tuesday" : "7am - 11pm",
            "Wednesday" : "7am - 11pm",
            "Thursday" : "7am - 11pm",
            "Friday" : "7am - 8pm",
            "Saturday" : "7am - 8pm",
            "Sunday" : "7am - 11pm",
        ],
        
        "Crown / Merrill" : [
            "Monday" : "7am - 8pm",
            "Tuesday" : "7am - 8pm",
            "Wednesday" : "7am - 8pm",
            "Thursday" : "7am - 8pm",
            "Friday" : "7am - 8pm",
            "Saturday" : "7am - 8pm",
            "Sunday" : "7am - 8pm",],
        
        "Porter / Kresge" : [
            "Monday" : "7am - 7pm",
            "Tuesday" : "7am - 7pm",
            "Wednesday" : "7am - 7pm",
            "Thursday" : "7am - 7pm",
            "Friday" : "7am - 7pm",
            "Saturday" : "Closed all day",
            "Sunday" : "Closed all day",],
        
        "RC / Oakes" : [
            "Monday" : "7am - 11pm",
            "Tuesday" : "7am - 11pm",
            "Wednesday" : "7am - 11pm",
            "Thursday" : "7am - 11pm",
            "Friday" : "7am - 8pm",
            "Saturday" : "7am - 8pm",
            "Sunday" : "7am - 11pm",]
    ]
    
    @State var dropdownStates: [String : Bool] = [
        "C9 / JRL" : false,
        "Cowell / Stevenson" : false,
        "Crown / Merrill" : false,
        "Porter / Kresge" : false,
        "RC / Oakes" : false
    ]
    
    @State var dhToShow: String = ""
    @State var showMenuDetail: Bool = false
    
    func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"  // "EEEE" represents the full day of the week name
        let currentDayOfWeek = dateFormatter.string(from: Date())
        return currentDayOfWeek
    }
    
    @State var menuInfo: [String : [String : [String]]]?
}

extension DiningView {
    var body: some View {
        ZStack {
            Color.supaDark.ignoresSafeArea()
            
            VStack {
                ForEach(allDhNames, id: \.self) { title in
                    dhTitleView(name: title)
                }
            }
        }
        .sheet(isPresented: $showMenuDetail) {
            menuDetail
               // .presentationDetents([0.5])
        }
    }
}

extension DiningView {
    
    var menuDetail: some View {
        ZStack {
            Color.supaDark28.ignoresSafeArea()
            
            VStack {
                if let menuInfo = menuInfo {
                    let meals = menuInfo.keys
                    
                    //Text(Array(menuInfo.keys))
                }
            }
        }
    }
    
    func dhTitleView(name: String) -> some View {
        return Button(action: {
            
            
            withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.4)) {
                dropdownStates[name]!.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.supaDark28)
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                
                VStack {
                    
                    HStack {
                        Text(name)
                            .font(.tTitle2)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(Angle(degrees: dropdownStates[name]! ? -270 : 0))
                    }
                    .foregroundStyle(Color.supaWhite)
                    .padding()
                    
                    if dropdownStates[name]! {
                        VStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                            
                            Text(dhHours[name]![getCurrentDayOfWeek()]!)
                                .padding(.vertical)
                            
                            Button(action: {
                                showMenuDetail = true
                            }) {
                                Text("Menu")
                            }
                            .padding(.bottom)
                        }
                        .foregroundStyle(Color.supaWhite)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
        }
    }
}

extension DiningView {
    func getMenuInfo(for dh: String) {
        let db = Firestore.firestore()
        db.collection("dining").document("menus").collection(nameToName(name: dh)).document("menus").getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription) }
            if let doc = snapshot {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let today = Date()
                let formattedDate = dateFormatter.string(from: today)
                
                menuInfo = doc[formattedDate] as? [String : [String : [String]]]
            }
        }
    }
    
    // Converts local function dh name to name of document in database
    func nameToName(name: String) -> String {
        switch name {
            case "C9 / JRL": return "c9"
            default: return name
        }
        
        /*
         "C9 / JRL" : false,
         "Cowell / Stevenson" : false,
         "Crown / Merrill" : false,
         "Porter / Kresge" : false,
         "RC / Oakes" : false
         */
    }
}

#Preview {
    DiningView()
}
