<?php session_start(); //starts all the sessions 
        if($_SESSION['user'] == NULL) {
            header('Location: login.php'); //take user to the login page if there's no information stored in session variable
        } ?>

<!DOCTYPE html>
<html lang="en-US">
<head>
	<title>eStore</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Reftu Paul Alexandru, Curea Paul Andrei"/>
	<meta name="description" content="Have a product that you want to sell to the world? This platform is going to help you out through that process."/>
	<!-- Icon obtained from: http://expresso.estadao.com.br/economia-negocios/e-hora-de-se-auto-presentear/  -->
	<link rel="shortcut icon" href="assets/images/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="stylesheet.css" type="text/css"/>
</head>

<body>
	<?php
                $conn = oci_connect('PROIECT','PROIECT','localhost/XE') or die;
		include("Header.php");
		include("Navbar.php");
                function Sell()
                {
                    global $conn;
                    $prodname = $_POST['prodname'];
                    $proddes = $_POST['proddes'];
                    $prodtype = $_POST['prodtype'];
                    $prodprice = $_POST['prodprice'];
                    $sql = 'BEGIN Sell(:selid,:prodname,:proddes,:prodtype,:prodprice); END;';
                    $stmt = oci_parse($conn,$sql);
                    oci_bind_by_name($stmt,':selid',$_SESSION['id'],32);
                    oci_bind_by_name($stmt,':prodname',$prodname,32);
                    oci_bind_by_name($stmt,':proddes',$proddes,1000);
                    oci_bind_by_name($stmt,':prodtype',$prodtype,32);
                    oci_bind_by_name($stmt,':prodprice',$prodprice,32);
                    oci_execute($stmt);
                }
                if(isset($_POST['sell']))
                {
                    Sell();
                }
	?>

	<form class="sell" action="sell.php" method="post"> 
	            <div id=prodName>
		            <label for="prodName">Product Name:</label>
		            <input type="text" required placeholder="Enter product name" name='prodname' />
	            </div>
                    <br>
	            <div id=prodDescription>
		            <label for="prodDescription" >Product Description:</label>
                            <textarea  placeholder="Item description here" required name='proddes' id='proddes' class='proddes'></textarea>
	            </div>
                    <br>
                     <div id=prodType>
		            <label for="prodName">Type:</label>
		            <input type="text" required placeholder="Enter product type" name='prodtype' /> 
	            </div>
                    <br>
                    <div id=prodPrice>
		            <label for="prodPrice">Price:</label>
		            <input type="number"  step="0.01" required placeholder="Enter product price" name='prodprice' />
	            </div>
	            <button type="submit" id="sell" name="sell">Sell</button>
	        </form>

	<?php
		include("Footer.php");
	?>
</body>

</html>