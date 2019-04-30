<!DOCTYPE html>
<html>
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Information regarding the purpose of this Web Application."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php 
		include("Header.php");
		include("Navbar.php");
	?>

	<main>
		<section class="facilities">
			<h2>What is this application for?</h2>
			<p>
				The purpose of this application is to simulate the inner-workings of an electronic store, specifically providing the following functionalities: 
			</p>

			<ul>
				<li>An environment that imitates real-time user merchandise purchasing and selling.</li>
				<li>A mechanism that lowers the risk of security attacks such as Brute Force or Dictionary Attacks - methods whose aim is to crack users' passwords to gain access to their accounts - by forbidding the use of <strong>weak</strong> passwords.</li>
				<li>Real-time notifications regarding suspicious activity such as too many consecutive failed attempts to log in.</li>
				<li>Relevance-based search of products (based on the user's past searches) - using Deep Learning techniques.</li>
				<li>A solution to the Supply/Demand (Circulation/Demand) Problem using a version of the Ford-Fulkerson algorithm for Max Flow computation.</li>
			</ul>
		</section>
	</main>


	<?php
		include("Footer.php");
	?>
</body>
</html>