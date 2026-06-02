import SwiftUI
import beyondtranslate_runtime

// MARK: - Service Detail View (Edit existing service)

struct ServiceDetailView: View {
  let service: ServiceConfigEntry
  @ObservedObject var viewModel: ProvidersViewModel

  @Environment(\.dismiss) private var dismiss

  @State private var editedFields: [String: String] = [:]
  @State private var editedName: String = ""
  @State private var hasChanges = false
  @State private var showDeleteConfirm = false

  /// The parent provider for this service.
  private var currentProvider: ProviderConfigEntry? {
    viewModel.providers.first(where: { $0.id == service.providerId })
  }

  private var providerIsLlm: Bool {
    currentProvider?.type.isLlm ?? false
  }

  private var serviceType: ServiceType { service.type }

  private var configFields: [ServiceConfigField] {
    ServiceType.configFields(for: serviceType, providerIsLlm: providerIsLlm)
  }

  private var displayTitle: String {
    let displayService = ServiceConfigEntry(
      id: service.id,
      providerId: service.providerId,
      type: service.type,
      name: editedName,
      fields: service.fields,
      createdAt: service.createdAt
    )
    return serviceDisplayName(displayService, provider: currentProvider)
  }

  private var serviceTypeDisplayName: String {
    localizedServiceTypeName(serviceType)
  }

  private var providerDisplayName: String {
    currentProvider?.type.displayName ?? service.providerId
  }

  private var canSave: Bool {
    !editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var body: some View {
    SettingsPage(title: displayTitle) {
      // ── Service Name ──────────────────────────────────────────
      Section {
        TextField(
          text: $editedName,
          prompt: Text(LocaleKeys.settings.providers.editor.placeholder.id.tr())
        ) {
          Text(LocaleKeys.settings.services.detail.row.name.tr())
        }
        .onChange(of: editedName) { _ in hasChanges = true }

        // Provider (read-only)
        HStack {
          Text(LocaleKeys.settings.services.detail.row.provider.tr())
          Spacer()
          Text(providerDisplayName)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }

        // Service type (read-only)
        HStack {
          Text(LocaleKeys.settings.services.detail.row.type.tr())
          Spacer()
          Text(serviceTypeDisplayName)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
      }

      // ── Config Fields ─────────────────────────────────────────
      if !configFields.isEmpty {
        Section(LocaleKeys.settings.providers.detail.section.configuration.tr()) {
          ForEach(configFields) { fieldDef in
            ServiceConfigFieldRow(fieldDef: fieldDef, text: fieldBinding(fieldDef.key))
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .automatic) {
        Button(role: .destructive) {
          showDeleteConfirm = true
        } label: {
          Text(LocaleKeys.common.ui.button.delete.tr())
        }
      }

      ToolbarItem(placement: .primaryAction) {
        Button(LocaleKeys.common.ui.button.save.tr()) {
          saveChanges()
        }
        .disabled(!canSave || !hasChanges)
      }
    }
    .onAppear {
      editedFields = service.fields
      editedName = serviceReadableName(service)
    }
    .confirmationDialog(
      LocaleKeys.settings.services.detail.deleteDialog.title.tr(displayTitle),
      isPresented: $showDeleteConfirm,
      titleVisibility: .visible
    ) {
      Button(LocaleKeys.common.ui.button.delete.tr(), role: .destructive) {
        viewModel.deleteService(service.id)
        dismiss()
      }
      Button(LocaleKeys.common.ui.button.cancel.tr(), role: .cancel) {}
    } message: {
      Text(LocaleKeys.settings.services.detail.deleteDialog.message.tr())
    }
  }

  // MARK: - Field Binding

  private func fieldBinding(_ key: String) -> Binding<String> {
    Binding(
      get: { editedFields[key] ?? "" },
      set: {
        editedFields[key] = $0
        hasChanges = true
      }
    )
  }

  // MARK: - Save

  private func saveChanges() {
    let trimmedName = editedName.trimmingCharacters(in: .whitespaces)
    let updatedEntry = ServiceConfigEntry(
      id: service.id,
      providerId: service.providerId,
      type: service.type,
      name: trimmedName.isEmpty ? serviceReadableName(service) : trimmedName,
      fields: editedFields,
      createdAt: service.createdAt
    )
    viewModel.saveService(updatedEntry)
    hasChanges = false
  }
}

// MARK: - Service Config Field Row

struct ServiceConfigFieldRow: View {
  let fieldDef: ServiceConfigField
  let text: Binding<String>

  var body: some View {
    if fieldDef.key == "systemPrompt" {
      // Multi-line text field for system prompt
      VStack(alignment: .leading, spacing: 4) {
        Text(fieldDef.label)
          .font(.system(size: 11))
          .foregroundStyle(.secondary)

        TextEditor(text: text)
          .font(.system(size: 12))
          .frame(minHeight: 80, maxHeight: 150)
          .overlay(
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
          )

        Text(LocaleKeys.settings.services.detail.promptVariables.tr())
          .font(.system(size: 10))
          .foregroundStyle(.tertiary)
      }
    } else if fieldDef.isSecret {
      SecureField(text: text, prompt: promptText) {
        rowLabel
      }
    } else {
      TextField(text: text, prompt: promptText) {
        rowLabel
      }
    }
  }

  private var rowLabel: some View {
    HStack(spacing: 0) {
      if !fieldDef.isOptional {
        Text("*")
          .foregroundStyle(.red)
          .padding(.trailing, 2)
      }
      Text(fieldDef.label)
    }
  }

  private var promptText: Text? {
    fieldDef.placeholder.isEmpty ? nil : Text(fieldDef.placeholder)
  }
}
