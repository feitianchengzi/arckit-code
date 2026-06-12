import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Hello, {{PROJECT_NAME}}!")
            .foregroundColor(Color.pink)
            .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
