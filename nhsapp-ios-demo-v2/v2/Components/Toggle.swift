import SwiftUI

struct NHSToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.body)
                .foregroundStyle(Color("NHSBlack"))
            Spacer()
            Toggle("", isOn: configuration.$isOn)
                .labelsHidden()
                .tint(Color("NHSGreen"))
        }
    }
}
