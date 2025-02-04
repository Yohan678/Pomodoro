//
//  ContentView.swift
//  Pomodoro
//
//  Created by Yohan Yoon on 2/2/25.
//

// EN&KR language (or JP)
// app icon: 1024 x 1024
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var countdownTimer: Int = 1500
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
        NavigationStack{
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
                        
                        NavigationLink(destination: InstructionView()) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 20))
                                .padding(.trailing, 20)
                        }
                    }
                    
                    Picker("Select Timer", selection: $timerSelection) {
                        ForEach(timerSelections, id: \.self) { options in
                            Text(options).tag(options)
                                .font(.custom("DNFBitBitv2", size: 10))
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
                                dispatchNotification()
                                // if 25 min timer, which is Study Time is done, it will automatically add 1 min timer, which is Break Time
                                if timerString == "Study Time" {
                                    timerString = "Break Time"
                                    countdownTimer = timerSelection == "25/5" ? 300 : 600
                                } else {
                                    timerString = "Study Time"
                                    countdownTimer = timerSelection == "25/5" ? 1500 : 3000
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
                    Button{
                        loops = 0
                        saveData()
                    } label: { Text("Reset")}
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    
                }
                .onAppear {
                    loadData()
                    updateTimerStringValue()
                    setupAudioSession()
                    checkForNotificatioPermission()
                }
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
            countdownTimer = timerSelection == "25/5" ? 1500 : 3000
        } else {
            countdownTimer = timerSelection == "25/5" ? 300 : 600
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
    
    func checkForNotificatioPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { didAllow, error in
                        if didAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    @State var notificationTitle: String = "POMODORO"
    @State var notificationBody: String = ""
    
    func dispatchNotification() {
        //timerString = "Study Time"
        //timerString = "Break Time"
        //timerSelection = "25/5"
        //timerSelection = "50/10"
        
        let identifier = "pomodoro-notification"
        
        if timerString == "Study Time" && timerSelection == "25/5" {
            notificationBody = "Nice Job! Let's take 5 minute break!"
        } else if timerString == "Study Time" && timerSelection == "50/10" {
            notificationBody = "Nice Job! Let's take 10 minute break!"
        } else if timerString == "Break Time" && timerSelection == "25/5" {
            notificationBody = "Let's focus for 25 minute! Good Luck!"
        } else if timerString == "Break Time" && timerSelection == "50/10" {
            notificationBody = "Let's focus for 50 minute! Good Luck!"
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}

#Preview {
    ContentView()
}
