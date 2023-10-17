//
//  SquiggleShape.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 10/11/23.
//

import SwiftUI

struct SquiggleAnimationView: View {
    @State var introOpacity: Double =  1.0
    @State var scaleEffect: Double =  1.0
    @State var animationIsRunning: Bool = false
    
    @Binding var showView: Bool
    
    var body: some View {
        ZStack {
            ZStack {
                Color.appBlue.ignoresSafeArea()
                
                SquiggleShape()
                    .foregroundStyle(Color.appYellow)
                    .scaleEffect(scaleEffect)
                    
            }
            .opacity(introOpacity)
        }
        .onAppear() {
            runAnimation()
        }
    }
    
    func runAnimation() {
        animationIsRunning = true
        let scaleUpDuration: Double = 0.7
        let scaleDownDuration: Double = 0.5
        
        withAnimation(.easeOut(duration: scaleUpDuration)) {
            scaleEffect = 2.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + scaleUpDuration) {
            withAnimation(.easeIn(duration: scaleDownDuration)) {
                scaleEffect = 0.01
            }
            
            withAnimation(.easeInOut(duration: scaleDownDuration)) {
                introOpacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showView = true
        }
        
        
    }
    
    func resetAnimation() {
        
        introOpacity = 1.0
        scaleEffect = 1.0
        
        animationIsRunning = false
    }
}

struct SquiggleShape: View {
    var body: some View {
        MyIcon()
            .aspectRatio(3, contentMode: .fit)
            .rotation3DEffect(
                .degrees(180),
                axis: (x: 0, y: 1, z: 0.0)
            )
            .scaleEffect(0.9)
            .offset(x: 40, y: -150)
    }
}

#Preview {
    SquiggleAnimationView(showView: .constant(false))
}

