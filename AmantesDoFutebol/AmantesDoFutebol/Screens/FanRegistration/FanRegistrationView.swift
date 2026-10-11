import SwiftUI

struct FanRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FanRegistrationViewModel

    init(fan: Fan? = nil, networkService: NetworkServiceProtocol = NetworkService()) {
        _viewModel = StateObject(wrappedValue: FanRegistrationViewModel(fan: fan, networkService: networkService))
    }

    var body: some View {
        Form {
            Section("Dados pessoais") {
                TextField("Nome", text: $viewModel.name)
                    .textContentType(.name)
                TextField("E-mail", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Data de nascimento (DD/MM/AAAA)", text: Binding(
                    get: { viewModel.birthDate },
                    set: { viewModel.updateBirthDateInput($0) }
                ))
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityIdentifier("birthDateField")
                Picker("Gênero", selection: $viewModel.gender) {
                    Text("Selecione").tag("")
                    ForEach(FanRegistrationViewModel.genderOptions, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("genderPicker")
            }

            Section("Preferências e rotina") {
                Picker("Time favorito", selection: $viewModel.favoriteTeamId) {
                    ForEach(viewModel.teams) { team in
                        Text(team.name).tag(team.id)
                    }
                }
                TextField("Cidade", text: $viewModel.city)
                TextField("Estado", text: $viewModel.state)
                TextField("País", text: $viewModel.country)
                Picker("Frequência no estádio", selection: $viewModel.stadiumFrequency) {
                    ForEach(StadiumFrequency.allCases) { frequency in
                        Text(frequency.title).tag(frequency)
                    }
                }
            }

            Section {
                Button {
                    Task {
                        do {
                            try await viewModel.save()
                            dismiss()
                        } catch {
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text(viewModel.isEditing ? "Salvar alterações" : "Cadastrar fã")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.isLoading || viewModel.teams.isEmpty)
            }
        }
        .navigationTitle(viewModel.isEditing ? "Editar fã" : "Cadastro de fã")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadTeams() }
        .alert("Atenção", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "Ocorreu um erro.")
        }
    }
}
