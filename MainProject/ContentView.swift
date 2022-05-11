//
//  ContentView.swift
//  MainProject
//
//  Created by Roland Möller on 11.05.22.
//

import SwiftUI
import MyLibraryA
import MyLibraryB

struct ContentView: View {
    var body: some View {
      VStack(alignment: .trailing) {
        Text("MyLibraryA.text - \(MyLibraryA().text)")
        Text("MyLibraryA.MyLibraryBText - \(MyLibraryA().MyLibraryBText)")
        Text("MyLibraryB.text - \(MyLibraryB().text)")
      }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
