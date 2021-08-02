import Foundation
import Config
import Networking

struct OneTimePassword: NetworkingRequest {
    struct Body: Encodable {
        let email: String
        let passcode: String?
        let loginToken: String?
        let phone: String?
    }
    
    struct Response: Decodable {
        let phoneLastDigits: String
    }
    
    let environment: Environment
    let email: String
    let passcode: String
    var loginToken: String? = nil
    var phone: String? = nil
    
    var payload: RequestType<Body> {
        .post(body: Body.init(
                email: email,
                passcode: passcode,
                loginToken: loginToken,
                phone: phone)
        )
    }
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/otp"
    }
}
