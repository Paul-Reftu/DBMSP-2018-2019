<?php session_start(); //starts all the sessions 
        if($_SESSION['user'] == NULL) {
            header('Location: login.php'); //take user to the login page if there's no information stored in session variable
        } ?>

<?php
	class Basket {
		private $username = "PROIECT";
		private $password = "PROIECT";
		private $connPath = "localhost/XE";
		private $basketCookieName = "shoppingCart";

		function __construct() {
			if (isset($_COOKIE[$this->basketCookieName])) {
                                if(isset($_POST["buy"]))
                                {
                                    $conn = oci_connect($this->username, $this->password, $this->connPath);

				if (!$conn) {
					$error = oci_error();
					trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
				}

				$query = "SELECT products.id, name, description, username, type, price 
					FROM products 
					JOIN users ON products.sellerid = users.id
					WHERE products.id IN (" . 
					$_COOKIE[$this->basketCookieName] . ")";
                                global $statement;
				$statement = oci_parse($conn, $query);
				//oci_bind_by_name($statement, ":productId", 
				//	explode(", ", $_COOKIE[$this->basketCookieName]);
				oci_execute($statement);
                                    while ($row = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS)) {
					$sql2 = 'BEGIN placeOrder(:bid,:prodid); END;';
                                        $stmt2 = oci_parse($conn,$sql2);
                                        oci_bind_by_name($stmt2,':bid',$_SESSION['id'],32);
                                        oci_bind_by_name($stmt2,':prodid',$row["ID"],32);
                                        oci_execute($stmt2);
				}
                                setcookie($this->basketCookieName, null, time() - 3600, "/");
					header("Refresh:0, url=" . $_SERVER["PHP_SELF"]);
                                }
                            
				if (isset($_POST["emptyBasket"])) {
					setcookie($this->basketCookieName, null, time() - 3600, "/");
					header("Refresh:0, url=" . $_SERVER["PHP_SELF"]);
				}

				echo "Your shopping cart contents: " . "<br/>";

				$conn = oci_connect($this->username, $this->password, $this->connPath);

				if (!$conn) {
					$error = oci_error();
					trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
				}

				$query = "SELECT products.id, name, description, username, type, price 
					FROM products 
					JOIN users ON products.sellerid = users.id
					WHERE products.id IN (" . 
					$_COOKIE[$this->basketCookieName] . ")";
                                global $statement;
				$statement = oci_parse($conn, $query);
				//oci_bind_by_name($statement, ":productId", 
				//	explode(", ", $_COOKIE[$this->basketCookieName]);
				oci_execute($statement);

				echo "<br/>";
				echo "<table border='1'>\n";
				echo "<th>id</th>";
				echo "<th>name</th>";
				echo "<th>description</th>";
				echo "<th>seller</th>";
				echo "<th>type</th>";
				echo "<th>price</th>";
				while ($row = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS)) {
					echo "<tr>\n";

					foreach ($row as $item) {
					   echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
					}
					echo "</tr>\n";
				}
				echo "</table>\n";
				echo "<br/>";

				echo "<form action=" . $_SERVER["PHP_SELF"] . " method=POST>";
				echo "<input type='submit' name='emptyBasket' value='Clear basket'/>";
                                
				echo "</form>";
                                echo "<form action=" . $_SERVER["PHP_SELF"] . " method=POST>";
				echo "<input type='submit' name='buy' value='Buy'/>";
                               
				echo "</form>";
			}
			else {
				echo "Your shopping cart is currently empty.";
			}

		}
	}

	new Basket();
?>