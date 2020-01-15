/**
 * Name: ValidationFormException
 * 
 * Author: Ivan Miranda Stavenuiter
 * MKNA
 * 
 */

import { ValidationException } from './ValidationException.mjs';

export class ValidationFormException extends ValidationException {
	
	constructor(message, description, htmlNode) {
		super(message);
		this.name = 'ValidationFormError';
		this.description = description;
		this.htmlNode = htmlNode;
	}
	
	handleRegisterErrorOnSubmit() {
		
		let inputContainerNode = this.htmlNode;
		let spanErrorTag = inputContainerNode.children[0].children[0];
		
		spanErrorTag.innerText = this.description;
		inputContainerNode.style.opacity = 1;
		
	}
	
	handleRegisterErrorAfterSubmit() {
		
		let inputContainerNode = this.htmlNode;
		let spanErrorTag = inputContainerNode.children[0].children[0];
		
		spanErrorTag.innerText = this.description;
		inputContainerNode.style.transition = 'opacity .5s linear';
		inputContainerNode.style.opacity = 1;
		
	}
	
	handleLoginErrorOnSubmit() {
		
		let wrongMessageNode = this.htmlNode;
		
		wrongMessageNode.innerText = this.description;
		wrongMessageNode.parentElement.style.opacity = 1;
		
	}
	
	handleLoginErrorAfterSubmit() {
		
		let wrongMessageNode = this.htmlNode;
		
		wrongMessageNode.parentElement.style.transition = 'opacity .5s linear';
		wrongMessageNode.parentElement.style.opacity = 1;
		wrongMessageNode.innerText = this.description;
		
	}
	
}