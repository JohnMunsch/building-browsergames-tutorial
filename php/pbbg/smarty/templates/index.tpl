<html>
<head>
	<title>Index Page</title>
</head>
<body>
	<p>Hello, {$name}!</p>
	<ul>
		<li>Attack: <strong>{$attack}</strong></li>
		<li>Defence: <strong>{$defence}</strong></li>
		<li>Magic: <strong>{$magic}</strong></li>
		<li>Gold in hand: <strong>{$gold}</strong></li>
		<li>Current HP: <strong>{$currentHP}/{$maximumHP}</strong>
	</ul>
	<p><a href='logout.php'>Logout</a></p>
	<p><a href='explore.php?area=1'>Explore The Forest</a></p>
	<p><a href='inventory.php'>Your Inventory</a></p>
	<p><a href='bank.php'>The Bank</a></p>
	<p><a href='healer.php'>The Healer</a></p>
	<p><a href='weapon-shop.php'>The Weapon Shop</a></p>
	<p><a href='item-shop.php'>The Item Shop</a></p>
	<p><a href='equipment.php'>Equipment Management</a></p>
</body>
</html>