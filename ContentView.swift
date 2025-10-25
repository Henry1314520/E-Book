import SwiftUI
import SafariServices // 為了 SFSafariViewController (WebView)

// MARK: - 資料模型
struct Author: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatar: String
    let bio: String
    let specialty: String
}

struct Novel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let author: Author
    let cover: String
    let description: String
    let chapters: [Chapter]
    let rating: Double
}

struct Chapter: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let title: String
    let content: String
}

// MARK: - 自訂 ViewModifier
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 15
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 15) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}

// MARK: - 範例資料
class BookStore{
    static let shared = BookStore()
    
    let martialAuthors = [
        Author(name: "金庸", avatar: "person.circle.fill", bio: "武俠小說泰斗，創作多部經典作品", specialty: "武俠"),
        Author(name: "古龍", avatar: "person.fill", bio: "以獨特文風著稱的武俠大師", specialty: "武俠"),
        Author(name: "梁羽生", avatar: "person.crop.circle", bio: "新派武俠小說開山祖師", specialty: "武俠")
    ]
    
    let romanceAuthors = [
        Author(name: "瓊瑤", avatar: "heart.circle.fill", bio: "言情小說天后，作品感人至深", specialty: "言情"),
        Author(name: "亦舒", avatar: "heart.fill", bio: "都會愛情小說代表作家", specialty: "言情"),
        Author(name: "席絹", avatar: "sparkles", bio: "校園言情小說經典作者", specialty: "言情")
    ]
    
