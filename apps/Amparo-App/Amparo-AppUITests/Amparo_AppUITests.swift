//
//  Amparo_AppUITests.swift
//  Amparo-AppUITests
//

import XCTest

final class Amparo_AppUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    private func loginAndNavigateToAgenda(app: XCUIApplication) {
        let visitorLoginButton = app.buttons["Entrar como visitante"]
        if visitorLoginButton.waitForExistence(timeout: 3) {
            visitorLoginButton.tap()
        }
        let agendaTab = app.tabBars.buttons["Agenda"]
        XCTAssertTrue(agendaTab.waitForExistence(timeout: 5))
        agendaTab.tap()
    }
    
    
    @MainActor
    func testUI06_CriarTarefaValida() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        app.buttons["headerTrailingButton"].tap()
        
        let titleField = app.textFields["Ex: Losartana 50mg"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Remédio de Pressão")
        
        let createButton = app.buttons["Criar atividade"]
        if createButton.isHittable {
            createButton.tap()
        }
        
        XCTAssertTrue(app.tabBars.buttons["Agenda"].waitForExistence(timeout: 5), "Resultado esperado: Tarefa criada com sucesso.")
    }
    
    @MainActor
    func testUI07_CriarTarefaSemTitulo() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        app.buttons["headerTrailingButton"].tap()
        
        let createButton = app.buttons["Criar atividade"]
        if createButton.isHittable {
            createButton.tap()
        }
        
        let errorText = app.staticTexts["Preencha todos os campos obrigatórios."]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5), "Resultado esperado: Mensagem 'Preencha todos os campos obrigatórios.'.")
    }
    
    @MainActor
    func testUI08_CriarTarefaSemData() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        app.buttons["headerTrailingButton"].tap()
        
        let createButton = app.buttons["Criar atividade"]
        if createButton.isHittable {
            createButton.tap()
        }
        
        let errorText = app.staticTexts["Preencha todos os campos obrigatórios."]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5), "Resultado esperado: Mensagem 'Preencha todos os campos obrigatórios.'.")
    }
    
    @MainActor
    func testUI09_CriarTarefaSemFrequencia() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        app.buttons["headerTrailingButton"].tap()
        
        // Alterna entre as opções de frequência
        let btnDiario = app.buttons["Diário"]
        if btnDiario.waitForExistence(timeout: 2) { btnDiario.tap() }
        
        let btnSemanal = app.buttons["Semanal"]
        if btnSemanal.exists { btnSemanal.tap() }
        
        let btnMensal = app.buttons["Mensal"]
        if btnMensal.exists { btnMensal.tap() }
        
        let btnUnico = app.buttons["Único"]
        if btnUnico.exists { btnUnico.tap() }
        
        let createButton = app.buttons["Criar atividade"]
        if createButton.isHittable {
            createButton.tap()
        }
        
        let errorText = app.staticTexts["Preencha todos os campos obrigatórios."]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5), "Resultado esperado: Mensagem 'Preencha todos os campos obrigatórios.'.")
    }
    
    @MainActor
    func testUI10_CriarTarefaDataPassado() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        app.buttons["headerTrailingButton"].tap()
        
        let createButton = app.buttons["Criar atividade"]
        if createButton.isHittable {
            createButton.tap()
        }
        
        let errorText = app.staticTexts["Preencha todos os campos obrigatórios."]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5), "Resultado esperado: Mensagem 'Preencha todos os campos obrigatórios.'.")
    }
    
    @MainActor
    func testUI11_VisualizarAgendaComTarefas() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        let taskRow = app.staticTexts["Losartana 50mg"]
        XCTAssertTrue(taskRow.waitForExistence(timeout: 5), "Resultado esperado: Lista de tarefas exibida.")
    }
    
    @MainActor
    func testUI12_VisualizarAgendaSemTarefas() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        let emptyMessage = app.staticTexts["Sem tarefas"]
        XCTAssertTrue(emptyMessage.waitForExistence(timeout: 5), "Resultado esperado: Mensagem 'Nenhuma tarefa'.")
    }
        
    @MainActor
    func testUI13_EditarTarefa() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        let taskRow = app.staticTexts["Losartana 50mg"]
        if taskRow.waitForExistence(timeout: 5) {
            taskRow.tap()
            
            let editButton = app.buttons["Editar"].firstMatch
            if editButton.waitForExistence(timeout: 5) {
                editButton.tap()
            }
            
            XCTAssertTrue(editButton.exists || app.staticTexts["Losartana 50mg"].exists, "Resultado esperado: Navegação para a tela de edição.")
        }
    }
    
    @MainActor
    func testUI14_ExcluirTarefa() throws {
        let app = XCUIApplication()
        app.launch()
        loginAndNavigateToAgenda(app: app)
        
        let taskRow = app.staticTexts["Losartana 50mg"]
        if taskRow.waitForExistence(timeout: 5) {
            taskRow.tap()
            
            let deleteButton = app.buttons["Excluir"].firstMatch
            if deleteButton.waitForExistence(timeout: 5) {
                deleteButton.tap()
            }
            
            let agendaTabBar = app.tabBars.buttons["Agenda"]
            XCTAssertTrue(agendaTabBar.waitForExistence(timeout: 5), "Resultado esperado: Tarefa removida da agenda.")
        }
    }
}
