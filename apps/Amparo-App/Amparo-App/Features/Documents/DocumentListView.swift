import SwiftUI
import UniformTypeIdentifiers

struct DocumentListView: View {
    @State private var viewModel = DocumentListViewModel()
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        VStack(spacing: 0) {
            HeaderNavigationComponent(title: "Documentos")
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollView {
                    VStack(spacing: Spacing.medium) {
                        UploadZone {
                            viewModel.showFilePicker = true
                        }

                        if !viewModel.documents.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.small) {
                                Text("RECENTES")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.textPrimary)

                                ForEach(viewModel.documents) { document in
                                    DocumentRow(document: document)
                                }
                            }
                        } else {
                            EmptyStateView(
                                icon: Icon.docs,
                                title: "Sem documentos",
                                subtitle: "Envie receitas, exames e históricos médicos"
                            )
                        }
                    }
                    .padding(Spacing.medium)
                }
            }
        }
        .background(Color.white)
        .task {
            guard let elderlyId = authSession.elderlyId else { return }
            await viewModel.load(elderlyId: elderlyId, token: authSession.token)
        }
        .fileImporter(
            isPresented: $viewModel.showFilePicker,
            allowedContentTypes: [.pdf, .image, .jpeg, .png],
            allowsMultipleSelection: false
        ) { result in
            guard let url = try? result.get().first else { return }
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }

            guard let data = try? Data(contentsOf: url) else { return }
            let mimeType = url.pathExtension == "pdf" ? "application/pdf" : "image/\(url.pathExtension)"

            Task {
                await viewModel.upload(
                    elderlyId: "",
                    fileData: data,
                    fileName: url.lastPathComponent,
                    mimeType: mimeType,
                    token: authSession.token
                )
            }
        }
    }
}
