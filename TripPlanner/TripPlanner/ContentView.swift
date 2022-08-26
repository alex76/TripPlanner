import DesignSystem
import SwiftUI

struct ContentView: View {
    var body: some View {

        TextView(localizedEnum: Resource.Text.greeting)
            .foregroundColor(Color(from: .black))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
