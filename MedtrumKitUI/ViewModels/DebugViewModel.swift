import CoreBluetooth
import LoopKit

class DebugViewModel: ObservableObject {
    private let processQueue = DispatchQueue(label: "com.nightscout.medtrumkit.debugviewmodel")

    @Published var pumpBaseSN = ""
    @Published var hasPumpBaseSN: Bool
    @Published var isPresentingPumpBaseSN = false

    private let log = MedtrumLogger(category: "DebugView")
    private var pumpManager: MedtrumPumpManager?

    var foundPeripheral: CBPeripheral?

    init(_ pumpManager: MedtrumPumpManager? = nil) {
        self.pumpManager = pumpManager

        guard let pumpManager = self.pumpManager else {
            hasPumpBaseSN = false
            return
        }

        hasPumpBaseSN = pumpManager.state.pumpSN.count == 4
        pumpBaseSN = pumpManager.state.pumpSN.hexEncodedString()

        pumpManager.addStatusObserver(self, queue: processQueue)
    }

    func setPumpBase() {
        isPresentingPumpBaseSN = true
    }

    func setPumpBaseAction() {
        guard let pumpManager = self.pumpManager else {
            log.error("No pump manager available")
            return
        }

        guard pumpBaseSN.count == 8, let sn = Data(hex: pumpBaseSN) else {
            log.error("Invalid pump base SN")
            return
        }

        pumpManager.state.pumpSN = sn
        pumpManager.notifyStateDidChange()
    }

    func prime() {
        guard let pumpManager = self.pumpManager else {
            log.error("No pump manager available")
            return
        }

        pumpManager.primePatch { result in
            if case .failure = result {
                return
            }
        }
    }

    func activate() {
        guard let pumpManager = self.pumpManager else {
            log.error("No pump manager available")
            return
        }

        pumpManager.activatePatch { _ in
        }
    }

    func connect() {
        guard let pumpManager = self.pumpManager else {
            log.error("No pump manager available")
            return
        }

        pumpManager.bluetooth.ensureConnected { result in
            switch result {
            case let .failure(error):
                self.log.error(error.localizedDescription)
                return
            case .success:
                self.log.info("Connected")
                // TODO: Continue journey here
            }
        }
    }

    func getLogs() -> [URL] {
        log.getDebugLogs()
    }
}

extension DebugViewModel: PumpManagerStatusObserver {
    func pumpManager(
        _ pumpManager: any LoopKit.PumpManager,
        didUpdate _: LoopKit.PumpManagerStatus,
        oldStatus _: LoopKit.PumpManagerStatus
    ) {
        guard let pumpManager = pumpManager as? MedtrumPumpManager else {
            log.error("Couldnt cast pumpManager")
            return
        }

        DispatchQueue.main.async {
            self.hasPumpBaseSN = pumpManager.state.pumpSN.count == 4
        }
    }
}
