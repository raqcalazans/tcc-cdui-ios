import SwiftUI

struct FanListView: View {
    @StateObject private var viewModel: FanListViewModel
    private let networkService: NetworkServiceProtocol
    @State private var isShowingRegistration = false

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        _viewModel = StateObject(wrappedValue: FanListViewModel(networkService: networkService))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.fans.isEmpty {
                    ProgressView("Carregando fãs...")
                } else if viewModel.fans.isEmpty {
                    ContentUnavailableView(
                        "Nenhum fã cadastrado",
                        systemImage: "person.2",
                        description: Text("Toque em + para cadastrar a primeira pessoa.")
                    )
                } else {
                    List(viewModel.fans) { fan in
                        NavigationLink(value: fan) {
                            FanRowView(fan: fan, favoriteTeamName: viewModel.teamNames[fan.favoriteTeamId] ?? fan.favoriteTeamId)
                        }
                        .accessibilityIdentifier("fanRow_\(fan.id)")
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.loadFans() }
                }
            }
            .navigationTitle("Amantes do Futebol")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Fan.self) { fan in
                FanDetailView(fan: fan, networkService: networkService) {
                    Task { await viewModel.loadFans() }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button { isShowingRegistration = true } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(Color.accentColor, in: Circle())
                        .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
                }
                .accessibilityLabel("Cadastrar fã")
                .accessibilityIdentifier("addFanButton")
                .padding(22)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.loadFans() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("Atualizar lista")
                }
            }
            .task { await viewModel.loadFans() }
            .sheet(isPresented: $isShowingRegistration, onDismiss: {
                Task { await viewModel.loadFans() }
            }) {
                NavigationStack {
                    FanRegistrationView(networkService: networkService)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancelar") { isShowingRegistration = false }
                            }
                        }
                }
            }
            .alert("Não foi possível carregar", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("Tentar novamente") { Task { await viewModel.loadFans() } }
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "Ocorreu um erro.")
            }
        }
    }
}

private struct FanRowView: View {
    let fan: Fan
    let favoriteTeamName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(fan.name).font(.headline)
            Label(favoriteTeamName, systemImage: "shield")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}
