import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var drawable: Drawable
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
            Label("Speak", systemImage: "mic.circle.fill")
                .font(.title)
                Button(action: {
                    if !isRecording {
                        startDraw()
                    } else {
                        endDraw()
                    }
                }) {
                    Text(isRecording ? "Stop" : "Record")
                        .foregroundColor(.white)

                }
                .buttonStyle(.borderedProminent)
    }
    
    private func startDraw() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endDraw() {
        speechRecognizer.stopTranscribing()
        isRecording = false
        let newHistory = History(transcript: speechRecognizer.transcript)
        drawable.history.insert(newHistory, at: 0)
        drawable.prompt = speechRecognizer.transcript
    }
}

//struct MeetingView_Previews: PreviewProvider {
//    static var previews: some View {
////        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
//    }
//}
