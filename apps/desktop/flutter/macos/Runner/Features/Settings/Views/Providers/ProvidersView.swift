import SwiftUI
import beyondtranslate_runtime

// MARK: - Navigation Destinations

private enum ProvidersNavigation: Hashable {
  case providerDetail(String)
  case createProvider(ProviderConfigEntry)
  case serviceDetail(String)
}

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel

  @State private var showTypePicker = false
  @State private var navPath: [ProvidersNavigation] = []

  var body: some View {
    NavigationStack(path: $navPath) {
      SettingsPage(title: LocaleKeys.settings.providers.title.tr()) {
        // ── Provider List ─────────────────────────────────────────
        Section {
          if viewModel.providers.isEmpty {
            EmptyProviderRow()
          } else {
            ForEach(viewModel.providers) { provider in
              ProviderRow(
                provider: provider,
                services: viewModel.services.filter { $0.providerId == provider.id },
                onDelete: { viewModel.deleteProvider(provider.id) }
              )
            }
          }

          HStack {
            Spacer()
            Button(LocaleKeys.settings.providers.button.add.tr()) {
              showTypePicker = true
            }
          }
        } header: {
          ProviderListHeader()
        }

        // ── Available Services ────────────────────────────────────
        Section {
          ServiceGroupRow(
            title: LocaleKeys.settings.providers.capability.translation.tr()
          )

          if viewModel.translationServices.isEmpty {
            EmptyServicesRow()
          } else {
            ForEach(viewModel.translationServices) { service in
              NavigationLink(value: ProvidersNavigation.serviceDetail(service.id)) {
                ServiceRowView(
                  service: service,
                  provider: viewModel.providers.first { $0.id == service.providerId }
                )
              }
            }
          }

          ServiceGroupRow(
            title: LocaleKeys.settings.providers.capability.ocr.tr()
          )

          if viewModel.ocrServices.isEmpty {
            EmptyServicesRow()
          } else {
            ForEach(viewModel.ocrServices) { service in
              NavigationLink(value: ProvidersNavigation.serviceDetail(service.id)) {
                ServiceRowView(
                  service: service,
                  provider: viewModel.providers.first { $0.id == service.providerId }
                )
              }
            }
          }
        } header: {
          AvailableServicesHeader()
        }
      }
      .navigationDestination(for: ProvidersNavigation.self) { dest in
        switch dest {
        case .providerDetail(let providerID):
          if let provider = viewModel.providers.first(where: { $0.id == providerID }),
            let providerDetailViewModel = viewModel.providerDetailViewModel
          {
            ProviderDetailView(
              provider: provider,
              viewModel: providerDetailViewModel,
              providersViewModel: viewModel
            )
          }
        case .createProvider(let entry):
          if let providerDetailViewModel = viewModel.providerDetailViewModel {
            ProviderDetailView(
              provider: entry,
              viewModel: providerDetailViewModel,
              providersViewModel: viewModel,
              isCreating: true
            )
          }
        case .serviceDetail(let serviceID):
          if let service = viewModel.services.first(where: { $0.id == serviceID }) {
            ServiceDetailView(service: service, viewModel: viewModel)
          }
        }
      }
    }
    .onReceive(viewModel.$pendingPresentProviderEditorSheetID) { id in
      guard let id, viewModel.consumePresentProviderEditorSheet(id) else { return }
      showTypePicker = true
    }
    .sheet(isPresented: $showTypePicker) {
      ProviderTypePicker(
        onNext: { selectedType in
          Task {
            let id = await viewModel.generateProviderId(for: selectedType)
            let entry = ProviderConfigEntry(
              id: id, type: selectedType, fields: [:], createdAt: nil
            )
            showTypePicker = false
            navPath.append(ProvidersNavigation.createProvider(entry))
          }
        },
        onCancel: { showTypePicker = false }
      )
      .frame(width: 420)
    }
    .alert(
      LocaleKeys.settings.providers.alert.error.tr(),
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button(LocaleKeys.common.ui.button.ok.tr()) { viewModel.errorMessage = nil }
    } message: {
      if let msg = viewModel.errorMessage {
        Text(msg)
      }
    }
  }
}

// MARK: - Section Headers

private struct AvailableServicesHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.section.services.tr())

      Text(LocaleKeys.settings.providers.section.servicesDescription.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct ProviderListHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.title.tr())

      Text(LocaleKeys.settings.providers.intro.body.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct ServiceGroupRow: View {
  let title: String

  var body: some View {
    HStack {
      Text(title)
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.secondary)

      Spacer()
    }
    .contentShape(Rectangle())
  }
}

// MARK: - Provider Row (NavigationLink → ProviderDetailView)

private struct ProviderRow: View {
  let provider: ProviderConfigEntry
  let services: [ServiceConfigEntry]
  let onDelete: () -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    NavigationLink(value: ProvidersNavigation.providerDetail(provider.id)) {
      HStack(spacing: 14) {
        ProviderTypeIcon(providerType: provider.type)

        Text(provider.type.displayName)
          .font(.system(size: 13))
          .foregroundStyle(.primary)
          .lineLimit(1)

        Spacer()

        HStack(spacing: 6) {
          ForEach(serviceTypes, id: \.self) { type in
            ServiceTypeTag(title: serviceTypeDisplayName(type))
          }
        }
      }
      .contentShape(Rectangle())
    }
    .contextMenu {
      Button(LocaleKeys.common.ui.button.delete.tr(), role: .destructive) {
        showDeleteConfirm = true
      }
    }
    .confirmationDialog(
      LocaleKeys.settings.providers.deleteDialog.title.tr(provider.name),
      isPresented: $showDeleteConfirm,
      titleVisibility: .visible
    ) {
      Button(
        LocaleKeys.common.ui.button.delete.tr(), role: .destructive, action: onDelete)
      Button(LocaleKeys.common.ui.button.cancel.tr(), role: .cancel) {}
    } message: {
      Text(LocaleKeys.settings.providers.deleteDialog.message.tr())
    }
  }

  private var serviceTypes: [ServiceType] {
    var uniqueTypes: [ServiceType] = []
    for service in services where !uniqueTypes.contains(service.type) {
      uniqueTypes.append(service.type)
    }
    return uniqueTypes
  }

  private func serviceTypeDisplayName(_ type: ServiceType) -> String {
    switch type {
    case .translation:
      return LocaleKeys.settings.providers.capability.translation.tr()
    case .ocr:
      return LocaleKeys.settings.providers.capability.ocr.tr()
    case .llm:
      return "AI"
    case .dictionary:
      return LocaleKeys.settings.providers.capability.dictionary.tr()
    default:
      return ""
    }
  }
}

private struct ServiceTypeTag: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.system(size: 10, weight: .medium))
      .foregroundStyle(.secondary)
      .lineLimit(1)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(
        Capsule()
          .fill(Color.secondary.opacity(0.12))
      )
  }
}

// MARK: - Empty states

private struct EmptyServicesRow: View {
  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "bolt.horizontal.circle")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: 20, height: 20)
      Text(LocaleKeys.settings.providers.item.noServices.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}

private struct EmptyProviderRow: View {
  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "square.stack.3d.up.slash")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: 20, height: 20)
      Text(LocaleKeys.settings.providers.item.empty.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}
