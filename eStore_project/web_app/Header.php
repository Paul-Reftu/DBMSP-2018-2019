<?php
	class Header {
		public function __construct() {
			echo "<header id='main-header'>";
			echo "<a href='index.php'><img src='assets/images/logo.png' width=90% height=60% /></a>";
			echo "<h1>eStore</h1>";
			echo "</header>";
		}
	}

	new Header();
?>