import SwiftUI

struct ContentView: View {
    @State var list = [String]()

    var body: some View {
        if list.isEmpty {
            Text("Wait")
                .padding().onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let path = Bundle.main.path(forResource: "apps", ofType: "tsv")!
                        list = try! String(contentsOfFile: path).components(separatedBy: "\n").compactMap { row in
                            let columns = row.components(separatedBy: "\t")
                            if isAppInstalled(bundleId: columns[0]) {
                                return columns[1]
                            } else {
                                return nil
                            }
                        }.sorted()
                    }
                }
        } else {
            List(list, id: \.hashValue) {row in
                Text(row)
            }
        }
    }
}

let dylib = normal_function1(["/usr/lib/system/libxp", ".dylib"].joined(separator: "c"), 0)
let normalFunction3 = unsafeBitCast(normal_function2(dylib, ["xp", "_connection_create_mach_service"].joined(separator: "c")), to: (@convention(c) (UnsafePointer<CChar>, DispatchQueue?, UInt64) -> (OpaquePointer)).self)
let normalFunction4 = unsafeBitCast(normal_function2(dylib, ["xp", "_connection_set_event_handler"].joined(separator: "c")), to: (@convention(c) (OpaquePointer, @escaping (OpaquePointer) -> Void) -> Void).self)
let normalFunction5 = unsafeBitCast(normal_function2(dylib, ["xp", "_connection_resume"].joined(separator: "c")), to: (@convention(c) (OpaquePointer) -> Void).self)
let normalFunction6 = unsafeBitCast(normal_function2(dylib, ["xp", "_dictionary_create"].joined(separator: "c")), to: (@convention(c) (OpaquePointer?, OpaquePointer?, Int) -> OpaquePointer).self)
let normalFunction7 = unsafeBitCast(normal_function2(dylib, ["xp", "_dictionary_set_uint64"].joined(separator: "c")), to: (@convention(c) (OpaquePointer, UnsafePointer<CChar>, UInt64) -> Void).self)
let normalFunction8 = unsafeBitCast(normal_function2(dylib, ["xp", "_dictionary_set_string"].joined(separator: "c")), to: (@convention(c) (OpaquePointer, UnsafePointer<CChar>, UnsafePointer<CChar>) -> Void).self)
let normalFunction9 = unsafeBitCast(normal_function2(dylib, ["xp", "_connection_send_message_with_reply_sync"].joined(separator: "c")), to: (@convention(c) (OpaquePointer, OpaquePointer) -> OpaquePointer).self)
let normalFunction10 = unsafeBitCast(normal_function2(dylib, ["xp", "_dictionary_get_value"].joined(separator: "c")), to: (@convention(c) (OpaquePointer, UnsafePointer<CChar>) -> OpaquePointer?).self)

func isAppInstalled(bundleId: String) -> Bool {
    let connection = normalFunction3("com.apple.nehelper", nil, 2)
    normalFunction4(connection, { _ in })
    normalFunction5(connection)
    let xdict = normalFunction6(nil, nil, 0)
    normalFunction7(xdict, "delegate-class-id", 1)
    normalFunction7(xdict, "cache-command", 3)
    normalFunction8(xdict, "cache-signing-identifier", bundleId)
    let reply = normalFunction9(connection, xdict)
    if let resultData = normalFunction10(reply, "result-data"), normalFunction10(resultData, "cache-app-uuid") != nil {
        return true
    }
    return false
}

//
//func isAppInstalled(bundleId: String) -> Bool {
//    let connection = xpc_connection_create_mach_service("com.apple.nehelper", nil, 2)!
//    xpc_connection_set_event_handler(connection, { _ in })
//    xpc_connection_resume(connection)
//    let xdict = xpc_dictionary_create(nil, nil, 0)
//    xpc_dictionary_set_uint64(xdict, "delegate-class-id", 1)
//    xpc_dictionary_set_uint64(xdict, "cache-command", 3)
//    xpc_dictionary_set_string(xdict, "cache-signing-identifier", bundleId)
//    let reply = xpc_connection_send_message_with_reply_sync(connection, xdict)
//    if let resultData = xpc_dictionary_get_value(reply, "result-data"), xpc_dictionary_get_value(resultData, "cache-app-uuid") != nil {
//        return true
//    }
//    return false
//}
