<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Forgot your password for your eStore account? Let us help you out!"/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
		include("Header.php");
		include("Navbar.php");
	?>

	<main class=mainFP>
        <div id=divFP>
            <img src="assets/images/forgpass.png" alt="An image with a lock indicating that here you can reset your password">
            <h1>Forgot password</h1>
            <form class="fp">
                <div id=mailFP>
                    <label>Please enter your E-mail:<input name="ForgotPasswordMAil" type="text" required placeholder="Enter your E-mail here"></label>
                </div>

                <button type="submit" id="FP">Reset password</button>
            </form>
        </div>

    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>