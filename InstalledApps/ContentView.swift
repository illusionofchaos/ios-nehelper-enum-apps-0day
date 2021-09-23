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

func isAppInstalled(bundleId: String) -> Bool {
    let connection = xpc_connection_create_mach_service("com.apple.nehelper", nil, 2)!
    xpc_connection_set_event_handler(connection, { _ in })
    xpc_connection_resume(connection)
    let xdict = xpc_dictionary_create(nil, nil, 0)
    xpc_dictionary_set_uint64(xdict, "delegate-class-id", 1)
    xpc_dictionary_set_uint64(xdict, "cache-command", 3)
    xpc_dictionary_set_string(xdict, "cache-signing-identifier", bundleId)
    let reply = xpc_connection_send_message_with_reply_sync(connection, xdict)
    if let resultData = xpc_dictionary_get_value(reply, "result-data"), xpc_dictionary_get_value(resultData, "cache-app-uuid") != nil {
        return true
    }
    return false
}
