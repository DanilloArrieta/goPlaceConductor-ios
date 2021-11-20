//
//  RecuperarContrasenaController.swift
//  EP02_Callupe
//
//  Created by user192688 on 10/9/21.
//

import UIKit
import FirebaseAuth

class recuperarContrasenaController: UIViewController {
    
    @IBOutlet weak var usuarioTF: UITextField!
    
    
    @IBAction func recuperarContrasena(_ sender: Any) {
        
        let correo = usuarioTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                Auth.auth().sendPasswordReset(withEmail: correo) {
                    err in
                    if err != nil {
                      
                        self.showError(_error: err!.localizedDescription, title: "Ocurrio un error")
                    } else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        
    }
    
    func showError(_error: String, title: String) {
              let alertController = UIAlertController(title: title, message: _error, preferredStyle: .alert)
              alertController.addAction(UIAlertAction(title: "Ok", style: .default))
              
              self.present(alertController, animated: true, completion: nil)
          }
    
    
    @IBAction func cerrarTecladoRecuperarContrasena(_ sender: Any) {
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

extension recuperarContrasenaController {
    
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

