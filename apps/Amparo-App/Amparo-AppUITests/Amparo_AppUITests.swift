//
//  Amparo_AppUITests.swift
//  Amparo-AppUITests
//
//  Created by Filipi Romão on 16/06/26.
//

import XCTest

final class Amparo_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
    
    func performLogin(app: XCUIApplication) {
        let emailField = app.textFields["seu@email.com"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "Campo de email deve existir.")
        emailField.tap()
        emailField.typeText("danielleal9831@gmail.com")
        
        let passwordField = app.secureTextFields["Senha"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        let loginButton = app.buttons["Entrar"]
        loginButton.tap()
    }
    
    func testRegisterUser() throws {
        let app = XCUIApplication()
        app.launch()
        
        let goToRegisterButton = app.buttons["registerButton"]
        XCTAssertTrue(goToRegisterButton.waitForExistence(timeout: 5), "O botão de ir para cadastro deve existir.")
        goToRegisterButton.tap()
        
        let nameField = app.textFields["nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5), "O campo de nome deve estar visível.")
        nameField.tap()
        nameField.typeText("Daniel Leal Pimenta")
        
        let emailField = app.textFields["emailField"]
        emailField.tap()
        emailField.typeText("danielleal9831@gmail.com")
        
        let passwordField = app.secureTextFields["passwordField"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        let createAccountButton = app.buttons["createAccountButton"]
        createAccountButton.tap()
    }
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        performLogin(app: app)
        
        let familyTab = app.images["person.3.fill"]
        XCTAssertTrue(familyTab.waitForExistence(timeout: 5), "Deveria ter feito login e ido para a tela principal.")
    }
    
    func testCreatingFamily() throws {
        let app = XCUIApplication()
        app.launch()
            
        app/*@START_MENU_TOKEN@*/.images["person.3.fill"]/*[[".buttons[\"person.3.fill\"].images",".buttons.images[\"person.3.fill\"]",".images[\"person.3.fill\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Criar família"]/*[[".otherElements.buttons[\"Criar família\"]",".buttons[\"Criar família\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Ex: Família Oliveira"]/*[[".otherElements.textFields[\"Ex: Família Oliveira\"]",".textFields",".textFields[\"Ex: Família Oliveira\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Ex: Família Oliveira"]/*[[".otherElements",".textFields[\"Família Carvalho\"]",".textFields[\"Ex: Família Oliveira\"]",".textFields"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("Família Carvalho")
        app/*@START_MENU_TOKEN@*/.buttons["Criar Família"]/*[[".scrollViews.buttons",".otherElements.buttons[\"Criar Família\"]",".buttons[\"Criar Família\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
    }
    
    func testAddingElderToTheFamily() throws {
        let app = XCUIApplication()
        app.launch()
        
        let familyTab = app.images["person.3.fill"]
        XCTAssertTrue(familyTab.waitForExistence(timeout: 5), "A aba da família deve existir.")
        familyTab.tap()
        
        let addButton = app.buttons["plus.circle.fill"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "O botão de adicionar idoso deve existir.")
        addButton.tap()
        
        let nameField = app.textFields["Maria Aparecida Oliveira"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5), "O campo de nome deve estar visível.")
        nameField.tap()
        nameField.typeText("Jorge Carvalho Pedregulho")
        
        let datePickerButton = app.buttons["Date Picker"]
        datePickerButton.tap()
        
        let showWheelsButton = app.buttons["DatePicker.Show"]
        XCTAssertTrue(showWheelsButton.waitForExistence(timeout: 3), "O botão para mostrar as rodinhas do DatePicker deve aparecer.")
        showWheelsButton.tap()
        
        let monthWheel = app.pickerWheels.element(boundBy: 0)
        monthWheel.adjust(toPickerWheelValue: "July")
        
        let yearWheel = app.pickerWheels.element(boundBy: 1)
        yearWheel.adjust(toPickerWheelValue: "1949")
        
        let dismissPopoverButton = app.buttons["PopoverDismissRegion"]
        if dismissPopoverButton.waitForExistence(timeout: 2) {
            dismissPopoverButton.tap()
        } else {
            app.scrollViews.firstMatch.tap()
        }
        
        let conditionField = app.textFields["+ Adicionar condição"]
        conditionField.tap()
        conditionField.typeText("Diabético")
        
        let addConditionButton = app.buttons.matching(identifier: "Adicionar").element(boundBy: 0)
        addConditionButton.tap()
        
        let allergyField = app.textFields["+ Adicionar alergia"]
        allergyField.tap()
        allergyField.typeText("Amendoim")
        
        let addAllergyButton = app.buttons.matching(identifier: "Adicionar").element(boundBy: 1)
        addAllergyButton.tap()
        
        let contactNameField = app.textFields["Nome do contato"]
        XCTAssertTrue(contactNameField.waitForExistence(timeout: 5), "O campo de contato deve estar visível.")
        contactNameField.tap()
        contactNameField.typeText("Daniel")
        
        let phoneField = app.textFields["(11) 99999-9999"]
        phoneField.tap()
        phoneField.typeText("61912387612")
        
        let relationField = app.textFields["Ex: Filho, Filha"]
        relationField.tap()
        relationField.typeText("Filho")
        
        let saveButton = app.buttons["Salvar e Continuar"]
        saveButton.tap()
    }
    
    func testCreatingNewTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tarefasTab = app.staticTexts["Tarefas"]
        XCTAssertTrue(tarefasTab.waitForExistence(timeout: 5), "A aba 'Tarefas' deve estar visível.")
        tarefasTab.tap()
        
        let addButton = app.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "O botão '+' deve existir.")
        addButton.tap()
        
        let taskNameField = app.textFields["Ex: Losartana 50mg"]
        XCTAssertTrue(taskNameField.waitForExistence(timeout: 5), "O campo de nome da tarefa deve aparecer.")
        taskNameField.tap()
        taskNameField.typeText("Natação")
        
        let backgroundScrollView = app.scrollViews.firstMatch
        backgroundScrollView.tap()
        
        app.buttons["Atividades Físicas"].tap()
        app.buttons["Semanal"].tap()
        
        let datePickerButton = app.buttons.matching(identifier: "Date Picker").element(boundBy: 0)
        datePickerButton.tap()
        
        let day15 = app.staticTexts["15"]
        if day15.waitForExistence(timeout: 2) {
            day15.tap()
        }
        
        let dismissPopoverButton = app.buttons["PopoverDismissRegion"]
        if dismissPopoverButton.exists {
            dismissPopoverButton.tap()
        } else {
            backgroundScrollView.tap()
        }
        
        let assigneeButton = app.buttons["Daniel Leal Pimenta"]
        XCTAssertTrue(assigneeButton.waitForExistence(timeout: 5), "O botão do responsável deve estar visível.")
        assigneeButton.tap()
        
        let createActivityButton = app.buttons["Criar atividade"]
        createActivityButton.tap()

    }
    
    func testFilterTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tarefasTab = app.staticTexts["Tarefas"]
        XCTAssertTrue(tarefasTab.waitForExistence(timeout: 5), "A aba de Tarefas deve estar visível.")
        tarefasTab.tap()
        
        let filtroMedicamento = app.buttons["Medicamento"]
        XCTAssertTrue(filtroMedicamento.waitForExistence(timeout: 2))
        filtroMedicamento.tap()
        
        let filtroAtividade = app.buttons["Atividade"]
        filtroAtividade.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS[c] 'Natação'")
        let natacaoTask = app.buttons.matching(predicate).firstMatch
        
        XCTAssertTrue(natacaoTask.waitForExistence(timeout: 5), "Uma tarefa com o nome 'Natação' deveria aparecer após aplicar o filtro.")
    }
    
    func testDeleteTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 1. Navegar até a aba Agenda
        let agendaTab = app.buttons["Agenda"]
        XCTAssertTrue(agendaTab.waitForExistence(timeout: 5), "A aba Agenda deve estar visível.")
        agendaTab.tap()
        
        // 2. Pegar a primeira tarefa disponível na tela
        // Ao invés do taskCard, vamos procurar por botões que tenham "Ativo" no nome (conforme a sua imagem)
        let predicate = NSPredicate(format: "label CONTAINS[c] 'Ativo'")
        let taskList = app.buttons.matching(predicate)
        
        // Garantir que existe pelo menos uma tarefa para podermos testar a deleção
        XCTAssertTrue(taskList.firstMatch.waitForExistence(timeout: 10), "Deve haver pelo menos uma tarefa na Agenda para este teste.")
        
        // 3. Pegar a PRIMEIRA tarefa e salvar o nome dela
        let firstTask = taskList.firstMatch
        let deletedTaskName = firstTask.label // Salva o texto completo do botão
        
        // 4. Entrar na tarefa
        firstTask.tap()
        
        // 5. Clicar em Excluir dentro da TaskDetailView
        // Olhando o seu código da TaskDetailView, você tem o botão de Excluir tanto no menu de três pontos quanto no TaskActionButtons.
        // Vamos usar o botão que aparece direto na tela ("Excluir")
        let deleteButton = app.buttons["Excluir"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5), "O botão Excluir deve aparecer.")
        deleteButton.tap()
        
        // 6. VALIDAÇÃO: Como a sua tela faz um dismiss(), a primeira checagem é garantir que voltamos para a lista
        let agendaTitle = app.staticTexts["Agenda"]
        XCTAssertTrue(agendaTitle.waitForExistence(timeout: 5), "A tela deveria voltar para a Agenda após excluir.")
        
        // 7. Procurar na tela pelo botão que tem o nome que salvamos lá em cima
        let taskThatShouldBeDeleted = app.buttons[deletedTaskName]
        
        // Como queremos que ela tenha sumido, o resultado TEM QUE SER FALSE.
        let stillExists = taskThatShouldBeDeleted.waitForExistence(timeout: 3)
        
        XCTAssertFalse(stillExists, "A tarefa foi excluída, mas ainda está aparecendo na tela!")
    }
}
