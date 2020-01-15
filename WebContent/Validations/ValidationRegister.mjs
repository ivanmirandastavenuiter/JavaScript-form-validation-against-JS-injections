/**
 * Name: ValidationRegister
 * 
 * Author: Ivan Miranda Stavenuiter
 * MKNA
 * 
 */

import { ValidationException } from '../Exceptions/ValidationException.mjs';
import { ValidationFormException } from '../Exceptions/ValidationFormException.mjs';
import { ValidationJSPotentialInjectionException } from '../Exceptions/ValidationJSPotentialInjectionException.mjs';

document.addEventListener("DOMContentLoaded", function() {
	
	// Flag for validation
	let validation = true;
	
	// Flag for execution at sending time
	let submit = false;
	
	// Set a useful and easy-handling capturing element / Credits: Javascript Teacher @js_tut

	let id = (v) => document.getElementById(v);
	let className = (v) => document.getElementsByClassName(v);
	let name = (v) => document.getElementsByName(v);
	let tag = (v) => document.getElementsByTagName(v);
	
	// Get the nodes for data extraction 	
	let formNode = name("registerForm")[0];
	
	let nameNode = name("name")[0];
	let wrongNameNode = className("name-wrong-validation")[0];
	
	let surnameNode = name("surname")[0];
	let wrongSurnameNode = className("surname-wrong-validation")[0];
	
	let usernameNode = name("username")[0];
	let wrongUsernameNode = className("username-wrong-validation")[0];
	
	let phoneNode = name("phone")[0]
	let wrongPhoneNode = className("phone-wrong-validation")[0];
	
	let emailNode = name("email")[0];
	let wrongEmailNode = className("email-wrong-validation")[0];
	
	let passwordNode = name("password")[0];
	let wrongPasswordNode = className("password-wrong-validation")[0];
	
	let confirmNode = name("confirm")[0];
	let wrongConfirmNode = className("confirm-wrong-validation")[0];
	
	// Insert the inputs and error messages nodes as keys and values, respectively, to gain some efficiency. 
	let inputsMap = new Map();
	inputsMap.set(nameNode, wrongNameNode)
			 .set(surnameNode, wrongSurnameNode)
			 .set(usernameNode, wrongUsernameNode)
			 .set(phoneNode, wrongPhoneNode)
			 .set(emailNode, wrongEmailNode)
			 .set(passwordNode, wrongPasswordNode)
			 .set(confirmNode, wrongConfirmNode);
	
	// Regular expressions
	let regExpForPassword = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})", "gm");
	let regExpForEmail = new RegExp("^[\\w\\d\\\\\\^\\$\\.\\|\\?\\*\\+\\(\\)\\[\\{\\}\\]\\/\\-!'·%&=¿`´Çç_.;:,]+@[\\w\\d\\.\\-]+\\.[a-z]{2,3}$");

	/*   Spanish numbers regular expression 
	 *   
	 *   +0044626662626
	 *   +0044652 65 65 65
	 *   +0044652 656 565
	 *   + 0044652652652
	 *   + 0044652 652 652
	 *   + 0044652 65 62 65
	 *   + 0044 652652652
	 *   + 0044 652 652 652
	 *   + 0044 652 65 62 65
	 *   + 00 44652652652
	 *   + 00 44652 652 652
	 *   + 00 44652 65 62 65
	 *   + 00 44 652652652
	 *   + 00 44 652 652 652
	 *   + 00 44 652 65 62 65
	 *   652652652
	 *   652 65 65 65
	 *   655 655 655
	 *   
	 */
	
	let regExpForPhone = new RegExp("(^(\\+\\s?([0]{2})\\s?([0-9]{2})\\s?)?([6-7]{1}[0-9]{2}){1}(\\s([0-9]{3}\\s?[0-9]{3}|[0-9]{2}\\s?[0-9]{2}\\s?[0-9]{2})|([0-9]){6})$)");
	
	let trimmedValue;
	let passwordValue = undefined;
	let confirmValue = undefined;
	let inputContainerNode;
	
	// First filtering to prevent JS injections
	function cleanPossibleJSInjections(value, key, map) {
		
		try {
			
			let regExpForJSInjections = /((<[^>]*(>|$))|(&lt;?(?!&gt;?)(.*(&gt;?){1}|.*$))|(&#0*60(?!&#0*62)(.*(&#0*62){1}|.*$))|(&#x0*3c(?!&#x0*3e)(.*(&#x0*3e){1}|.*$)))/;
			
			if (regExpForJSInjections.test(key.value)) {
				
				let dangerousTags = ['<', '>', '&lt;', '&gt;', '&lt', '&gt', '&#60', '&#62', '&#x3c', '&#x3e'];
				
				for (let currentTag of dangerousTags) {
					
					// Special error handling for validation errors
					try {
						
						if (key.value.indexOf(currentTag) > -1) {
							
							throw new ValidationJSPotentialInjectionException(
							    ValidationException.WARNING,
							    currentTag,
							    key,
							    false
							);	
							
						} else if (currentTag.substring(0,2) === '&#' && key.value.indexOf(currentTag.substring(0,2)) > -1) {
							
							throw new ValidationJSPotentialInjectionException(
								ValidationException.WARNING,
							    currentTag,
							    key,
							    true
							);	
							
						}
						
					} catch (validationJSPotentialInjectionException) {
						
						validationJSPotentialInjectionException.handleError();
						
					}
					
				}
				
			}
			
		} catch(err) {
			
			if (!err instanceof ValidationJSPotentialInjectionException) 
				throw err;
			
		}

	}
	
	// Function passed in validation
	function validateInputs(value, key, map) {
		
		try {
			
			trimmedValue = key.value.trim() === '' ? undefined : key.value.trim();
			inputContainerNode = value.parentElement;
			
			switch (key.name) {
			
				case 'name':
				case 'surname':
				case 'username':
					 
					if (trimmedValue === undefined) {
						if (key.name === 'name') {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.NAME_EMPTY_FIELD,
															  inputContainerNode);
						} else if (key.name === 'surname') {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.SURNAME_EMPTY_FIELD,
															  inputContainerNode);
						} else if (key.name === 'username') {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.USERNAME_EMPTY_FIELD,
															  inputContainerNode);
						}
					}
					
					break;
				case 'phone':

					if (trimmedValue === undefined) {
						throw new ValidationFormException(ValidationException.WARNING, 
														  ValidationException.PHONE_EMPTY_FIELD,
														  inputContainerNode);
					} else {
						if (!regExpForPhone.test(trimmedValue)) {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.PHONE_NOT_MATCH,
															  inputContainerNode);
						}
					}
					
					break;
				case 'email':

					if (trimmedValue === undefined) {
						throw new ValidationFormException(ValidationException.WARNING, 
														  ValidationException.EMAIL_EMPTY_FIELD,
														  inputContainerNode);
					} else {
						if (!regExpForEmail.test(trimmedValue)) {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.EMAIL_NOT_MATCH,
															  inputContainerNode);
						}
					}
					
					break;
				case 'password':

					if (trimmedValue === undefined) {
						throw new ValidationFormException(ValidationException.WARNING, 
														  ValidationException.PASSWORD_EMPTY_FIELD,
														  inputContainerNode);
					} else {
						if (!regExpForPassword.test(trimmedValue)) {
							throw new ValidationFormException(ValidationException.WARNING, 
															  ValidationException.PASSWORD_NOT_MATCH,
															  inputContainerNode);
						} else {
							passwordValue = trimmedValue;
						}
					}
					
					break;
				case 'confirm':
					
					if (trimmedValue === undefined) {
						throw new ValidationFormException(ValidationException.WARNING, 
														  ValidationException.CONFIRM_EMPTY_FIELD,
														  inputContainerNode);
					} else {
						confirmValue = trimmedValue;
					}
					
					break;
				default:
					
					console.log('Not a valid entry');
					break;
					
			}
			
			if (passwordValue !== undefined && confirmValue !== undefined) {
				if (passwordValue !== confirmValue && regExpForPassword.test(passwordValue)) {
					throw new ValidationFormException(ValidationException.WARNING, 
													  ValidationException.PASSWORD_NOT_EQUAL,
													  inputContainerNode);
				}
			}
			
		} catch (validationFormException) {
			
			if (validationFormException instanceof ValidationFormException) {
				validationFormException.handleRegisterErrorOnSubmit();
				validation = false;
			} else {
				throw validationFormException;
			}
			
		} 
		
	}
	
	// Validation is triggered on submit
	formNode.onsubmit = function() {
		
		try {
			
			submit = true;
			
			inputsMap.forEach(cleanPossibleJSInjections);
			inputsMap.forEach(validateInputs);
			
			return validation;
			
		} catch (err) {
			
			console.log('Exception thrown by parent try/catch block: ');
			console.log('Name: ' + err.name);
			console.log('Description: ' + err.message);
			console.log('Stack: ' + err.stack);
			
		}
		
	}
	
	// Function executed once form is submit
	function validateInputsAfterSubmit(value, key, map) {
		
		key.onkeyup = function() {
			
			try {
				
				trimmedValue = key.value.trim() === '' ? undefined : key.value.trim();
				inputContainerNode = value.parentElement;
				let resetNode = (inputContainerNode) => {
					value.children[0].innerText = '';	
					inputContainerNode.style.transition = 'none';
					inputContainerNode.style.opacity = 0;
				}
				
				if (submit) {
					
					switch (key.name) {
					
						case 'name':
						case 'surname':
						case 'username':
							
							if (trimmedValue !== undefined && trimmedValue.length > 0) {
								resetNode(inputContainerNode);
							} else {
								if (key.name === 'name') {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.NAME_EMPTY_FIELD,
																	  inputContainerNode);
								} else if (key.name === 'surname') {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.SURNAME_EMPTY_FIELD,
																	  inputContainerNode);
								} else if (key.name === 'username') {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.USERNAME_EMPTY_FIELD,
																	  inputContainerNode);
								}
							}
							
							break;
						case 'phone':
			
							if (trimmedValue !== undefined && trimmedValue.length > 0) {
								if (!regExpForPhone.test(trimmedValue)) {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.PHONE_NOT_MATCH,
																	  inputContainerNode);
								} else {
									resetNode(inputContainerNode);
								}
							} else {
								throw new ValidationFormException(ValidationException.WARNING, 
																  ValidationException.PHONE_EMPTY_FIELD,
																  inputContainerNode);
							}
							
							break;
						case 'email':
			
							if (trimmedValue !== undefined && trimmedValue.length > 0) {
								if (!regExpForEmail.test(trimmedValue)) {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.EMAIL_NOT_MATCH,
																	  inputContainerNode);
								} else {
									resetNode(inputContainerNode);
								}
							} else {
								throw new ValidationFormException(ValidationException.WARNING, 
																  ValidationException.EMAIL_EMPTY_FIELD,
																  inputContainerNode);
							}
							
							break;
						case 'password':
			
							if (trimmedValue !== undefined && trimmedValue.length > 0) {
								if (!regExpForPassword.test(trimmedValue)) {
									passwordValue = trimmedValue;
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.PASSWORD_NOT_MATCH,
																	  inputContainerNode);
								} else {
									passwordValue = trimmedValue;
									resetNode(inputContainerNode);
								}
							} else {
								throw new ValidationFormException(ValidationException.WARNING, 
																  ValidationException.PASSWORD_EMPTY_FIELD,
																  inputContainerNode);
							}
							
							break;
						case 'confirm':
							
							if (trimmedValue !== undefined && trimmedValue.length > 0) {
								confirmValue = trimmedValue;
								resetNode(inputContainerNode);
							} else {
								throw new ValidationFormException(ValidationException.WARNING, 
																  ValidationException.CONFIRM_EMPTY_FIELD,
																  inputContainerNode);
							}
							
							break;
						default:
							console.log('Not a valid entry');
							break;
							
					}
					
					if (passwordValue !== undefined && confirmValue !== undefined) {
						if (regExpForPassword.test(passwordValue)) {
							if (passwordValue.length > 0 && confirmValue.length > 0) {
								if (passwordValue !== confirmValue) {
									throw new ValidationFormException(ValidationException.WARNING, 
																	  ValidationException.PASSWORD_NOT_EQUAL,
																	  inputContainerNode);
								} else {
									resetNode(inputContainerNode);
									let resetPasswordNode = (function() {
										wrongPasswordNode.children[0].innerText = '';
										wrongPasswordNode.parentElement.style.transition = 'none';
										wrongPasswordNode.parentElement.style.opacity = 0;
									})();
								}
							}
						}
					}
					
				}
				
			} catch (validationFormException) {
				
				if (validationFormException instanceof ValidationFormException) {
					validationFormException.handleRegisterErrorAfterSubmit();
				} else {
					throw validationFormException;
				}
				
			} 
		} 
	}
	
	inputsMap.forEach(validateInputsAfterSubmit);
	
});


