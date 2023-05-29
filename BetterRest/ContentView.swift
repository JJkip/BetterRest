//
//  ContentView.swift
//  BetterRest
//
//  Created by Joseph Langat on 27/05/2023.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    @State private var alertTitle = " "
    @State private var alertMessage = " "
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(coffeeAmount == 1 ? "1 Cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
    //            Text(Date.now, format: .dateTime.day().month().year())
    //            Text(Date.now.formatted(date: .long, time: .shortened))
    //            Text(Date.now.formatted(date: .long, time: .omitted))
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
        .alert(alertTitle, isPresented: $showingAlert){
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is:"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showingAlert = true
    }
    func trivialExample() {
       /* let now = Date.now
        let tomorrow = Date.now.addingTimeInterval(86400)
        let range = now...tomorrow
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date.now*/
//        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
//        let hour = components.hour ?? 0
//        let minutes = components.minute ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
/*On-device machine learning went from “extremely hard to do” to “quite possible, and surprisingly powerful” in iOS 11, all thanks to one Apple framework: Core ML. A year later, Apple introduced a second framework called Create ML, which added “easy to do” to the list, and then a second year later Apple introduced a Create ML app that made the whole process drag and drop. As a result of all this work, it’s now within the reach of anyone to add machine learning to their app.
 
 Core ML is capable of handling a variety of training tasks, such as recognizing images, sounds, and even motion, but in this instance we’re going to look at tabular regression. That’s a fancy name, which is common in machine learning, but all it really means is that we can throw a load of spreadsheet-like data at Create ML and ask it to figure out the relationship between various values.

 Machine learning is done in two steps: we train the model, then we ask the model to make predictions. Training is the process of the computer looking at all our data to figure out the relationship between all the values we have, and in large data sets it can take a long time – easily hours, potentially much longer. Prediction is done on device: we feed it the trained model, and it will use previous results to make estimates about new data.*/
