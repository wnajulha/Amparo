import Foundation

@Observable
@MainActor
final class DocumentListViewModel {
    var documents: [Document] = []
    var isLoading = false
    var error: String?
    var showFilePicker = false

    private let documentService = DocumentService()

    func load(elderlyId: String, token: String) async {
        if token == "mock" {
            documents = MockDataProvider.mockDocuments
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            documents = try await documentService.list(elderlyId: elderlyId, token: token)
        } catch {
            self.error = "Não foi possível carregar os documentos."
        }
    }

    func upload(elderlyId: String, fileData: Data, fileName: String, mimeType: String, token: String) async {
        do {
            let doc = try await documentService.upload(
                elderlyId: elderlyId,
                fileData: fileData,
                fileName: fileName,
                mimeType: mimeType,
                token: token
            )
            documents.insert(doc, at: 0)
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível enviar o documento."
        }
    }

    func delete(document: Document, elderlyId: String, token: String) async {
        do {
            try await documentService.delete(elderlyId: elderlyId, documentId: document.id, token: token)
            documents.removeAll { $0.id == document.id }
        } catch {
            self.error = "Não foi possível excluir o documento."
        }
    }
}
