<?php
	class Search {
		private $username = "STUDENT";
		private $password = "student0";
		private $connPath = "localhost/XE";

		function __construct() {
			if (isset($_GET["searchKey"])) {
				$conn = oci_connect($this->username, $this->password, $this->connPath);

				if (!$conn) {
					$error = oci_error();
					trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
				}

				$query = "SELECT products.id, name, description, username, type, price FROM products 
					JOIN users ON products.sellerid = users.id
					WHERE name LIKE '%' || :searchKey 
					 || '%' OR description LIKE '%' || :searchKey || '%'";
				$statement = oci_parse($conn, $query);
				oci_bind_by_name($statement, ":searchKey", $_GET["searchKey"]);
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

				echo "<form action=" . $_SERVER["PHP_SELF"] . " method='POST'>";
				echo "Please type in the id of the product you wish to add to your basket:" . "<br/>";
				echo "<input type='text' name='productId' />";
				echo "</form>";
			}

			if (isset($_POST["productId"])) {
				$cookie_name = "shoppingCart";

				if (!isset($_COOKIE[$cookie_name]))
					$cookie_value = $_POST["productId"];
				else
					$cookie_value = $_COOKIE[$cookie_name] . "," . $_POST["productId"]; 

				/*
				 * the cookie will expire in 30 days
				 */
				setcookie($cookie_name, $cookie_value, time() + (86400 * 30), "/");
				header("Refresh:0, url=" . $_SERVER["PHP_SELF"]);
			}

		}
	}

	new Search();
?>