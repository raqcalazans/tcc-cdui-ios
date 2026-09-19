import SwiftUI

struct GameListView: View {
    
    @StateObject private var viewModel: GameListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: GameListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                FilterHeaderView(
                    currentStatusTitle: viewModel.selectedStatus.title,
                    onPrevious: { viewModel.selectPreviousStatus() },
                    onNext: { viewModel.selectNextStatus() }
                )
                .padding(.horizontal)
                .background(Color(.systemGroupedBackground))

                ZStack {
                    if viewModel.isLoading {
                        ProgressView("Buscando jogos...")
                            .padding()
                            .background(Material.thin)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
            }
            .navigationTitle("JOGOS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await syncData()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.primary)
                    }
                }
            }
            
            .task {
                await syncData()
            }

            .alert("Erro de Rede", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "Ocorreu um erro desconhecido.")
            })
        }
    }
    
    private func syncData() async {
        await viewModel.syncGames()
    }
}

struct FilterHeaderView: View {
    let currentStatusTitle: String
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(currentStatusTitle)
                .font(.headline)
            Spacer()
            Button(action: onNext) {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.primary)
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets())
    }
}
