import Foundation
import CoreLocation

// ============================================================
// TaskService — taken ophalen, aanmaken en statusupdates
// Alle functies zijn stubs; vervang TODO's met echte Supabase-queries
// ============================================================

final class TaskService {

    // MARK: - Open taken ophalen (voor buddy kaart)

    func fetchOpenTasks(maxLevel: Int) async throws -> [DBTask] {
        // TODO[real-integration]:
        /*
        let tasks: [DBTask] = try await supabase
            .from("tasks")
            .select()
            .eq("status", value: "open")
            .lte("required_level", value: maxLevel)
            .order("created_at", ascending: false)
            .execute()
            .value
        return tasks
        */
        return []   // stub — app gebruikt MockData.openTasks in demo-modus
    }

    // MARK: - Taak aanmaken (door elderly of familie)

    func createTask(
        elderlyId: String,
        category: String,
        requiredLevel: Int,
        timingType: String,
        scheduledAt: Date?,
        note: String,
        priceCents: Int
    ) async throws -> DBTask? {
        // TODO[real-integration]:
        /*
        let task: DBTask = try await supabase
            .from("tasks")
            .insert([
                "elderly_id":     elderlyId,
                "category":       category,
                "required_level": requiredLevel,
                "timing_type":    timingType,
                "scheduled_at":   scheduledAt?.iso8601,
                "note":           note,
                "price_cents":    priceCents
            ])
            .select()
            .single()
            .execute()
            .value
        return task
        */
        print("[TaskService] createTask stub")
        return nil
    }

    // MARK: - Taak accepteren (buddy)

    func acceptTask(taskId: String, buddyId: String, etaMinutes: Int) async throws {
        // TODO[real-integration]:
        /*
        try await supabase
            .from("tasks")
            .update([
                "status":              "accepted",
                "assigned_buddy_id":   buddyId,
                "accepted_at":         Date().iso8601,
                "buddy_eta_minutes":   etaMinutes
            ])
            .eq("id", value: taskId)
            .execute()
        */
        print("[TaskService] acceptTask stub — taskId: \(taskId)")
    }

    // MARK: - Buddy aankomst registreren

    func markArrived(taskId: String) async throws {
        // TODO[real-integration]:
        /*
        try await supabase
            .from("tasks")
            .update(["status": "arrived", "arrived_at": Date().iso8601])
            .eq("id", value: taskId)
            .execute()
        */
        print("[TaskService] markArrived stub")
    }

    // MARK: - Taak afronden

    func completeTask(taskId: String, buddyId: String, note: String, amountCents: Int, elderlyName: String, category: String) async throws {
        // TODO[real-integration]:
        /*
        // Update taak
        try await supabase
            .from("tasks")
            .update([
                "status":           "completed",
                "completed_at":     Date().iso8601,
                "completion_note":  note
            ])
            .eq("id", value: taskId)
            .execute()

        // Verdienstrecord aanmaken (80% van price_cents)
        try await supabase
            .from("earnings")
            .insert([
                "buddy_id":     buddyId,
                "task_id":      taskId,
                "elderly_name": elderlyName,
                "category":     category,
                "amount_cents": amountCents
            ])
            .execute()
        */
        print("[TaskService] completeTask stub")
    }

    // MARK: - Verdiensten ophalen

    func fetchEarnings(buddyId: String) async throws -> [DBEarning] {
        // TODO[real-integration]:
        /*
        let earnings: [DBEarning] = try await supabase
            .from("earnings")
            .select()
            .eq("buddy_id", value: buddyId)
            .order("created_at", ascending: false)
            .execute()
            .value
        return earnings
        */
        return []
    }

    // MARK: - Realtime taakupdates (voor live statuswijzigingen op kaart)

    func subscribeToTaskUpdates(elderlyId: String, onUpdate: @escaping (DBTask) -> Void) {
        // TODO[real-integration]:
        /*
        let channel = supabase.channel("tasks:\(elderlyId)")
        channel.on(.postgresChanges(
            event: .update,
            schema: "public",
            table: "tasks",
            filter: "elderly_id=eq.\(elderlyId)"
        )) { payload in
            if let task = try? payload.decodeRecord(as: DBTask.self) {
                onUpdate(task)
            }
        }
        channel.subscribe()
        */
        print("[TaskService] subscribeToTaskUpdates stub")
    }
}
