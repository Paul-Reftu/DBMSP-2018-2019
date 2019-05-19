

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
                function IsValid()
                {
                    global $code;
                    global $conn;
                    $response = 0;
                    $code = $_GET['code'];
                    $sql = 'BEGIN IsCodeValid(:code,:response); END;';
                    $stmt = oci_parse($conn,$sql);
                    oci_bind_by_name($stmt,':code',$code,1000);
                    oci_bind_by_name($stmt,':response',$response,32);
                    oci_execute($stmt);
                    if ($response==1)
                    {
                        if(isset($_POST['password']))
                        {
                            $password = $_POST['password'];
                            if(preg_match("/^(?=.*([[:lower:]])+)(?=.*([[:upper:]])+)(?=.*([[:digit:]])+)(?=.*([[:punct:]])+)[[:lower:][:upper:][:digit:][:punct:]]{8,20}$/", $password))
                            {
                                $sql2 = 'BEGIN changePass(:code2,:password,:response); END;';
                                $password = $_POST['password'];
                                $stmt2 = oci_parse($conn,$sql2);
                                oci_bind_by_name($stmt2,':code2',$code,1000);
                                oci_bind_by_name($stmt2,':password',$password,32);
                                oci_bind_by_name($stmt2,':response',$response,32);
                                oci_execute($stmt2);
                            }
                            else
                            {
                                echo 'invalid pass';
                            }
                        }
                    }
                    else
                    {
                        echo 'Code is invalid';
                        exit(0);
                    }
                        
                }
                if(isset($_GET['code']))
                {
                    IsValid();
                }
                else
                {
                    echo 'The link is invalid';
                    exit(0);
                }
                    
	?>

	<main class="lmain">
        <div id="loginMain">
	        <!-- https://www.iconfinder.com/icons/480741/account_avatar_contact_guest_login_man_user_icon -->
	        <img id="loginPhoto" src="assets/images/login.png"></img>
	        <h1>Change Password</h1>
                <?php
                global $code ;
                echo '<form class="login" action="changePass.php?code=' ;
                echo $code;
                echo '" method="post"> ' . 
                    '   
	            <div id=loginPassword>
	                <label for="loginPassword">Password:</label>
	                <input type="password" required placeholder="Enter your new password" name="password" />
                    </div>
	            <a href="createaccount.php" id="register">Register</a>
	            <button type="submit" id="login" name="submit">Change Password</button>
	        </form>';
                    ?>
                <p> The password should:</p>
                <ul>
                    <li>Have at least one uppercase letter</li>
                    <li>Have at least one lowercase letter</li>
                    <li>Have at least one number</li>
                    <li>Have at least one special character</li>
                </ul>
    	</div>
    </main>

	<?php
		include("Footer.php");
	?>
</body>

</html>