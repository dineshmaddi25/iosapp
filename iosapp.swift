import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: 
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: 
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedTab: String = "Top Links"
    @State private var searchText: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    VStack(spacing: -20) {
                        ZStack {
                            Color(hex: "006AF9")
                                .frame(height: 90)
                                .edgesIgnoringSafeArea(.top)
                                .padding(.bottom, 40)
                            HStack {
                                Text("Dashboard").bold()
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Image(systemName: "gear")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                            .padding(.horizontal)
                            .padding(.top, -30)
                            .padding(.top, 1)
                        }

                        VStack(alignment: .leading) {
                            Text("Good night")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, -50)
                            HStack {
                                Text("Ajay Manva")
                                    .font(.title)
                                    .bold()
                                    .padding(.top, -40)
                                Text("👏")
                                    .font(.title)
                                    .padding(.top, -40)
                            }
                            .padding(.bottom, 10)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    VStack {
                                        Text("Overview")
                                            .bold()
                                            .padding(.top, 10)
                                        Spacer()
                                        GeometryReader { geometry in
                                            Path { path in
                                                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                                                path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 3))
                                                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 1.5))
                                            }
                                            .stroke(Color.blue, lineWidth: 2)
                                        }
                                        .padding(.horizontal)
                                        Spacer()
                                    }
                                )
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)

                        HStack {
                            SummaryItem(title: "\(viewModel.dashboardData?.data.today_clicks ?? 123)", subtitle: "Today's clicks", symbolName: "cursorarrow.click", symbolColor: Color.purple.opacity(0.5), bgColor: Color.white)
                            SummaryItem(title: viewModel.dashboardData?.top_location ?? "Ahamadhabad", subtitle: "Top Location", symbolName: "location", symbolColor: .green, bgColor: .white)
                            SummaryItem(title: viewModel.dashboardData?.top_source ?? "Instagram", subtitle: "Top source", symbolName: "globe", symbolColor: .purple, bgColor: .blue.opacity(0.1))
                        }
                        .padding(.horizontal)

                        Button(action: {
                            // Action for button
                        }) {
                            Text("View Analytics")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 20)

                        VStack(alignment: .leading) {
                            HStack {
                                Button(action: {
                                    selectedTab = "Top Links"
                                }) {
                                    Text("Top Links")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedTab == "Top Links" ? Color.blue : Color.blue.opacity(0.5))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    selectedTab = "Recent Links"
                                }) {
                                    Text("Recent Links")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedTab == "Recent Links" ? Color.blue : Color.blue.opacity(0.5))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Spacer()

                                HStack {
                                    TextField("Search", text: $searchText)
                                        .padding(7)
                                        .padding(.horizontal, 25)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .overlay(
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.gray)
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 8)

                                                if !searchText.isEmpty {
                                                    Button(action: {
                                                        self.searchText = ""
                                                    }) {
                                                        Image(systemName: "multiply.circle.fill")
                                                            .foregroundColor(.gray)
                                                            .padding(.trailing, 8)
                                                    }
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 10)
                                }
                            }
                            .padding(.bottom, 10)

                            if selectedTab == "Top Links" {
                                ForEach(viewModel.dashboardData?.data.top_links ?? []) { link in
                                    LinkItem(link: link)
                                }
                            } else {
                                ForEach(viewModel.dashboardData?.data.recent_links ?? []) { link in
                                    LinkItem(link: link)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 10) {
                        Button(action: {
                            // Action for button
                        }) {
                            Text("View All Links")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // Action for button
                        }) {
                            Text("Talk with Us")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // Action for button
                        }) {
                            Text("Frequently Asked Questions")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)

                    Spacer()
                }

                VStack(spacing: 0) {
                    HStack {
                        VStack {
                            Image(systemName: "link")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Links")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }

                        Spacer()

                        VStack {
                            Image(systemName: "book")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Books")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }

                        Spacer()

                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .offset(y: -30) 
                            Image(systemName: "plus")
                                .font(.title)
                                .offset(y: -30)
                                .foregroundColor(.white)
                        }
                        .overlay(
                            Text("Add")
                                .foregroundColor(.white)
                                .font(.footnote)
                        )

                        Spacer()

                        VStack {
                            Image(systemName: "megaphone")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Promote")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }

                        Spacer()

                        VStack {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Profile")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal,30)
                    .padding(.top,40)
                    .frame(height: -40)
                    .background(Color.gray)
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // Adjust for safe area insets
                    .edgesIgnoringSafeArea(.bottom)
                }
                
            }
            
        }
        .onAppear {
            viewModel.fetchData()
        }
        background(Color.gray.opacity(0.5))

    }

}

