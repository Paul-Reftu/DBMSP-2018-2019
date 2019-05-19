
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
		$conn = oci_connect('PROIECT','PROIECT','localhost/XE') or die;
		include("Header.php");
		include("Navbar.php");
                function Register()
                {
                    global $conn;
                    $response = 0;
                    $username = $_POST['username'];
                    if(preg_match('/^(?=.*([[:lower:]])*)(?=.*([[:upper:]])*)(?=.*([[:digit:]])*)(?=.*([[:punct:]])*)[[:lower:][:upper:][:digit:][:punct:]]{8,20}$/', $username))
                    {
                        $email = $_POST['email'];
                        if (preg_match('/^(?=.*([[:lower:]])*)(?=.*([[:upper:]])*)(?=.*([[:digit:]])*)(?=.*([[:punct:]])*)[[:lower:][:upper:][:digit:][:punct:]]{3,}@(?=.*([[:lower:]])*)(?=.*([[:upper:]])*)(?=.*([[:digit:]])*)(?=.*([[:punct:]])*)[[:lower:][:upper:][:digit:][:punct:]]{3,}\.(?=.*([[:lower:]])*)[[:lower:]]{2,}$/', $email))
                        {
                            $location = $_POST['location'];
                            $sql2 =  'BEGIN ValidAdress(:location,:response); END;';
                            $stmt2 = oci_parse($conn,$sql2);
                            oci_bind_by_name($stmt2,':location',$location,32);
                            oci_bind_by_name($stmt2,':response',$response,32);
                            oci_execute($stmt2);
                            if($response == 1)
                            {
                                $sql = 'BEGIN Register(:username,:email,:location,:response); END;';
                                $stmt = oci_parse($conn,$sql);
                                oci_bind_by_name($stmt,':username',$username,32);
                                oci_bind_by_name($stmt,':email',$email,32);
                                oci_bind_by_name($stmt,':location',$location,32);
                                oci_bind_by_name($stmt,':response',$response,32);
                                oci_execute($stmt);
                                if ($response==1)
                                {
                                    echo '<p class="error"> Email already in database </p>';
                                }
                                elseif($response == 2)
                                {
                                    echo '<p class="error">Username already in database</p>';
                                }
                                elseif($response ==0)
                                {
                                    echo '<p class="success">Register success</p>';
                                }
                            }
                            else
                            {
                                echo '<p class="error">invalid location</p>';
                            }
                            
                        }
                        else
                        {
                            echo '<p class="error">invalid email</p>';
                        }
                        
                    }
                    else
                    {
                        echo '<p class="error">invalid username</p>';
                       
                    }
                    
                        
                }
                if(isset($_POST['submit']))
                {
                    Register();
                }
	?>
                
	<main class="rmain">
	    <div class="register">
	        <!-- https://fandi-conference.com/register-icon/ -->
	        <img id="registerPhoto" src="assets/images/register.png"></img> 
	        <h1>Register</h1>

		    <form action="createaccount.php" method="post"> 
			    <div>
			        <label for="registerUsername">Username*:</label>
			        <input type="text" required id="registerUsername" placeholder="Enter your username" name="username" />
			    </div>

			    <div>
			        <label for="registerEmail">E-mail*:</label>
			        <input type="text" required id="registerEmail" placeholder="Enter your E-mail" name="email"/>
			    </div>

			    <div>
			        <label for="registerAddress">Address*:</label>
			        <input type="text" required id="registeAddress" placeholder="Enter your home address" name="location"/>
			    </div>

			    <p id="required">All fields with * are required for register.</p>
			    <button type="submit" name="submit">Register</button>
		    </form>
	    </div>
    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>