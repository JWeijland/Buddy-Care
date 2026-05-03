import Foundation
// import Supabase   // TODO[real-integration]: uncomment na package installatie

// ============================================================
// AuthService — vervangt de mock rol-selectie met echte auth
// Momenteel: stub functies die je stap voor stap vervangt
// ============================================================

@Observable
final class AuthService {

    var isLoading: Bool = false
    var errorMessage: String? = nil
    var currentUserId: String? = nil

    // MARK: - Registratie

    /// Registreer een nieuwe gebruiker. Role wordt als metadata meegestuurd
    /// zodat de database-trigger automatisch het juiste profiel aanmaakt.
    func signUp(
        email: String,
        password: String,
        role: String,           // "elderly" | "buddy" | "family"
        firstName: String,
        lastName: String,
        phoneNumber: String? = nil
    ) async throws {
        isLoading = true
        defer { isLoading = false }

        // TODO[real-integration]: Vervang stub door echte Supabase-aanroep:
        /*
        let metadata: [String: AnyJSON] = [
            "role":        .string(role),
            "first_name":  .string(firstName),
            "last_name":   .string(lastName)
        ]
        let response = try await supabase.auth.signUp(
            email: email,
            password: password,
            data: metadata,
            phone: phoneNumber
        )
        currentUserId = response.user?.id.uuidString
        */

        // Stub voor demo:
        print("[AuthService] signUp stub — email: \(email), role: \(role)")
        currentUserId = UUID().uuidString
    }

    // MARK: - Inloggen

    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }

        // TODO[real-integration]:
        /*
        let session = try await supabase.auth.signIn(email: email, password: password)
        currentUserId = session.user.id.uuidString
        */

        print("[AuthService] signIn stub — email: \(email)")
        currentUserId = UUID().uuidString
    }

    // MARK: - SMS OTP (voor ouderen — makkelijker dan e-mail)

    func sendOTP(phoneNumber: String) async throws {
        // TODO[real-integration]:
        /*
        try await supabase.auth.signInWithOTP(phone: phoneNumber)
        */
        print("[AuthService] sendOTP stub — phone: \(phoneNumber)")
    }

    func verifyOTP(phoneNumber: String, token: String) async throws {
        // TODO[real-integration]:
        /*
        let session = try await supabase.auth.verifyOTP(
            phone: phoneNumber,
            token: token,
            type: .sms
        )
        currentUserId = session.user.id.uuidString
        */
        print("[AuthService] verifyOTP stub — token: \(token)")
        currentUserId = UUID().uuidString
    }

    // MARK: - Apple Sign-In

    func signInWithApple(identityToken: String) async throws {
        // TODO[real-integration]:
        /*
        let session = try await supabase.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: identityToken)
        )
        currentUserId = session.user.id.uuidString
        */
        print("[AuthService] signInWithApple stub")
        currentUserId = UUID().uuidString
    }

    // MARK: - Uitloggen

    func signOut() async throws {
        // TODO[real-integration]:
        /*
        try await supabase.auth.signOut()
        */
        currentUserId = nil
        print("[AuthService] signOut stub")
    }

    // MARK: - Sessie herstellen bij app-start

    func restoreSession() async {
        // TODO[real-integration]:
        /*
        if let session = try? await supabase.auth.session {
            currentUserId = session.user.id.uuidString
        }
        */
        print("[AuthService] restoreSession stub")
    }
}
