import SwiftUI
import beyondtranslate_runtime

@MainActor
final class ProviderDetailViewModel: ObservableObject {
  @Published var providers: [ProviderConfigEntry] = []
  @Published var services: [ServiceConfigEntry] = []
  @Published var errorMessage: String?
  @Published private(set) var pendingPresentProviderEditorSheetID: Int? = nil
  @Published private(set) var modelsByProviderId: [String: [String]] = [:]

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    self.repository = repository
  }

  // MARK: - Load

  func load() async {
    do {
      providers = try await repository.listProviders()
        .sorted { lhs, rhs in
          switch (lhs.createdAt, rhs.createdAt) {
          case (let l?, let r?): return l < r
          case (nil, _): return false
          case (_?, nil): return true
          }
        }
      services = try await repository.listServices()
        .sorted { $0.id < $1.id }
    } catch {
      // Keep whatever state we have; errors are non-fatal for the list view.
      errorMessage = error.localizedDescription
    }
  }

  // MARK: - Toggle

  func isProviderEnabled(_ id: String) -> Bool {
    !repository.disabledProviderIDs().contains(id)
  }

  func toggleProvider(_ id: String, isEnabled: Bool) {
    repository.setProviderEnabled(id, isEnabled: isEnabled)
    objectWillChange.send()
  }

  // MARK: - Generate ID

  func generateProviderId(for providerType: ProviderType) async -> String {
    (try? await repository.generateProviderId(providerType: providerType)) ?? providerType.wireValue
  }

  // MARK: - Save (add or edit)

  func requestPresentProviderEditorSheet() {
    pendingPresentProviderEditorSheetID = (pendingPresentProviderEditorSheetID ?? 0) + 1
  }

  func consumePresentProviderEditorSheet(_ id: Int) -> Bool {
    guard pendingPresentProviderEditorSheetID == id else { return false }
    pendingPresentProviderEditorSheetID = nil
    return true
  }

  func saveProvider(_ entry: ProviderConfigEntry) {
    Task {
      do {
        try await repository.updateProvider(
          id: entry.id,
          providerType: entry.type,
          fields: entry.fields
        )
        await load()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  // MARK: - List Models

  func listModels(for providerId: String) async -> [String] {
    do {
      let models = try await repository.listModels(providerId: providerId)
      modelsByProviderId[providerId] = models
      return models
    } catch {
      errorMessage = error.localizedDescription
      return []
    }
  }

  // MARK: - Delete

  func deleteProvider(_ id: String) {
    Task {
      do {
        _ = try await repository.deleteProvider(id: id)
        await load()
        // Clean up disabled state so re-adding the same ID starts fresh.
        repository.setProviderEnabled(id, isEnabled: true)
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }
}
