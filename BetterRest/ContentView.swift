//
//  ContentView.swift
//  BetterRest
//
//  Created by Mohammed Alhashim on 06/10/2026.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp: Date = defaultWakeUp
    @State private var sleepAmount: Double = 8.0
    @State private var coffeeAmount: Int = 2
    
    
    static var defaultWakeUp: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
        
    }
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return "Your perfect bedtime is " + sleepTime.formatted(date: .omitted, time: .shortened)
        
        } catch {
            return "Sorry, there was an error ;("
        }
    }
    
    var body: some View {
        
        
        NavigationStack {
            Form {
                
                Section(){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.title2)
                }
                
                Section("Desired amount of sleep"){
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake"){
                    
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(0...10, id: \.self) {
                            Text("\($0)")
                            
                        }
                    }
                }
                    
                    Section("Your recommended bedtime is"){
                        Text(sleepResults)
                    }
            }
            
                .navigationTitle("BetterRest")
        }
    }
    
}

#Preview {
    ContentView()
}
