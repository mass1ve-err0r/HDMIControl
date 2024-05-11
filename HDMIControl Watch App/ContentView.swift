//
//  ContentView.swift
//  HDMIControl Watch App
//
//  Created by Saadat Baig on 11.05.24.
//
import SwiftUI


struct ContentView: View {
    
    @StateObject private var irServerManager = IRServerManager()
    
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    @State private var isLoading: Bool = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            if isLoading {
                VStack(alignment: .center, spacing: 10) {
                    ProgressView()
                        .progressViewStyle( .circular)

                    Text("Changing Ports...")
                }
                .navigationTitle("HDMIControl")
                .transition( .asymmetric(insertion: .opacity.animation(.easeInOut(duration: 1)), removal: .opacity).animation(.easeInOut(duration: 1)))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1...8, id: \.self) { portIndex in
                            createButton(title: "Port #\(portIndex)", completion: {
                                irServerManager.changeHDMIPort(portIndex) { requestSuccessful in
                                    if requestSuccessful {
                                        showSuccessMessage.toggle()
                                    } else {
                                        showErrorMessage.toggle()
                                    }
                                }
                            })
                        }
                    }
                }
                .transition( .asymmetric(insertion: .opacity.animation(.easeInOut(duration: 1)), removal: .opacity).animation(.easeInOut(duration: 1)))
                .padding( .top)
                .navigationTitle("HDMIControl")
            }
        }
        .alert(isPresented: $showSuccessMessage, content: {
            Alert(title: Text("Success"), message: Text("Port changed."), dismissButton: .cancel(Text("OK"), action: {
                isLoading.toggle()
            }))
        })
        .alert(isPresented: $showErrorMessage, content: {
            Alert(title: Text("Error"), message: Text("IR-Server did not respond."), dismissButton: .cancel(Text("OK"), action: {
                isLoading.toggle()
            }))
        })
    }
    
    
    @ViewBuilder
    public func createButton(title: String, completion: @escaping () -> Void) -> some View {
        Button(action: {
            isLoading.toggle()
            completion()
        }, label: {
            Text(title)
        })
    }
    
}


#Preview {
    ContentView()
}
