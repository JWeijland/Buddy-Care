import Foundation
import Supabase

final class ProfileService {

    func fetchProfile(userId: UUID) async throws -> DBProfile {
        try await supabase
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
    }

    func fetchBuddyProfile(userId: UUID) async throws -> DBBuddyProfile {
        try await supabase
            .from("buddy_profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
    }

    func fetchElderlyProfile(userId: UUID) async throws -> DBElderlyProfile {
        try await supabase
            .from("elderly_profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
    }

    func updateBuddyAvailability(buddyId: UUID, isAvailable: Bool) async throws {
        try await supabase
            .from("buddy_profiles")
            .update(["is_available_now": isAvailable])
            .eq("id", value: buddyId.uuidString)
            .execute()
    }
}
