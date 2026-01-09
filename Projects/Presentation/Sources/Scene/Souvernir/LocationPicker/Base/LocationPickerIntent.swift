import CoreLocation
import Foundation

enum LocationPickerAction {
    case tapBack
    case detailTextChanged(String)
    case tapComplete(CLLocationCoordinate2D)
}

struct LocationPickerState {
    var detailText: String = ""
}

enum LocationPickerEvent {}