struct SummaryItem: View {
    let title: String
    let subtitle: String
    let symbolName: String
    let symbolColor: Color
    let bgColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: symbolName)
                    .foregroundColor(symbolColor)
                Spacer()
            }
            Text(title)
                .font(.title)
                .bold()
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(bgColor)
        .cornerRadius(10)
        .frame(width: 120, height: 100)
    }
}

struct LinkItem: View {
    let link: Link

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "link")
                    .font(.title)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(link.title)
                        .bold()
                    Text(link.times_ago)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(link.total_clicks) Clicks")
                    .bold()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack {
                VStack(alignment: .leading) {
                    Text(link.web_link)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIPasteboard.general.string = link.web_link
                            print("Copied link: \(link.web_link)")
                        }
                }
                Spacer()
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
                    .padding(.trailing)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.blue)
                    .background(Color.blue.opacity(0.1))
            )
        }
    }
}

class DashboardViewModel: ObservableObject {
    @Published var dashboardData: DashboardResponse?

    func fetchData() {
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let bearer = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXF"
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "Unable to decode data")
                    let decodedData = try JSONDecoder().decode(DashboardResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.dashboardData = decodedData
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}

struct DashboardResponse: Codable {
    let status: Bool
    let statusCode: Int
    let message: String
    let support_whatsapp_number: String?
    let extra_income: Double
    let total_links: Int
    let total_clicks: Int
    let today_clicks: Int
    let top_source: String
    let top_location: String
    let startTime: String
    let links_created_today: Int
    let applied_campaign: Int
    let data: DashboardData
}

struct DashboardData: Codable {
    let recent_links: [Link]
    let top_links: [Link]
    let overall_url_chart: [String: Int]
    let today_clicks: Int
}

struct Link: Codable, Identifiable {
    let id = UUID()
    let url_id: Int
    let web_link: String
    let smart_link: String
    let title: String
    let times_ago: String
    let created_at: String
    let total_clicks: Int
    let original_image: String
    let thumbnail: String
    let times: String
    let url_prefix: String
    let url_suffix: String
    let app: String

    enum CodingKeys: String, CodingKey {
        case url_id
        case web_link
        case smart_link
        case title
        case times_ago
        case created_at
        case total_clicks
        case original_image
        case thumbnail
        case times
        case url_prefix
        case url_suffix
        case app
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url_id = try container.decode(Int.self, forKey: .url_id)
        self.web_link = try container.decode(String.self, forKey: .web_link)
        self.smart_link = try container.decode(String.self, forKey: .smart_link)
        self.title = try container.decode(String.self, forKey: .title)
        self.times_ago = try container.decode(String.self, forKey: .times_ago)
        self.created_at = try container.decode(String.self, forKey: .created_at)
        self.total_clicks = try container.decode(Int.self, forKey: .total_clicks)
        self.original_image = try container.decode(String.self, forKey: .original_image)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.times = try container.decode(String.self, forKey: .times)
        self.url_prefix = try container.decode(String.self, forKey: .url_prefix)
        self.url_suffix = try container.decode(String.self, forKey: .url_suffix)
        self.app = try container.decode(String.self, forKey: .app)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}