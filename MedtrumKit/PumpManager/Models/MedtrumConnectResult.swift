public enum MedtrumConnectResult {
    case success
    case failure(error: MedtrumConnectError)
}

public enum MedtrumConnectError: LocalizedError {
    case failedToDiscoverServices(localizedError: String)
    case failedToDiscoverCharacteristics(localizedError: String)
    case failedToEnableNotify(localizedError: String)
    case failedToCompleteAuthorizationFlow(localizedError: String)
    case failedToFindDevice

    public var errorDescription: String? {
        switch self {
        case let .failedToDiscoverServices(localizedErr):
            return localizedErr
        case let .failedToDiscoverCharacteristics(localizedErr):
            return localizedErr
        case let .failedToEnableNotify(localizedErr):
            return localizedErr
        case let .failedToCompleteAuthorizationFlow(localizedErr):
            return localizedErr
        case .failedToFindDevice:
            return "Failed to find device"
        }
    }
}
