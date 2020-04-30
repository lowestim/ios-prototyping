
import Foundation

enum TransportType: CShort {

    case tcp = 0

    case udp = 1

}





func isUdpPortAvailable(port: UInt16) {

    

    //var socket = Socket(address: "0.0.0.0", port: port)

    

}



func isNetworkPortAvailable(port: in_port_t, transport: TransportType) -> Bool {

    

    let socketType = (transport == .tcp) ? SOCK_STREAM : SOCK_DGRAM

    let socketFileDescriptor = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)

    if socketFileDescriptor == -1 {

        print("[\(#function)] => 1 \(descriptionOfLastError())")

        return false

    }

    

    var addr = sockaddr_in()

    let sizeOfSockkAddr = MemoryLayout<sockaddr_in>.size

    addr.sin_len = __uint8_t(sizeOfSockkAddr)

    addr.sin_family = sa_family_t(AF_INET)

    addr.sin_port = Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port

    addr.sin_addr = in_addr(s_addr: inet_addr("0.0.0.0"))

    addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)

    

    //addr.ai_protocol = IPPROTO_UDP

    var bind_addr = sockaddr()

    memcpy(&bind_addr, &addr, Int(sizeOfSockkAddr))

    

    if Darwin.bind(socketFileDescriptor, &bind_addr, socklen_t(sizeOfSockkAddr)) == -1 {

        print("[\(#function)] => 2 \(descriptionOfLastError())")

        release(socket: socketFileDescriptor)

        return false

    }

    /*

    // if listen(socketFileDescriptor, SOMAXCONN ) == -1 {

    if listen(socketFileDescriptor, -1 ) == -1 {

        print("[\(#function)] => 3 \(descriptionOfLastError())")

        release(socket: socketFileDescriptor)

        return false

    }

    */

    release(socket: socketFileDescriptor)

    return true

}



func release(socket: Int32) {

    Darwin.shutdown(socket, SHUT_RDWR)

    close(socket)

}



func descriptionOfLastError() -> String {

    return String.init(cString: (UnsafePointer(strerror(errno))))

}





let portNum = 5353

let available = isNetworkPortAvailable(port: UInt16(portNum), transport: .udp)
print("\(portNum):\(available)")


/*

var portNum: UInt16 = 0

for i in 50003..<50050 {

    let isFree = isNetworkPortAvailable(port: UInt16(i), transport: .udp)

    if isFree == true {

        portNum = UInt16(i)

        break;

    }

}

*/







//let x = 3001234 % 4000
//print(x)
//for i in 1...5 {
//    let num = (arc4random() % 10000) + 10000
//    print("Random Number: \(num)")
//}
//
