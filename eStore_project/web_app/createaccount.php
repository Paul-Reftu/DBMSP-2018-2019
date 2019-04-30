<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Create an account to be able to use the full functionalities of the eStore Web App."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
		include("Header.php");
		include("Navbar.php");
	?>

	<main class="rmain">
	    <div class="register">
	        <!-- https://fandi-conference.com/register-icon/ -->
	        <img id="registerPhoto" src="assets/images/register.png"></img> 
	        <h1>Register</h1>

		    <form action=/register> 
			    <div>
			        <label for="registerUsername">Username*:</label>
			        <input type="text" required id="registerUsername" placeholder="Enter your username" />
			    </div>

			    <div>
			        <label for="registerPassword">Password*:</label>
			        <input type="password" required class="registerPassword" placeholder="Enter your password" />
			    </div>

			    <div>
			        <label for="registerPassword">Repeat Password*:</label>
			        <input type="password" required class="registerPassword" placeholder="Repeat password" />
			    </div>

			    <div>
			        <label for="registerEmail">E-mail*:</label>
			        <input type="text" required id="registerEmail" placeholder="Enter your E-mail" />
			    </div>

			    <div>
			        <label for="registerAddress">Address*:</label>
			        <input type="text" required id="registeAddress" placeholder="Enter your home address" />
			    </div>

			    <p id="required">All fields with * are required for register.</p>
			    <button type="submit">Register</button>
		    </form>
	    </div>
    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>