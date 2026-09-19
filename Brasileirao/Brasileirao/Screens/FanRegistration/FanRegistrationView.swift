import SwiftUI

struct FanRegistrationView: View {
    @StateObject private var viewModel = FanRegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack {
                    Text("Cadastro de Sócio Torcedor")
                        .font(.system(size: 28, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    TextField("Nome Completo", text: $viewModel.name)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    
                    Divider()
                    
                    TextField("E-mail", text: $viewModel.email)
                        .textFieldStyle(.plain)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    
                    Divider()
                    
                    HStack {
                        Text("Time do Coração")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $viewModel.selectedTeamID) {
                            Text("Selecione...").tag(nil as Int?)
                            ForEach(viewModel.teams, id: \.id) { team in
                                Text(team.name).tag(team.id as Int?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal, 4)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nível do Sócio Torcedor")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Nível do Sócio Torcedor", selection: $viewModel.subscriptionPlan) {
                            Text("Plano Bronze").tag("Bronze")
                            Text("Plano Prata").tag("Prata")
                            Text("Plano Ouro").tag("Ouro")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, 4)
                    
                    Divider()
                    
                    HStack {
                        Text("Receber alertas de gols")
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $viewModel.receivesAlerts)
                            .labelsHidden()
                    }
                    .padding(.horizontal, 4)
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 16)
                
                Button(action: {
                    viewModel.submitRegistration()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Finalizar e Cadastrar Adepto")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                viewModel.loadTeams()
            }
        }
    }
}
