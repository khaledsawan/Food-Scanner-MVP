import SwiftUI

struct ResultsView: View {
  let result: AIAnalysisResult

  var isSafe: Bool {
    result.isSafeForUser ?? false
  }

  var statusColor: Color {
    isSafe ? .green : .red
  }

  var body: some View {
    VStack(spacing: 0) {
      // Header
      HStack {
        Image(systemName: isSafe ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
          .font(.system(size: 32))
          .foregroundColor(.white)

        VStack(alignment: .leading, spacing: 2) {
          Text(isSafe ? "Safe to Eat" : "Avoid")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)

          if !isSafe {
            Text("Contains restricted ingredients")
              .font(.caption)
              .foregroundColor(.white.opacity(0.9))
          }
        }
        Spacer()
      }
      .padding()
      .background(statusColor)

      // Content
      VStack(alignment: .leading, spacing: 16) {

        // Critical Flags
        if result.containsPork == true || result.containsAlcohol == true {
          HStack(spacing: 12) {
            if result.containsPork == true {
              Label("Pork Detected", systemImage: "exclamationmark.triangle.fill")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }

            if result.containsAlcohol == true {
              Label("Alcohol Detected", systemImage: "drop.triangle.fill")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
          }
        }

        // Allergens Section
        if !result.allergens.isEmpty {
          VStack(alignment: .leading, spacing: 8) {
            Text("Allergens Found")
              .font(.headline)
              .foregroundColor(.primary)

            FlowLayout(spacing: 8) {
              ForEach(result.allergens, id: \.self) { allergen in
                Text(allergen)
                  .font(.caption)
                  .fontWeight(.medium)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 5)
                  .background(Color.red.opacity(0.1))
                  .foregroundColor(.red)
                  .cornerRadius(20)
                  .overlay(
                    RoundedRectangle(cornerRadius: 20)
                      .stroke(Color.red.opacity(0.3), lineWidth: 1)
                  )
              }
            }
          }
        }

        // Unsafe Ingredients Section
        if !result.unsafeIngredients.isEmpty {
          VStack(alignment: .leading, spacing: 8) {
            Text("Unsafe Ingredients")
              .font(.headline)
              .foregroundColor(.primary)

            ForEach(result.unsafeIngredients, id: \.self) { ingredient in
              HStack(spacing: 8) {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.red)
                  .font(.caption)
                Text(ingredient)
                  .font(.body)
                  .foregroundColor(.secondary)
              }
            }
          }
        }

        // Analysis Notes
        if !result.analysisNotes.isEmpty {
          VStack(alignment: .leading, spacing: 8) {
            Text("Analysis Notes")
              .font(.headline)
              .foregroundColor(.primary)

            Text(result.analysisNotes)
              .font(.subheadline)
              .foregroundColor(.secondary)
              .fixedSize(horizontal: false, vertical: true)
              .padding()
              .background(Color.gray.opacity(0.05))
              .cornerRadius(8)
          }
        }
      }
      .padding()
    }
    .background(Color(UIColor.systemBackground))
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(statusColor.opacity(0.3), lineWidth: 1)
    )
  }
}

// Helper for wrapping tags
struct FlowLayout: Layout {
  var spacing: CGFloat

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
    return rows.last?.maxY ?? .zero
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
    for row in rows {
      for element in row.elements {
        element.subview.place(
          at: CGPoint(x: bounds.minX + element.x, y: bounds.minY + element.y), proposal: proposal)
      }
    }
  }

  struct Row {
    var elements: [Element] = []
    var y: CGFloat = 0
    var height: CGFloat = 0
    var maxY: CGSize { CGSize(width: 0, height: y + height) }
  }

  struct Element {
    var subview: LayoutSubview
    var x: CGFloat
    var y: CGFloat
  }

  func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
    var rows: [Row] = []
    var currentRow = Row()
    var x: CGFloat = 0
    var y: CGFloat = 0
    let maxWidth = proposal.width ?? .infinity

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      if x + size.width > maxWidth && !currentRow.elements.isEmpty {
        currentRow.y = y
        rows.append(currentRow)
        y += currentRow.height + spacing
        x = 0
        currentRow = Row()
        currentRow.height = 0
      }

      currentRow.elements.append(Element(subview: subview, x: x, y: y))
      currentRow.height = max(currentRow.height, size.height)
      x += size.width + spacing
    }

    if !currentRow.elements.isEmpty {
      currentRow.y = y
      rows.append(currentRow)
    }

    return rows
  }
}
