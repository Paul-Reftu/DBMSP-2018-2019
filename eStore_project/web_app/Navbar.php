<?php

	class Navbar {
		/*
		 * the URL of the current page that the user is visiting
		 */
		private $currPage;
		/*
		 * all the URLs where the user can navigate on our application
		 */
		private $navURLs = array("index.php", "about.php", "contact.php", "sell.php", "supplydemand.php", "login.php", "createaccount.php", "shoppingcart.php");
		/*
		 * the corresponding textual names of the navigation URLs
		 */
		private $navURLNames = array("Home", "About", "Contact", "Sell", "Supply & Demand", "Login", "Create Account", "Your Shopping Cart");

		public function __construct() {
			$this->currPage = basename($_SERVER['PHP_SELF']);

            echo "<nav>";
            echo "<ul>";

            for ($i = 0; $i < sizeof($this->navURLs); $i++) {
                if ($this->navURLs[$i] == $this->currPage) {
                    echo "<li>" . $this->navURLNames[$i] . "</li>";
                }
                else {
                    echo "<li><a href='" . $this->navURLs[$i] . "'>" . $this->navURLNames[$i] . "</a></li>";
                }
            }

            echo "</ul>";
            echo "</nav>";
		}
	}

	new Navbar();

?>