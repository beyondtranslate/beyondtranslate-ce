import SwiftUI
import beyondtranslate_runtime

/// A unified row that displays a service with a colored type icon and name.
///
/// Used in both the Services settings page and the Provider detail page.
struct ServiceRowView: View {
  let service: ServiceConfigEntry
  let provider: ProviderConfigEntry?
  var showsProviderName = true

  var body: some View {
    HStack(spacing: 10) {
      // Colored icon based on service type
      ZStack {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(serviceTypeColor.opacity(0.15))
        Image(systemName: serviceTypeSystemImage)
          .font(.system(size: 11, weight: .medium))
          .foregroundStyle(serviceTypeColor)
      }
      .frame(width: 20, height: 20)

      Text(displayName)
        .font(.system(size: 13))
        .foregroundStyle(.primary)
        .lineLimit(1)

      Spacer()
    }
  }

  // MARK: - Service Type Helpers

  private var displayName: String {
    guard showsProviderName else {
      return serviceReadableName(service)
    }
    return serviceDisplayName(service, provider: provider)
  }

  private var serviceTypeColor: Color {
    switch service.type {
    case .translation: return .blue
    case .ocr: return .green
    case .llm: return .purple
    default: return .gray
    }
  }

  private var serviceTypeSystemImage: String {
    switch service.type {
    case .translation: return "character.bubble"
    case .ocr: return "text.viewfinder"
    case .llm: return "sparkles"
    default: return "questionmark"
    }
  }

  private var serviceTypeDisplayName: String {
    localizedServiceTypeName(service.type)
  }
}

func serviceDisplayName(_ service: ServiceConfigEntry, provider: ProviderConfigEntry?) -> String {
  let providerName = provider?.type.displayName ?? service.providerId
  return "\(providerName)/\(serviceReadableName(service))"
}

func serviceReadableName(_ service: ServiceConfigEntry) -> String {
  let trimmedName = service.name.trimmingCharacters(in: .whitespacesAndNewlines)
  if !trimmedName.isEmpty && trimmedName != service.id && trimmedName != service.providerId {
    return trimmedName
  }
  return localizedServiceTypeName(service.type)
}

func localizedServiceTypeName(_ type: ServiceType) -> String {
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
