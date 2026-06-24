import LoopKitUI
import SwiftUI

struct ManualTempBasalView : View {
    @ObservedObject var viewModel: ManualTempBasalViewModel
    
    var body : some View {
        VStack {
            List {
                HStack {
                    Text("Rate", comment: "Label text for basal rate summary")
                    Spacer()
                    Text(String(format: String(localized: "%@ for %@", comment: "Summary string for temporary basal rate configuration page"), formatRate(rateEntered), formatDuration(durationEntered)))
                }
                HStack {
                    ResizeablePicker(selection: $rateEntered,
                                     data: allowedRates,
                                     formatter: { formatRate($0) })
                    ResizeablePicker(selection: $durationEntered,
                                     data: Pod.supportedTempBasalDurations,
                                     formatter: { formatDuration($0) })
                }
                .frame(maxHeight: 162.0)
                Section {
                    Text("Loop will not automatically adjust your insulin delivery until the temporary basal rate finishes or is canceled.", comment: "Description text on manual temp basal action sheet")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Button(action: {}) {
                Text("Set Temporary Basal", comment: "Button text for setting manual temporary basal rate")
            }
            .buttonStyle(ActionButtonStyle(.primary))
            .padding()
        }
    }
}
