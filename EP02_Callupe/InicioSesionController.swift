//
//  InicioSesionController.swift
//  EP02_Callupe
//
//  Created by user192688 on 10/9/21.
//

import UIKit
import FirebaseAuth

class inicioSesionController: UIViewController {
    
    @IBOutlet weak var nombreUsuario: UITextField!
    @IBOutlet weak var contrasenaUsuario: UITextField!
    
    
    @IBAction func ingresar(_ sender: Any) {
        let correo = nombreUsuario.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contrasena = contrasenaUsuario.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: correo, password: contrasena){
            (result, err) in
            if err != nil {
                self.mostrarError(_error: err!.localizedDescription)
            } else {
                let alertController = UIAlertController(title: "Login", message: "Inicio de sesion correcto", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func mostrarError(_error: String){
               let alertController = UIAlertController(title: "Email o contraseña incorrecta", message: _error, preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "Ok", style: .default))
               
               self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cerrarTecladoInicioSesion(_ sender: Any) {
        self.closeKeyboard()
    }
    
    private func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registrarTecladoEvento()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.noRegistrarTecladoEvento()
    }
}

extension inicioSesionController {
    
    private func registrarTecladoEvento(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.mostrarTeclado(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.ocultarTeclado(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func noRegistrarTecladoEvento(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func mostrarTeclado(_ notification: Notification){
        print("Se abrio el teclado")
    }
    
    @objc private func ocultarTeclado(_ notification: Notification){
        print("Se cerro el teclado")
    }
}
