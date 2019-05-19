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
                $conn = oci_connect('PROIECT','PROIECT','localhost/XE') or die;
		include("Header.php");
		include("Navbar.php");
                function LogIn()
                {
                    global $conn;
                    $response = 0;
                    $username = $_POST['username'];
                    $password = $_POST['password'];
                    $sql = 'BEGIN LogIn(:username,:password,:response); END;';
                    $stmt = oci_parse($conn,$sql);
                    oci_bind_by_name($stmt,':username',$username,32);
                    oci_bind_by_name($stmt,':password',$password,32);
                    oci_bind_by_name($stmt,':response',$response,32);
                    oci_execute($stmt);
                    if ($response==1)
                    {
                        session_start();
                        $_SESSION['user'] = $username;
                        /*    put before !DOCTYPE this:
                         * 
                         *          session_start(); //starts all the sessions 
                                    if($_SESSION['user'] == NULL) {
                                        header('Location: login.php'); //take user to the login page if there's no information stored in session variable
                                    } 
                         * 
                         *     this should mantain login status */
                    }
                    else
                    {
                        echo 'Username or Password incorrect';
                    }
                        
                }
                if(isset($_POST['submit']))
                {
                    LogIn();
                }
	?>

	<main class="lmain">
        <div id="loginMain">
	        <!-- https://www.iconfinder.com/icons/480741/account_avatar_contact_guest_login_man_user_icon -->
	        <img id="loginPhoto" src="assets/images/login.png"></img>
	        <h1>Sign in</h1>

                <form class="login" action="login.php" method="post"> 
	        	<div id=loginUsername>
		            <label for="loginUsername">Username:</label>
		            <input type="text" required placeholder="Enter your username" name='username' />
	            </div>
	            <div id=loginPassword>
	                <label for="loginPassword">Password:</label>
	                <input type="password" required placeholder="Enter your password" name='password' />
	            </div>
	            <p><a href="forgotpassword.php">Forgot password?</a></p>
	            <a href="createaccount.php" id="register">Register</a>
	            <button type="submit" id="login" name="submit">Login</button>
	        </form>
    	</div>
    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>