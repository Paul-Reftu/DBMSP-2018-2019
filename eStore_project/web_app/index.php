<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="The eStore Web Application is meant to simulate to the best of its ability how an online store is supposed to look like and to behave, with an emphasis on utilizing the aspects of Deep Learning techniques to provide relevant search results to the user *and* to illustrate a method with which many companies solve the Supply/Demand (Circulation/Demand) Problem - namely by using a tweaked version of the Ford-Fulkerson algorithm for solving the Max Flow Problem."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
		include("Header.php");
		include("Navbar.php");
                if(isset($_POST['logOut']))
                {
                    session_start();
                    session_unset();
                    session_destroy();
                }
	?>

	<main>
		<section>
			<br /> <br />
                        <form action="index.php" method="post" >
                            <input type='submit' name='logOut' value='LogOut' style="float:right" />
                        </form>
			<form action="index.php" method="GET">
				Search for a product: <br />
				<input type="text" name="searchKey" />
			</form>
		</section>
	</main>	


	<?php
		include("Search.php");
		include("Footer.php");
	?>
</body>

</html>