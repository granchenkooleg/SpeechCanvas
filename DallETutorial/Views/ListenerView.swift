import SwiftUI
import AVFoundation

struct ListenerView: View {
    @Binding var drawable: Drawable
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        TextField("Enter prompt", text: $drawable.prompt)
        Button(action: {
            if !isRecording {
                startListen()
            } else {
                endListen()
            }
        }) {
            Image(systemName: isRecording ? "stop.fill" : "waveform")
                .foregroundColor(.secondary)
        }
//            .modifier(TextFieldListenButton(text: isRecording))
                    .textFieldStyle(.roundedBorder)
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
////        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
//    }
//}

//struct TextFieldListenButton: ViewModifier {
//    @Binding var isRecording: String
//
//    func body(content: Content) -> some View {
//        HStack {
//            content
//
////            if !text.isEmpty {
//                Button(action: {
//                    if !isRecording {
//                        startListen()
//                    } else {
//                        endListen()
//                    }
//                }) {
//                    Image(systemName: "waveform")
//                                                .foregroundColor(Color(UIColor.opaqueSeparator))
////                    Label("Speak", systemImage: "mic.circle.fill")
////                        .font(.title)
//                    //                    Text(isRecording ? "Stop" : "Record")
////                        .foregroundColor(.white)
//
//                }
////                .buttonStyle(.borderedProminent)
//
////                Button(
////                    action: { self.text = "" },
////                    label: {
////                        Image(systemName: "delete.left")
////                            .foregroundColor(Color(UIColor.opaqueSeparator))
////                    }
////                )
////            }
//        }
//    }
//}
