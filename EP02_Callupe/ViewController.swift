//
//  ViewController.swift
//  EP02_Callupe
//
//  Created by user192688 on 10/9/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var NombreCompletoTF: UITextField!
    @IBOutlet weak var CorreoTF: UITextField!
    @IBOutlet weak var ContraseñaTF: UITextField!
    @IBOutlet weak var NumeroTF: UITextField!
    
    
    @IBAction func RegistroUsuario(_ sender: Any) {
        
        let error = validarFormulario()
        
                if error != nil {
                    self.error(_error: error!)
                } else {
                    let nombreCompleto = NombreCompletoTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let correo = CorreoTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let contrasena = ContraseñaTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let celular = NumeroTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
        
        FirebaseAuth.Auth.auth().createUser(withEmail: correo, password: contrasena) { (result, err) in
            
            // Check for error
                if err != nil{
                                                
            // There was an error creating the user
                    self.error(_error: err!.localizedDescription)
                }else{
                    let db = Firestore.firestore()
                                     
                    db.collection("usuarios").addDocument(data: [
                        "nombreCompleto" : nombreCompleto,
                        "correo" : correo,
                        "contrasena" : contrasena,
                        "celular": celular,
                        "uid": result!.user.uid
                    ]) { (error) in
                                                    
                        if error != nil{
                                                        
                            self.error(_error: "Ocurrio un error.")
                        }
                    }
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
            }
    }
    
    func error(_error: String) {
                let alertController = UIAlertController(title: "Error al registrar", message: _error, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
    
    func validarFormulario() -> String? {
           
              if NombreCompletoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
              || CorreoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                  || ContraseñaTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                    || NumeroTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""              {

                  return "Es necesario rellenar todos los campos para continuar con el registro"
              }

              return nil
          }
    
    @IBOutlet weak var anchorContentCenterY: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    
    
    @IBAction func cerrarTecladoRegistrar(_ sender: Any) {
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
        self.registerKeyboardEvents()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
}

extension ViewController {
    
    private func registerKeyboardEvents(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unregisterKeyboardEvents(){
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        let finalPosYContent = self.viewContent.frame.origin.y + self.viewContent.frame.height
        
        if keyboardFrame.origin.y < finalPosYContent {
            
            UIView.animate(withDuration: animationDuration, delay:0, options: [.curveEaseInOut], animations: {
                self.anchorContentCenterY.constant = keyboardFrame.origin.y - finalPosYContent
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification){
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration){
            self.anchorContentCenterY.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

