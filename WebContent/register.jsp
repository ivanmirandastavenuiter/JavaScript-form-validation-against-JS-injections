<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<link href="https://fonts.googleapis.com/css?family=Merriweather&display=swap" rel="stylesheet">
<script type="module" src="Validations/ValidationRegister.mjs"></script>
<style>

	body {
		background: #464c80;
		margin: 0;
		padding: 0;
		height: 100%;
		font-size: 62.5%; /* This is equivalent to 10px */
		font-family: 'Merriweather', serif;
	}

	div.main-container-div {
		height: 150%;
		display: flex;
		justify-content: center;
	}

	div.form-container-div {
		margin: 100px;
		border-radius: 6px;
		background: #fff;
		width: 500px;
		box-shadow: 1px 1px 25px 1px #000; 
	}

	div.form-container-div form {
		padding: 10px 30px 30px 30px;
		font-size: 1.6em;
	}
	
	div.form-container-div .register-div {
		padding: 10px;
		text-align: center;
		border-radius: 5px 5px 0 0;
	}

	div.form-container-div .register-div h1 {
		font-size: 3.5em;
	}

	/* Inside form-container-div */

	.inputs-group-div {
		padding: 15px;
	}

	.inputs-group-div .input-div {
		width: 400px;
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin: 0 auto;
	}

	.inputs-group-div .input-div .form-input {
		width: 63%;
		height: 20px;
		font-family: inherit;
		font-size: .8em;
		outline: none;
		border: 1px solid #464c80;
		padding: 5px;
	}

	.inputs-group-div div[class$="wrong-validation-div"] {
		display: flex;
		justify-content: flex-end;
		width: 400px;
		margin: 0 auto;
		opacity: 0;
		transition: opacity .5s linear;
	}

	.inputs-group-div div[class$="wrong-validation-div"] p {
		width: 63%;
		padding: 5px;
		font-size: .7em;
		border: 1px solid #e21010;
		color: #e21010;
	}

	.inputs-group-div .input-div label {
		height: 20px;
		padding: 3px;
	}

	.inputs-group-div .input-div .submit-btn {
		font-family: inherit;
		font-size: .8em;
		margin: 15px auto 5px auto;
		width: 40%;
		padding: 5px;
		color: #fff;
		background: #464c80;
		border-radius: 20px;
		height: 30px;
		border: none;
		transition: background-color .3s linear;
		outline: none;
	}

	.inputs-group-div .login-back-link-div {
		text-align: center;
	}

	.inputs-group-div .login-back-link-div span {
		color: #464c80;
		font-size: 0.75em;
		display: block;
		margin-top: 10px;
	}

	/* Buttons, boxes and links interactions */

	.inputs-group-div .input-div .submit-btn:hover {
		background:#666dad;
	}

	.inputs-group-div .input-div .submit-btn:active {
		background: #272b50;
		transition: none;
		border: 1.5px solid #bfc4fd;
	}

	.inputs-group-div .input-div .form-input:focus {
		background: #d1d8f1;
		border: 1px solid #000;
	}
	
	.inputs-group-div .form-input:-internal-autofill-selected {
		background-color: #d1d8f1 !important;
		border: 1px solid #000 !important;
	}
	
	.inputs-group-div .input-div .submit-btn:focus {
		background: #272b50;
		transition: none;
		border: 1.5px solid #bfc4fd;
	}
 
	.inputs-group-div .login-back-link-div span a:visited,
	.inputs-group-div .login-back-link-div span a:active {
		color: inherit;
	}

</style>
</head>
<body>

	<!-- Main container -->
	<div class="main-container-div">

		<div class="form-container-div">
	
			<!-- Register div -->
			<div class="register-div">
				<h1>Register</h1>
			</div>

			<!-- Form -->
			<form name="registerForm" method="post">

				<div class="inputs-group-div">
				
					<!-- Input item -->
					<div class="input-div">
						<label for="name">Name</label>
						<input class="form-input" type="text" name="name"/>
					</div>

					<!-- Error item -->
					<div class="name-wrong-validation-div">
						<p class="name-wrong-validation"><span></span></p>
					</div>
					
					<!-- Input item -->
					<div class="input-div">
						<label for="surname">Surname</label>
						<input class="form-input" type="text" name="surname"/>
					</div>

					<!-- Error item -->
					<div class="surname-wrong-validation-div">
						<p class="surname-wrong-validation"><span></span></p>
					</div>
					
					<!-- Input item -->
					<div class="input-div">
						<label for="username">Username</label>
						<input class="form-input" type="text" name="username"/>
					</div>

					<!-- Error item -->
					<div class="username-wrong-validation-div">
						<p class="username-wrong-validation"><span></span></p>
					</div>
				
					<!-- Input item -->
					<div class="input-div">
						<label for="phone">Phone</label>
						<input class="form-input" type="text" name="phone"/>
					</div>

					<!-- Error item -->
					<div class="phone-wrong-validation-div">
						<p class="phone-wrong-validation"><span></span></p>
					</div>
					
					<!-- Input item -->
					<div class="input-div">
						<label for="email">Email</label>
						<input class="form-input" type="text" name="email"/>
					</div>

					<!-- Error item -->
					<div class="email-wrong-validation-div">
						<p class="email-wrong-validation"><span></span></p>
					</div>
					
					<!-- Input item -->
					<div class="input-div">
						<label for="password">Password</label>
						<input class="form-input" type="password" name="password"/>
					</div>

					<!-- Error item -->
					<div class="password-wrong-validation-div">
						<p class="password-wrong-validation"><span></span></p>
					</div>
					
					<!-- Input item -->
					<div class="input-div">
						<label for="confirm">Confirm</label>
						<input class="form-input" type="password" name="confirm"/>
					</div>

					<!-- Error item -->
					<div class="confirm-wrong-validation-div">
						<p class="confirm-wrong-validation"><span></span></p>
					</div>
										
					<div class="input-div">
						<input class="submit-btn" type="submit" value="Register"/>
					</div>

					<div class="login-back-link-div">
						<span><a href="./index.jsp">Back to login</a></span>
					</div>

				</div>
			
			</form>

		</div>
		
	</div>
	
</body>
</html>

