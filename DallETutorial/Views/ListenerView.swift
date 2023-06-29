import SwiftUI
import AVFoundation

struct ListenerView: View {
    @Binding var drawable: Drawable
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        Button(action: {
            if !isRecording {
                startListen()
            } else {
                endListen()
            }
        }) {
            Image(systemName: isRecording ? "mic.square.fill" : "mic.circle.fill")
                .resizable()
                .foregroundColor(.primary)
                .scaledToFit()
                .frame(width: 50, height: 50)
        }

        //        .textFieldStyle(.roundedBorder)
    }
    
    private func startListen() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endListen() {
        speechRecognizer.stopTranscribing()
        isRecording = false
        let newHistory = History(transcript: speechRecognizer.transcript)
        drawable.history.insert(newHistory, at: 0)
        drawable.prompt = speechRecognizer.transcript
    }
}

//struct MeetingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListenerView(drawable: <#T##Drawable#>, speechRecognizer: <#T##arg#>, isRecording: <#T##arg#>)
//    }
//}
