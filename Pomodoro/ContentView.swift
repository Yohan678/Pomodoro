//
//  ContentView.swift
//  Pomodoro
//
//  Created by Yohan Yoon on 2/2/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var countdownTimer: Int = 5
    @State var timerStringValue: String = "00:00" // value shows up on display
    @State var timerRunning = false
    @State var timerString: String = "Study Time"
    
    //how many loops users did
    @State var loops: Int = 0
    
    @State var timerSelection: String = "25/5"
    let timerSelections: [String] = ["25/5", "50/10"]
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let fileName = "pomoCount.txt"
    
    var body: some View {
        ZStack {
            // BackGround
            LinearGradient(colors: [Color("gradient1"), Color("gradient2")], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("POMODORO")
                        .font(.custom("DNFBitBitv2", size: 25))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Button {
                        //navigation link to instruction
                    } label: { Image(systemName: "questionmark.circle") }
                        .font(.system(size: 30))
                        .padding(.trailing, 20)
                        .frame(alignment: .trailing)
                }
                
                Picker("Select Timer", selection: $timerSelection) {
                    ForEach(timerSelections, id: \.self) { options in
                        Text(options).tag(options)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: timerSelection) {
                    selectionChanged()
                }
                
                Spacer()
                
                Text("POMO COUNTS : \(loops)")
                    .font(.custom("DNFBitBitv2", size: 13))
                    
                Text(timerString)
                    .padding()
                    .font(.custom("DNFBitBitv2", size: 30))
                
                Text(timerStringValue)
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning {
                            countdownTimer -= 1
                            updateTimerStringValue()
                        } else if countdownTimer == 0 {
                            timerRunning = false
                            // if 25 min timer, which is Study Time is done, it will automatically add 1 min timer, which is Break Time
                            if timerString == "Study Time" {
                                timerString = "Break Time"
                                countdownTimer = timerSelection == "25/5" ? 3 : 6
                            } else {
                                timerString = "Study Time"
                                countdownTimer = timerSelection == "25/5" ? 5 : 10
                                loops += 1
                                saveData()
                            }
                            updateTimerStringValue()
                        }
                    }
                    .font(.custom("DNFBitBitv2", size: 50))
                    .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button { startTimer() } label: { Image(systemName: "play.fill") }
                        .padding()
                        .foregroundStyle(.black)
                        .font(.system(size: 50, weight: .bold))
                        .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                    Button { stopTimer() } label: { Image(systemName: "pause.fill") }
                        .padding()
                        .foregroundStyle(.black)
                        .font(.system(size: 50, weight: .bold))
                        .background(.gray, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                } // play & pause buttons
                
                Spacer()
            }
            .onAppear {
                loadData()
                updateTimerStringValue()
                setupAudioSession()
            }
        }
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startTimer() {
        timerRunning = true
    }
    
    func stopTimer() {
        timerRunning = false
    }
    
    func selectionChanged() {
        timerRunning = false
        
        if timerString == "Study Time" {
            countdownTimer = timerSelection == "25/5" ? 5 : 10
        } else {
            countdownTimer = timerSelection == "25/5" ? 3 : 7
        }
        updateTimerStringValue()
    }
    
    func updateTimerStringValue() {
        let minutes = (countdownTimer % 3600) / 60
        let seconds = countdownTimer % 60
        
        timerStringValue = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func saveData() {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = String(loops)
            try data.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("file saving failed: \(error)")
        }
    }
    
    private func loadData() {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let loadedInput = try String(contentsOf: filePath, encoding: .utf8)
            if let loadedLoops = Int(loadedInput) {
                loops = loadedLoops
            }
        } catch {
            print("file loading failed: \(error)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    ContentView()
}
