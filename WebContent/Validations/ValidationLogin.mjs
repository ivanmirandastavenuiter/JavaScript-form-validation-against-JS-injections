/**
 * Name: ValidationLogin
 * 
 * Author: Ivan Miranda Stavenuiter
 * MKNA
 * 
 */

import { ValidationException } from '../Exceptions/ValidationException.mjs';
import { ValidationFormException } from '../Exceptions/ValidationFormException.mjs';

document.addEventListener("DOMContentLoaded", function() {
	
	var loginForm = document.getElementsByName("loginForm")[0];
	var submit = false;
	var validation = true;
	
	var username = document.getElementsByName("username")[0];
	var pass = document.getElementsByName("pass")[0];
	var wrongUsernameNode = document.getElementsByClassName("username-wrong-validation")[0];
	var wrongPassNode = document.getElementsByClassName("password-wrong-validation")[0];
	var inputNodes = document.getElementsByClassName("form-input");
	
	var inputsMap = new Map();
	inputsMap.set(username, wrongUsernameNode)
			 .set(pass, wrongPassNode);

	// Main function on submit
	loginForm.onsubmit = function(e) {
		
		e.preventDefault();
		
		try {
			
			inputsMap.forEach(validateInputs);

			if (!validation) {
				return false;
			} else {
				this.submit();
			}
			
		} catch (err) {
			
			console.log('Exception thrown by parent try/catch block: ');
			console.log('Name: ' + err.name);
			console.log('Description: ' + err.message);
			console.log('Stack: ' + err.stack);
			
		}
		
	};
	
	// Function triggered on submit
	function validateInputs(value, key, map) {
		
		try {
			
			submit = true;
			
			if (key.name === 'username' && key.value.trim() === '') {
				
				throw new ValidationFormException(ValidationException.WARNING, 
												  ValidationException.USERNAME_EMPTY_FIELD,
												  value);
				
			} else if (key.name === 'pass' && key.value.trim() === '') {
				
				throw new ValidationFormException(ValidationException.WARNING, 
												  ValidationException.PASSWORD_EMPTY_FIELD,
												  value);
				
			}


		} catch(validationFormException) {
			
			if (validationFormException instanceof ValidationFormException) {
				validationFormException.handleLoginErrorOnSubmit();
				validation = false;
			} else {
				throw validationFormException;
			}
				
		}
		
	}
	
	// This check values after submit
	function validateInputsAfterSubmit(value, key, map) {
		
		key.onkeyup = function() {
			
			try {
				
				let resetNode = (value) => {
					value.innerText = '';	
					value.style.transition = 'none';
					value.style.opacity = 0;
				}
				
				if (submit) {
					if (key.value.trim().length > 0) {
						resetNode(value);
					} else {
						throw new ValidationFormException(ValidationException.WARNING, 
														  ValidationException.USERNAME_EMPTY_FIELD,
														  value);
					}
				}
				
			} catch(validationFormException) {
				
				if (validationFormException instanceof ValidationFormException) {
					validationFormException.handleLoginErrorAfterSubmit();
					validation = false;
				} else {
					throw validationFormException;
				}
					
			}
			
		}
	}
	
	inputsMap.forEach(validateInputsAfterSubmit);
	
});

	

	


	


