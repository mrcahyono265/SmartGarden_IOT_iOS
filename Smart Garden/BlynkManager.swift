import Foundation

class BlynkManager: ObservableObject {
    let authToken = "MASUKKAN_TOKEN_DISINI"
    let server = "https://blynk.cloud/external/api"

    // 1. Fungsi Tulis Data
    func writePin(pin: String, value: String) {
        let safeValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
        guard let url = URL(string: "\(server)/update?token=\(authToken)&\(pin)=\(safeValue)") else { return }
        
        let task = URLSession.shared.dataTask(with: url)
        task.resume()
    }

    // 2. Fungsi Baca Data
    func readPin(pin: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(server)/get?token=\(authToken)&\(pin)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            var value = String(data: data, encoding: .utf8) ?? ""
            value = value.replacingOccurrences(of: "\"", with: "") // Hapus tanda kutip
            DispatchQueue.main.async {
                completion(value)
            }
        }
        task.resume()
    }
    
    // 3. FITUR BARU: Cek Apakah Alat Online/Offline
    func checkHardwareConnection(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(server)/isHardwareConnected?token=\(authToken)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            // Blynk membalas "true" atau "false"
            DispatchQueue.main.async {
                completion(responseString.contains("true"))
            }
        }
        task.resume()
    }
}