struct MyIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 1.10507*width, y: 1.63378*height))
        path.addCurve(to: CGPoint(x: 0.94905*width, y: 1.63078*height), control1: CGPoint(x: 1.02683*width, y: 1.63198*height), control2: CGPoint(x: 0.97483*width, y: 1.63098*height))
        path.addCurve(to: CGPoint(x: 0.86425*width, y: 1.63742*height), control1: CGPoint(x: 0.89847*width, y: 1.63039*height), control2: CGPoint(x: 0.87912*width, y: 1.6193*height))
        path.addLine(to: CGPoint(x: 0.85725*width, y: 1.64637*height))
        path.addCurve(to: CGPoint(x: 0.85064*width, y: 1.68101*height), control1: CGPoint(x: 0.85319*width, y: 1.65504*height), control2: CGPoint(x: 0.85099*width, y: 1.66659*height))
        path.addCurve(to: CGPoint(x: 0.832*width, y: 1.7467*height), control1: CGPoint(x: 0.84915*width, y: 1.74322*height), control2: CGPoint(x: 0.8372*width, y: 1.74322*height))
        path.addCurve(to: CGPoint(x: 0.81092*width, y: 1.65943*height), control1: CGPoint(x: 0.82681*width, y: 1.75018*height), control2: CGPoint(x: 0.8095*width, y: 1.74176*height))
        path.addCurve(to: CGPoint(x: 0.80737*width, y: 1.62778*height), control1: CGPoint(x: 0.8122*width, y: 1.64455*height), control2: CGPoint(x: 0.81102*width, y: 1.634*height))
        path.addCurve(to: CGPoint(x: 0.80002*width, y: 1.65943*height), control1: CGPoint(x: 0.80247*width, y: 1.62978*height), control2: CGPoint(x: 0.80002*width, y: 1.64033*height))
        path.addCurve(to: CGPoint(x: 0.77724*width, y: 1.70394*height), control1: CGPoint(x: 0.80002*width, y: 1.69281*height), control2: CGPoint(x: 0.7835*width, y: 1.70858*height))
        path.addCurve(to: CGPoint(x: 0.75721*width, y: 1.64153*height), control1: CGPoint(x: 0.77362*width, y: 1.70394*height), control2: CGPoint(x: 0.75721*width, y: 1.69051*height))
        path.addCurve(to: CGPoint(x: 0.73808*width, y: 1.54785*height), control1: CGPoint(x: 0.76235*width, y: 1.57908*height), control2: CGPoint(x: 0.75597*width, y: 1.54785*height))
        path.addCurve(to: CGPoint(x: 0.70901*width, y: 1.65943*height), control1: CGPoint(x: 0.72014*width, y: 1.55348*height), control2: CGPoint(x: 0.71045*width, y: 1.59067*height))
        path.addCurve(to: CGPoint(x: 0.70598*width, y: 1.80006*height), control1: CGPoint(x: 0.70822*width, y: 1.72088*height), control2: CGPoint(x: 0.70721*width, y: 1.76775*height))
        path.addCurve(to: CGPoint(x: 0.66849*width, y: 1.91371*height), control1: CGPoint(x: 0.70433*width, y: 1.86585*height), control2: CGPoint(x: 0.69184*width, y: 1.90374*height))
        path.addCurve(to: CGPoint(x: 0.63131*width, y: 1.82048*height), control1: CGPoint(x: 0.6494*width, y: 1.91453*height), control2: CGPoint(x: 0.637*width, y: 1.88345*height))
        path.addCurve(to: CGPoint(x: 0.63131*width, y: 1.65943*height), control1: CGPoint(x: 0.63024*width, y: 1.7627*height), control2: CGPoint(x: 0.63131*width, y: 1.70394*height))
        path.addCurve(to: CGPoint(x: 0.5777*width, y: 1.49798*height), control1: CGPoint(x: 0.62971*width, y: 1.5518*height), control2: CGPoint(x: 0.61184*width, y: 1.49798*height))
        path.addCurve(to: CGPoint(x: 0.53261*width, y: 1.63078*height), control1: CGPoint(x: 0.54564*width, y: 1.51711*height), control2: CGPoint(x: 0.53061*width, y: 1.56138*height))
        path.addCurve(to: CGPoint(x: 0.56119*width, y: 1.89858*height), control1: CGPoint(x: 0.53261*width, y: 1.63742*height), control2: CGPoint(x: 0.55878*width, y: 1.78175*height))
        path.addCurve(to: CGPoint(x: 0.47849*width, y: 2.22542*height), control1: CGPoint(x: 0.57778*width, y: 2.08351*height), control2: CGPoint(x: 0.55021*width, y: 2.19245*height))
        path.addCurve(to: CGPoint(x: 0.38804*width, y: 1.99829*height), control1: CGPoint(x: 0.421*width, y: 2.21572*height), control2: CGPoint(x: 0.38617*width, y: 2.1211*height))
        path.addCurve(to: CGPoint(x: 0.421*width, y: 1.67061*height), control1: CGPoint(x: 0.38881*width, y: 1.94763*height), control2: CGPoint(x: 0.4121*width, y: 1.7942*height))
        path.addCurve(to: CGPoint(x: 0.40457*width, y: 1.57318*height), control1: CGPoint(x: 0.42447*width, y: 1.62232*height), control2: CGPoint(x: 0.4081*width, y: 1.57318*height))
        path.addCurve(to: CGPoint(x: 0.26076*width, y: 1.47134*height), control1: CGPoint(x: 0.39127*width, y: 1.54428*height), control2: CGPoint(x: 0.34854*width, y: 1.5516*height))
        path.addCurve(to: CGPoint(x: 0.12549*width, y: 1.3208*height), control1: CGPoint(x: 0.21096*width, y: 1.4263*height), control2: CGPoint(x: 0.16587*width, y: 1.37612*height))
        path.addCurve(to: CGPoint(x: 0.11533*width, y: 1.24989*height), control1: CGPoint(x: 0.11872*width, y: 1.27353*height), control2: CGPoint(x: 0.11533*width, y: 1.24989*height))
        path.addCurve(to: CGPoint(x: 0.22266*width, y: 1.37345*height), control1: CGPoint(x: 0.11533*width, y: 1.24989*height), control2: CGPoint(x: 0.15111*width, y: 1.29108*height))
        path.addCurve(to: CGPoint(x: 0.27476*width, y: 1.41774*height), control1: CGPoint(x: 0.24552*width, y: 1.39361*height), control2: CGPoint(x: 0.26289*width, y: 1.40837*height))
        path.addCurve(to: CGPoint(x: 0.31583*width, y: 1.44698*height), control1: CGPoint(x: 0.28663*width, y: 1.4271*height), control2: CGPoint(x: 0.30032*width, y: 1.43685*height))
        path.addCurve(to: CGPoint(x: 0.40649*width, y: 1.4885*height), control1: CGPoint(x: 0.36397*width, y: 1.47001*height), control2: CGPoint(x: 0.39419*width, y: 1.48385*height))
        path.addCurve(to: CGPoint(x: 0.44014*width, y: 1.54785*height), control1: CGPoint(x: 0.421*width, y: 1.49798*height), control2: CGPoint(x: 0.43326*width, y: 1.52138*height))
        path.addCurve(to: CGPoint(x: 0.44974*width, y: 1.70394*height), control1: CGPoint(x: 0.4442*width, y: 1.56417*height), control2: CGPoint(x: 0.44868*width, y: 1.65629*height))
        path.addCurve(to: CGPoint(x: 0.47849*width, y: 1.97702*height), control1: CGPoint(x: 0.4522*width, y: 1.8151*height), control2: CGPoint(x: 0.44605*width, y: 1.97239*height))
        path.addCurve(to: CGPoint(x: 0.50753*width, y: 1.90853*height), control1: CGPoint(x: 0.489*width, y: 1.97702*height), control2: CGPoint(x: 0.50753*width, y: 1.96061*height))
        path.addCurve(to: CGPoint(x: 0.50903*width, y: 1.67061*height), control1: CGPoint(x: 0.51078*width, y: 1.84634*height), control2: CGPoint(x: 0.51078*width, y: 1.76577*height))
        path.addCurve(to: CGPoint(x: 0.52324*width, y: 1.50844*height), control1: CGPoint(x: 0.50903*width, y: 1.54359*height), control2: CGPoint(x: 0.51804*width, y: 1.54014*height))
        path.addCurve(to: CGPoint(x: 0.55916*width, y: 1.44223*height), control1: CGPoint(x: 0.52931*width, y: 1.48282*height), control2: CGPoint(x: 0.54349*width, y: 1.44698*height))
        path.addCurve(to: CGPoint(x: 0.62708*width, y: 1.47134*height), control1: CGPoint(x: 0.57323*width, y: 1.43796*height), control2: CGPoint(x: 0.60786*width, y: 1.42782*height))
        path.addCurve(to: CGPoint(x: 0.65321*width, y: 1.61175*height), control1: CGPoint(x: 0.6445*width, y: 1.51416*height), control2: CGPoint(x: 0.65321*width, y: 1.56097*height))
        path.addCurve(to: CGPoint(x: 0.66849*width, y: 1.75399*height), control1: CGPoint(x: 0.65394*width, y: 1.70172*height), control2: CGPoint(x: 0.65903*width, y: 1.74913*height))
        path.addCurve(to: CGPoint(x: 0.6916*width, y: 1.57994*height), control1: CGPoint(x: 0.68564*width, y: 1.76295*height), control2: CGPoint(x: 0.68564*width, y: 1.67507*height))
        path.addCurve(to: CGPoint(x: 0.70598*width, y: 1.49798*height), control1: CGPoint(x: 0.69448*width, y: 1.54687*height), control2: CGPoint(x: 0.69927*width, y: 1.51955*height))
        path.addCurve(to: CGPoint(x: 0.77276*width, y: 1.49798*height), control1: CGPoint(x: 0.72142*width, y: 1.47081*height), control2: CGPoint(x: 0.74368*width, y: 1.47081*height))
        path.addCurve(to: CGPoint(x: 0.82383*width, y: 1.5602*height), control1: CGPoint(x: 0.78282*width, y: 1.50508*height), control2: CGPoint(x: 0.81092*width, y: 1.54785*height))
        path.addCurve(to: CGPoint(x: 0.86542*width, y: 1.57318*height), control1: CGPoint(x: 0.83258*width, y: 1.56885*height), control2: CGPoint(x: 0.84644*width, y: 1.57318*height))
        path.addLine(to: CGPoint(x: 1.09703*width, y: 1.58251*height))
        path.addLine(to: CGPoint(x: 1.10507*width, y: 1.63378*height))
        path.closeSubpath()
        return path
    }
}


