import SwiftUI

struct FanDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FanDetailViewModel
    private let networkService: NetworkServiceProtocol
    @State private var isShowingEdit = false
    @State private var isShowingDeleteConfirmation = false
    let onChange: () -> Void

    init(fan: Fan, networkService: NetworkServiceProtocol = NetworkService(), onChange: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: FanDetailViewModel(fan: fan, networkService: networkService))
        self.networkService = networkService
        self.onChange = onChange
    }

    var body: some View {
        List {
            Section("Dados pessoais") {
                detailRow("Nome", viewModel.fan.name)
                detailRow("E-mail", viewModel.fan.email)
                detailRow("Data de nascimento", viewModel.formattedBirthDate)
                detailRow("Idade", viewModel.ageDescription)
                detailRow("Gênero", viewModel.fan.gender)
            }
            Section("Preferências e rotina") {
                detailRow("Time favorito", viewModel.favoriteTeamName)
                detailRow("Localização", viewModel.fan.location)
                detailRow("Frequência no estádio", viewModel.fan.stadiumFrequency.title)
            }
            Section {
                Button("Editar", systemImage: "pencil") { isShowingEdit = true }
                    .accessibilityIdentifier("editFanButton")
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    Label {
                        Text("Excluir").foregroundStyle(Color.red)
                    } icon: {
                        Image(systemName: "trash").foregroundStyle(Color.red)
                    }
                }
                .tint(.red)
                .accessibilityIdentifier("deleteFanButton")
            }
        }
        .navigationTitle("Detalhes do fã")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.refresh() }
        .sheet(isPresented: $isShowingEdit, onDismiss: {
            Task { await viewModel.refresh(); onChange() }
        }) {
            NavigationStack {
                FanRegistrationView(fan: viewModel.fan, networkService: networkService)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancelar") { isShowingEdit = false }
                        }
                    }
            }
        }
        .confirmationDialog("Excluir este fã?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
            Button("Excluir fã", role: .destructive) { Task { await deleteFan() } }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Esta ação não pode ser desfeita.")
        }
        .alert("Não foi possível concluir", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "Ocorreu um erro.")
        }
    }

    private func detailRow(_ title: String, _ value: String) -> some View {
        LabeledContent(title, value: value)
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("detailRow_\(title)")
    }

    private func deleteFan() async {
        do {
            try await viewModel.delete()
            onChange()
            dismiss()
        } catch {
            viewModel.errorMessage = "Não foi possível excluir este fã. Tente novamente."
        }
    }
}
