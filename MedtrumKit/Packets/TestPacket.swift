struct TestPacketResponse {}

class TestPacket: MedtrumBasePacket, MedtrumBasePacketProtocol  {
    typealias T = TestPacketResponse
    
    let commandType: UInt8 = CommandType.TEST
    
    let mimimumDataSize: Int = 0
    
    func getRequestBytes() -> Data {
        return Data([3, 4, 5])
    }
    
    func parseResponse() -> TestPacketResponse {
        return TestPacketResponse()
    }
}
