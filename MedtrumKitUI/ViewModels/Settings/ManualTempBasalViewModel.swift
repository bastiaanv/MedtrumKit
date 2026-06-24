
class ManualTempBasalViewModel: ObservableObject {
    
    private let pumpManager: MedtrumPumpManager?
    init(pumpManager: MedtrumPumpManager?) {
        self.pumpManager = pumpManager
    }
}
