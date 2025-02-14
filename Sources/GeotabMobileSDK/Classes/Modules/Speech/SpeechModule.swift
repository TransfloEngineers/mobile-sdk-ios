class SpeechModule: Module {
    var speechEngine: SpeechEngine!
    
    init() {
        self.speechEngine = RealSpeechEngine()
        super.init(name: "speech")
        functions.append(NativeSpeakFunction(module: self))
    }
    
    func setSpeechEngine(speechEngine: SpeechEngine) {
        self.speechEngine = speechEngine
    }
}