    func getNovels(for author: Author) -> [Novel] {
        if author.specialty == "武俠" {
            return [
                Novel(title: "射鵰英雄傳", author: author, cover: "book.closed.fill",
                      description: "一代武俠經典，講述郭靖、黃蓉的江湖傳奇故事。從蒙古草原到中原武林，英雄豪傑輩出，俠義精神永存。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：風雪驚變", content: generateContent(chapter: $0)) },
                      rating: 4.9),
                Novel(title: "天龍八部", author: author, cover: "book.fill",
                      description: "金庸筆下最具史詩格局的武俠巨著，三位主角喬峰、段譽、虛竹各具特色，江湖恩怨糾葛不清。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：少年遊", content: generateContent(chapter: $0)) },
                      rating: 4.8),
                Novel(title: "笑傲江湖", author: author, cover: "books.vertical.fill",
                      description: "自由與權力的對抗，令狐沖與任盈盈的愛情故事，琴簫合奏笑傲江湖。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：滅門", content: generateContent(chapter: $0)) },
                      rating: 4.7)
            ]
        } else {
            return [
                Novel(title: "還珠格格", author: author, cover: "heart.text.square.fill",
                      description: "清朝乾隆年間，小燕子與紫薇的宮廷愛情故事，充滿歡笑與淚水。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：初入宮廷", content: generateContent(chapter: $0)) },
                      rating: 4.6),
                Novel(title: "梅花烙", author: author, cover: "heart.circle",
                      description: "刻骨銘心的愛情故事，梅花烙印見證永恆的愛與痛。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：相遇", content: generateContent(chapter: $0)) },
                      rating: 4.5),
                Novel(title: "喜寶", author: author, cover: "star.fill",
                      description: "現代都會女性的愛情與自我追尋，探討物質與精神的平衡。",
                      chapters: (1...5).map { Chapter(number: $0, title: "第\($0)章：抉擇", content: generateContent(chapter: $0)) },
                      rating: 4.4)
            ]
        }
    }
    
    private func generateContent(chapter: Int) -> String {
        """
        第 \(chapter) 章內容
        
        這是一個精彩的章節，充滿了戲劇性的情節發展。主角在這一章經歷了重大的轉折，命運的齒輪開始轉動。
        
        江湖風起雲湧，英雄輩出。在這個充滿傳奇的時代，每個人都有自己的故事要訴說。
        
        劍光劍影之間，是非恩怨難分。唯有俠義精神，永遠照亮前行的道路。
        
        待續...
        
        （完整內容請參閱實體書或官方電子版）
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        
        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
    }
}

// MARK: - 主視圖（含 Landing Page）
struct ContentView: View {
    @State private var showMainApp = false
    @State private var animateLogo = false
    
    var body: some View {
        Group {
            if showMainApp {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                LandingPageView(showMainApp: $showMainApp, animateLogo: $animateLogo)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showMainApp)
    }
}

// MARK: - Landing Page
struct LandingPageView: View {
    @Binding var showMainApp: Bool
    @Binding var animateLogo: Bool
    @State private var selectedFeature = 0
    @State private var showFeatures = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark ?
                    [Color.black, Color.purple.opacity(0.3), Color.blue.opacity(0.2)] :
                    [Color.white, Color.pink.opacity(0.1), Color.orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 35) {
                    Spacer(minLength: 40)
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: animateLogo ? 180 : 140, height: animateLogo ? 180 : 140)
                            .blur(radius: 20)
                            .opacity(0.6)
                        
                        Image(systemName: "books.vertical.fill")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .pink.opacity(0.5), radius: 20)
                            .scaleEffect(animateLogo ? 1.1 : 0.9)
                            .rotationEffect(.degrees(animateLogo ? 5 : -5))
                    }
                    .padding(.top, 30)
                    
                    VStack(spacing: 12) {
                        Text("E-Book 小說館")
                            .font(.custom("JasonHandwriting7p", size: 50))
                            .foregroundColor(.accentColor)
                            .offset(y: 80)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("武俠江湖 · 浪漫言情")
                            .font(.title3.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    .opacity(showFeatures ? 1 : 0)
                    .offset(y: showFeatures ? 0 : 20)
                    
                    // 水平滑動的分頁 (TabView)
                    TabView(selection: $selectedFeature) {
                        FeatureCard(
                            icon: "person.2.fill",
                            title: "武俠世界",
                            description: "刀光劍影，俠義江湖",
                            colors: [.orange, .red]
                        ).tag(0)
                        
                        FeatureCard(
                            icon: "heart.fill",
                            title: "浪漫言情",
                            description: "柔情似水，愛恨交織",
                            colors: [.pink, .purple]
                        ).tag(1)
                        
                        FeatureCard(
                            icon: "sparkles",
                            title: "精美設計",
                            description: "流暢動畫，極致體驗",
                            colors: [.blue, .cyan]
                        ).tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 240)
                    .opacity(showFeatures ? 1 : 0)
                    .offset(y: showFeatures ? 0 : 30)
                    
                    Button {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showMainApp = true
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Text("開始閱讀")
                                .font(.title3.weight(.semibold))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .pink.opacity(0.5), radius: 20, y: 10)
                    }
                    .opacity(showFeatures ? 1 : 0)
                    .scaleEffect(showFeatures ? 1 : 0.8)
                    
                    // 水平捲動的區塊 (ScrollView)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FeatureTag(icon: "moon.stars.fill", text: "深色模式")
                            FeatureTag(icon: "ipad.and.iphone", text: "多裝置支援")
                            FeatureTag(icon: "photo.stack.fill", text: "精美封面")
                            FeatureTag(icon: "bookmark.fill", text: "書籤功能")
                            FeatureTag(icon: "network", text: "網路圖片")
                        }
                        .padding(.horizontal)
                    }
                    .opacity(showFeatures ? 1 : 0)
                    
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateLogo = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                showFeatures = true
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let colors: [Color]
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(height: 220)
        .padding(.horizontal, 20)
        .shadow(color: colors[0].opacity(0.4), radius: 20, y: 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct FeatureTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

// MARK: - 主 TabView（支援 iPhone/iPad）
struct MainTabView: View {
    @State private var selection: Int? = 0
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var showAuthorSheet = false
    @State private var isDarkMode = false // 🌗 控制深淺模式

    private let allAuthors = BookStore.shared.martialAuthors + BookStore.shared.romanceAuthors

    var body: some View {
        Group {
            if sizeClass == .regular {
                // MARK: - iPad 模式（使用 NavigationSplitView）
                NavigationSplitView {
                    // --- 側邊欄 (Sidebar) ---
                    // 內容與之前相同
                    List(selection: $selection) {
                        Label("武俠小說", systemImage: "person.2.fill")
                            .tag(0 as Int?)
                        Label("言情小說", systemImage: "heart.fill")
                            .tag(1 as Int?)
                        Label("照片牆", systemImage: "photo.on.rectangle.angled")
                            .tag(2 as Int?)
                    }
                    .navigationTitle("E-Book")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            // ☰ 作者列表
                            Button {
                                showAuthorSheet.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal")
                            }

                            // 🌗 深淺模式切換
                            Button {
                                isDarkMode.toggle()
                            } label: {
                                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            }
                        }
                    }
                    .sheet(isPresented: $showAuthorSheet) {
                        // 彈窗內容不變 (使用 NavigationStack)
                        NavigationStack {
                            AuthorListView(authors: allAuthors, genre: "所有作者")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("關閉") {
                                            showAuthorSheet = false
                                        }
                                    }
                                }
                        }
                    }
                } detail: {
                    // --- 詳細視圖 (Detail) ---
                    // 🌟 關鍵修改：
                    // 1. 在此處添加 NavigationStack
                    // 2. 使用 .toolbar 將 Picker 放入
                    NavigationStack {
                        selectedView
                    }
                    .toolbar {
                        // 🌟 關鍵修改：將 Picker 放入 .principal (標題位置)
                        ToolbarItem(placement: .principal) {
                            Picker("選擇類別", selection: $selection) {
                                Text("武俠小說").tag(0 as Int?)
                                Text("言情小說").tag(1 as Int?)
                                Text("照片牆").tag(2 as Int?)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 320) // 給 Picker 一個合適的寬度
                        }
                    }
                }
            } else {
                // MARK: - iPhone 模式（使用 TabView）
                // 🌟 關鍵修改：將 NavigationView 換成 NavigationStack
                TabView(selection: Binding(
                    get: { selection ?? 0 },
                    set: { selection = $0 }
                )) {
                    // Tab 1: 武俠
                    NavigationStack { // 🌟 使用 NavigationStack
                        AuthorListView(authors: BookStore.shared.martialAuthors, genre: "武俠")
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    toolbarButtons
                                }
                            }
                    }
                    .tabItem {
                        Label("武俠", systemImage: "person.2.fill")
                    }
                    .tag(0)
                    
                    // Tab 2: 言情
                    NavigationStack { // 🌟 使用 NavigationStack
                        AuthorListView(authors: BookStore.shared.romanceAuthors, genre: "言情")
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    toolbarButtons
                                }
                            }
                    }
                    .tabItem {
                        Label("言情", systemImage: "heart.fill")
                    }
                    .tag(1)
                    
                    // Tab 3: 照片牆
                    NavigationStack { // 🌟 使用 NavigationStack
                        PhotoWallView()
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    toolbarButtons
                                }
                            }
                    }
                    .tabItem {
                        Label("照片牆", systemImage: "photo.on.rectangle.angled")
                    }
                    .tag(2)
                }
                .sheet(isPresented: $showAuthorSheet) {
                    // 彈窗內容不變 (使用 NavigationStack)
                    NavigationStack {
                        AuthorListView(authors: allAuthors, genre: "所有作者")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("關閉") {
                                        showAuthorSheet = false
                                    }
                                }
                            }
                    }
                }
            }
        }
        // 🌗 套用目前模式
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .animation(.easeInOut(duration: 0.3), value: isDarkMode)
    }

    // MARK: - 共用工具列按鈕 (不變)
    @ViewBuilder
    private var toolbarButtons: some View {
        // ☰ 作者列表
        Button {
            showAuthorSheet.toggle()
        } label: {
            Image(systemName: "line.3.horizontal")
        }

        // 🌗 深淺模式切換
        Button {
            isDarkMode.toggle()
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
        }
    }

    // MARK: - iPad 詳細視圖 (不變)
    @ViewBuilder
    private var selectedView: some View {
        switch selection {
        case 0:
            AuthorListView(authors: BookStore.shared.martialAuthors, genre: "武俠")
        case 1:
            AuthorListView(authors: BookStore.shared.romanceAuthors, genre: "言情")
        case 2:
            PhotoWallView()
        default:
            // 預設顯示武俠
            AuthorListView(authors: BookStore.shared.martialAuthors, genre: "武俠")
        }
    }
}


// MARK: - 作者列表（第一層）
struct AuthorListView: View {
    let authors: [Author]
    let genre: String
    @State private var searchText = ""
    
    var filteredAuthors: [Author] {
        if searchText.isEmpty {
            return authors
        }
        return authors.filter { $0.name.contains(searchText) }
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(filteredAuthors) { author in
                            NavigationLink(value: author) {
                                AuthorCardView(author: author)
                            }
                            .buttonStyle(.plain)
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }
                        .padding(.horizontal)
                    } header: {
                        HStack {
                            Image(systemName: genre == "武俠" ? "sword" : "heart.fill")
                                .foregroundStyle(genre == "武俠" ? .orange : .pink)
                            Text("\(genre)作者")
                                .font(.title2.bold())
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
                }
                .animation(.spring(), value: filteredAuthors)
            }
        }
        // --- 保留 .navigation... 修飾符 ---
        // 標題將由外部的 NavigationStack 讀取
        .navigationTitle(genre == "所有作者" ? genre : "\(genre)小說")
        .navigationDestination(for: Author.self) { author in
            NovelListView(author: author)
        }
        .navigationDestination(for: Novel.self) { novel in
            NovelDetailView(novel: novel)
        }
        .searchable(text: $searchText, prompt: "搜尋作者")
    }
}

struct AuthorCardView: View {
    let author: Author
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: author.avatar)
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: author.specialty == "武俠" ? [.orange, .red] : [.pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                // 組合多種文字樣式
                Text(author.name)
                    .font(.title2.bold())
                
                Text(author.bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "book.fill")
                        .font(.caption)
                    Text("查看作品")
                        .font(.caption)
                }
                .foregroundColor(.blue)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        // 使用自訂 ViewModifier
        .glassCard()
        // 生動有趣的圖片效果
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - 作品列表（第二層）
struct NovelListView: View {
    let author: Author
    @State private var novels: [Novel] = []
    
    var body: some View {
        // 上下捲動的頁面
        ScrollView {
            VStack(spacing: 20) {
                AuthorHeaderView(author: author)
                    .padding()
                
                // 上下捲動的頁面裡有水平捲動的區塊
                VStack(alignment: .leading, spacing: 12) {
                    Text("熱門推薦")
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(novels.prefix(3)) { novel in
                                NavigationLink(value: novel) {
                                    HorizontalNovelCard(novel: novel)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("所有作品")
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 16) {
                        ForEach(novels) { novel in
                            NavigationLink(value: novel) {
                                NovelRowView(novel: novel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(author.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            novels = BookStore.shared.getNovels(for: author)
        }
    }
}

struct AuthorHeaderView: View {
    let author: Author
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: author.avatar)
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: author.specialty == "武俠" ? [.orange, .red] : [.pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 10)
                .scaleEffect(animate ? 1.05 : 1.0)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(author.name)
                    .font(.title.bold())
                
                Text(author.bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("經典作家")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .glassCard()
        // 生動有趣的動畫效果
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct HorizontalNovelCard: View {
    let novel: Novel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: novel.cover)
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 180, height: 240)
                .background(
                    LinearGradient(
                        colors: novel.author.specialty == "武俠" ?
                            [.orange, .red] : [.pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(novel.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", novel.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 180)
        }
    }
}

struct NovelRowView: View {
    let novel: Novel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: novel.cover)
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .frame(width: 80, height: 110)
                .background(
                    LinearGradient(
                        colors: novel.author.specialty == "武俠" ?
                            [.orange, .red] : [.pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(novel.title)
                    .font(.headline)
                
                Text(novel.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", novel.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(novel.chapters.count) 章")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .glassCard()
    }
}

// MARK: - 作品詳情（第三層）
struct NovelDetailView: View {
    let novel: Novel
    @State private var selectedChapter: Chapter?
    @State private var showWebView = false
    @State private var showChapterAnimation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: novel.cover)
                        .font(.system(size: 100))
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 280)
                        .background(
                            LinearGradient(
                                colors: novel.author.specialty == "武俠" ?
                                    [.orange, .red] : [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                }
                .padding()
                
                Text(novel.title)
                    .font(.title.bold())
                
                Text("作者：\(novel.author.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", novel.rating))
                    }
                    
                    HStack {
                        Image(systemName: "book.fill")
                        Text("\(novel.chapters.count) 章")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("作品簡介")
                        .font(.title3.bold())
                    
                    Text(novel.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("章節列表")
                            .font(.title3.bold())
                        Spacer()
                        
                        // 顯示網頁，使用 Link
                        Link(destination: URL(string: "https://zh.wikipedia.org/wiki/\(novel.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!) {
                            HStack(spacing: 4) {
                                Text("查看維基")
                                Image(systemName: "safari")
                            }
                            .font(.caption)
                        }
                        
                        // 顯示網頁，使用 WebView (SFSafariViewController)
                        Button {
                            showWebView = true
                        } label: {
                             Image(systemName: "globe")
                                .font(.caption)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.horizontal)
                    
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(novel.chapters) { chapter in
                            Button {
                                selectedChapter = chapter // 這將觸發 .sheet
                            } label: {
                                HStack {
                                    Text(chapter.title)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "book.pages.fill") // 使用 SF Symbol
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .glassCard(cornerRadius: 12, shadowRadius: 5)
                            }
                            .buttonStyle(.plain)
                            // 設定元件出現的動畫效果
                            .opacity(showChapterAnimation ? 1 : 0)
                            .offset(y: showChapterAnimation ? 0 : 20)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(chapter.number) * 0.05),
                                value: showChapterAnimation
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(novel.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedChapter) { chapter in
            // 顯示作品內容
            ChapterView(chapter: chapter)
        }
        .sheet(isPresented: $showWebView) {
            // 顯示網頁 (SFSafariViewController)
            SafariView(url: URL(string: "https://www.google.com/search?q=\(novel.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!)
                .ignoresSafeArea()
        }
        .onAppear {
            showChapterAnimation = true
        }
    }
}

// MARK: - 章節內容（第四層）
struct ChapterView: View {
    let chapter: Chapter
    @Environment(\.dismiss) private var dismiss
    
    // 客製字型 (請確保已將 "Palatino.ttf" 或 "Georgia-Bold.ttf" 加入專案)
    private let titleFont = "Georgia-Bold"
    private let bodyFont = "Palatino"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(chapter.title)
                        .font(Font.custom(titleFont, size: 34, relativeTo: .largeTitle)) // 使用客製字型
                        .lineLimit(3)

                    // 組合多種文字樣式
                    (
                        Text("章節：")
                            .font(Font.custom(bodyFont, size: 18, relativeTo: .body).weight(.bold))
                        + Text("\(chapter.number)")
                            .font(Font.custom(bodyFont, size: 18, relativeTo: .body))
                            .foregroundColor(.secondary)
                    )
                    
                    Divider()

                    Text(chapter.content)
                        .font(Font.custom(bodyFont, size: 17, relativeTo: .body)) // 使用客製字型
                        .lineSpacing(8)
                        .padding(.top)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - WebView (Safari)
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 不需要更新
    }
}


// MARK: - 照片牆（Tab 3）
struct PhotoItem: Identifiable, Hashable {
    let id: Int
    let urlString: String
}

// MARK: - 照片牆（Tab 3）
struct PhotoWallView: View {
    // ... (photoItems, columns... 等屬性不變) ...
    let photoItems: [PhotoItem] = (1...50).map {
        PhotoItem(id: $0, urlString: "https://picsum.photos/id/\($0 * 3)/400/400")
    }
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 120), spacing: 4),
    ]
    @State private var animateGrid = false
    
    var body: some View {
        // --- 移除了 NavigationStack { ... } ---
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(photoItems) { item in
                    AsyncImage(url: URL(string: item.urlString)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(.thinMaterial)
                                .aspectRatio(1, contentMode: .fill)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(1, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .scaleEffect(animateGrid ? 1.0 : 0.8)
                                .opacity(animateGrid ? 1.0 : 0.5)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.7)
                                    .delay(Double(item.id) * 0.01),
                                    value: animateGrid
                                )
                        case .failure:
                            Rectangle()
                                .fill(.secondary.opacity(0.1))
                                .aspectRatio(1, contentMode: .fill)
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(minHeight: 120)
                }
            }
            .padding(4)
        }
        .background(Color(.systemGroupedBackground))
        // 標題將由外部的 NavigationStack 讀取
        .navigationTitle("小說插圖牆")
        .onAppear {
            if !animateGrid {
                animateGrid = true
            }
        }
    }
}


// MARK: - App 入口
@main
struct EBookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
