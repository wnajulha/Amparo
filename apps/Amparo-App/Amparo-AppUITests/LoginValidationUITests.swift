//
//  LoginValidationUITests.swift
//  Amparo-App
//
//  Created by Daniel Leal PImenta on 18/06/26.
//

import XCTest

final class LoginValidationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testUI01_LoginComCredenciaisValidas() throws {
        let emailField = app.textFields["seu@email.com"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "O campo de email deve estar visível.")
        emailField.tap()
        emailField.typeText("danielleal9830@gmail.com")
        
        let passwordField = app.secureTextFields["Senha"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Entrar"].tap()
        
        let dashboardTab = app.images["person.3.fill"]
        XCTAssertTrue(dashboardTab.waitForExistence(timeout: 5), "Login bem-sucedido: O dashboard deve ser exibido.")
    }

    // MARK: - UI-02: Login com email vazio
    func testUI02_LoginComEmailVazio() throws {
        let passwordField = app.secureTextFields["Senha"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Entrar"].tap()
        
        let errorMessage = app.staticTexts["Preencha e-mail e senha."]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 2), "Deve exibir a mensagem 'Preencha e-mail e senha.'.")
    }

    // MARK: - UI-03: Login com email inválido
    func testUI03_LoginComEmailInvalido() throws {
        let emailField = app.textFields["seu@email.com"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("danielleal9830gmail.com")
        
        let passwordField = app.secureTextFields["Senha"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Entrar"].tap()
        
        let errorMessage = app.staticTexts["Erro ao fazer login. Tente novamente."]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 2), "Deve exibir a mensagem 'Erro ao fazer login. Tente novamente.'.")
    }

    // MARK: - UI-04: Login com senha vazia
    func testUI04_LoginComSenhaVazia() throws {
        let emailField = app.textFields["seu@email.com"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("danielleal9830@gmail.com")
        
        app.buttons["Entrar"].tap()
        
        let errorMessage = app.staticTexts["Preencha e-mail e senha."]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 2), "Deve exibir a mensagem 'Preencha e-mail e senha.'.")
    }

    // MARK: - UI-05: Login com credenciais inválidas
    func testUI05_LoginComCredenciaisInvalidas() throws {
        let emailField = app.textFields["seu@email.com"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("danielleal9830@gmail.com")
        
        let passwordField = app.secureTextFields["Senha"]
        passwordField.tap()
        passwordField.typeText("senhaTotalmenteErrada999")
        
        app.buttons["Entrar"].tap()
        
        let errorMessage = app.staticTexts["Erro ao fazer login. Tente novamente."]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 5), "Deve exibir a mensagem 'Erro ao fazer login. Tente novamente.'")
    }

}
