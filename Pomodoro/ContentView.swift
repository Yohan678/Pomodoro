//
//  ContentView.swift
//  Pomodoro
//
//  Created by Yohan Yoon on 2/2/25.
//

import SwiftUI

struct ContentView: View {
    @State var countdownTimer: Int = 5
    @State var timerStringValue: String = "00:00" //value shows up on display
    @State var timerRunning = false
    
    @State var timerString: String = "Study Time"
    
    @State var loops: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            //BackGround
            LinearGradient(colors: [Color("gradient1"), Color("gradient2")], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("POMODORO")
                    .font(.system(size: 30, weight: .light))
                
                Spacer ()
                
                
                Text("how many POMO : \(loops)")
                Text(timerString)
                    .padding()
                    .font(.system(size: 25, weight: .light))
                
                
                Text(timerStringValue)
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning{
                            countdownTimer -= 1
                            updateTimerStringValue()
                        } else if countdownTimer == 0 {
                            timerRunning = false
                            //if 25 min timer, which is Study Time is done, it will automatically add 1 min timer, which is Break Time
                            if timerString == "Study Time" {
                                timerString = "Break Time"
                                countdownTimer = 3
                            } else {
                                timerString = "Study Time"
                                countdownTimer = 5
                                loops += 1
                            }
                            updateTimerStringValue()
                        }
                    }
                    .font(.system(size: 55, weight: .bold))
                    .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button { timerRunning = true } label: { Image(systemName: "play.fill")}
                        .padding()
                        .foregroundStyle(.black)
                        .font(.system(size: 50, weight: .bold))
                        .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                    Button { timerRunning = false } label: { Image(systemName: "pause.fill")}
                        .padding()
                        .foregroundStyle(.black)
                        .font(.system(size: 50, weight: .bold))
                        .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                } // play & pause buttons
                
                Spacer()
            }
            .onAppear { updateTimerStringValue() }
        }
    }
    
    func updateTimerStringValue() {
        let minutes = (countdownTimer % 3600) / 60
        let seconds = countdownTimer % 60
        
        timerStringValue = String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
