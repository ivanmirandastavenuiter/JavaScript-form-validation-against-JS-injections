/**
 * Name: ValidationJSPotentialInjectionException
 * 
 * Author: Ivan Miranda Stavenuiter
 * MKNA
 * 
 */

import { ValidationException } from './ValidationException.mjs';

export class ValidationJSPotentialInjectionException extends ValidationException {
	
	constructor(message, currentTag, key, overflown) {
		super(message);
		this.name = 'ValidationJSPotentialInjectionError';
		this.currentTag = currentTag;
		this.key = key;
		this.overflown = overflown;
	}
	
	handleError() {
		
		let currentTag = this.currentTag;
		let key = this.key;
		let overflown = this.overflown;
		
		if (!overflown) {
			
			if (currentTag === '&#60' || currentTag === '&#62') {
				
				key.value = key.value.replace(/&#0*6(0|2)/g, "");
				
			} else if (currentTag === '&#x3c' || currentTag === '&#x3e') {
				
				key.value = key.value.replace(/&#x0*3(c|e)/g, "");
				
			} else {
				
				key.value = key.value.replace(new RegExp(currentTag, "g"), "");
				
			}
			
		} else {
			
			// This acts in case of 0 character overflow in &#60, &#62, &#x3c, &#x3e entries
			
			if (key.value.indexOf('60') > -1 || key.value.indexOf('62') > -1) {
				if (key.value.indexOf('6') - key.value.indexOf('#') > 1) {
					key.value = key.value.replace(/&#0*6(0|2)/g, "");
				}
			}
			
			if (key.value.indexOf('3c') > -1 || key.value.indexOf('3e') > -1) {
				if (key.value.indexOf('3') - key.value.indexOf('x') > 1) {
					key.value = key.value.replace(/&#x0*3(c|e)/g, "");
				}
			}
			
		}
	}
	
}