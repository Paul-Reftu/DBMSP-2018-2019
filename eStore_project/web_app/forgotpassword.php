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
            $conn = oci_connect('PROIECT','PROIECT','localhost/XE') or die;
            include("Header.php");
            include("Navbar.php");
            function ResetPass()
                {
                    global $conn;
                    $response = 0;
                    $email = $_POST['email'];
                    $sql = 'BEGIN issuerestcode(:email,:response); END;';
                    $stmt = oci_parse($conn,$sql);
                    oci_bind_by_name($stmt,':email',$email,32);
                    oci_bind_by_name($stmt,':response',$response,32);
                    oci_execute($stmt);
                    if ($response==1)
                    {
                        echo '<p class="error">The email does not Exist</p>';
                    }
                    else
                    {
                        echo '<p class="success">Email sent</p>';
                    }
                        
                }
                if(isset($_POST['submit']))
                {
                    ResetPass();
                }
	?>

	<main class=mainFP>
        <div id=divFP>
            <img src="assets/images/forgpass.png" alt="An image with a lock indicating that here you can reset your password">
            <h1>Forgot password</h1>
            <form class="fp" action="forgotpassword.php" method='post'>
                 <form action="forgotpassword.php" method="post"> 
			    <div>
			        <label for="registerEmail">E-mail*:</label>
			        <input type="text" required id="registerEmail" placeholder="Enter your E-mail" name="email"/>
			    </div>
			    <p id="required">All fields with * are required.</p>
			    <button id="FP" type="submit" name="submit">Send Email</button>
		    </form>
            </form>
        </div>

    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>