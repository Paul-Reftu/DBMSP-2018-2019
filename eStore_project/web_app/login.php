<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Log in to eStore."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
		include("Header.php");
		include("Navbar.php");
	?>

	<main class="lmain">
        <div id="loginMain">
	        <!-- https://www.iconfinder.com/icons/480741/account_avatar_contact_guest_login_man_user_icon -->
	        <img id="loginPhoto" src="assets/images/login.png"></img>
	        <h1>Sign in</h1>

	        <form class="login" action=/login> 
	        	<div id=loginUsername>
		            <label for="loginUsername">Username:</label>
		            <input type="text" required placeholder="Enter your username" />
	            </div>
	            <div id=loginPassword>
	                <label for="loginPassword">Password:</label>
	                <input type="password" required placeholder="Enter your password" />
	            </div>
	            <p><a href="forgotpassword.php">Forgot password?</a></p>
	            <a href="createaccount.php" id="register">Register</a>
	            <button type="submit" id="login">Login</button>
	        </form>
    	</div>
    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>