<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Here you will be able to see the solution to the supply delivery that all our customers demand - in our world graph."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
                /*session_start();
                session_unset();
                session_destroy();!/
                 * 
                 */
                $conn = oci_connect('PROIECT','PROIECT','localhost/XE') or die;
		include("Header.php");
		include("Navbar.php");
                function getInfo()
                {
                    global $conn;
                    $flow = 0;
                    $actually = 0;
                    $names = "";
                    $sql = 'BEGIN FlowToday(:flow,:actually,:names); END;';
                    $stmt = oci_parse($conn,$sql);
                    oci_bind_by_name($stmt,':flow',$flow,32);
                    oci_bind_by_name($stmt,':actually',$actually,32);
                    oci_bind_by_name($stmt,':names',$names,10000);
                    oci_execute($stmt);
                    echo '<p>The maximum amount of packages that we can send today are:' . $flow . '</p>';
                    echo '<p>The number of packets that we plan on sending today:' . $actually . '</p>';
                    $names = str_replace(', ','<br>',$names);
                    echo '<p>List of countryes that we plan on sending packages today:' . $names . '</p>';
                }
                    
                getInfo();

	?>
	
	<?php
		include("Footer.php");
	?>
</body>

</html>