<html>
<head>
	<title>Your Inventory</title>
</head>
<body>
	<p>This is your inventory. Check out all the stuff you've got!</p>
	<ul>
		{foreach from=$inventory key=id item=i}
		<li>
			<strong>{$i.name} x {$i.quantity}</strong>
			<form action='inventory.php' method='post'>
				<input type='hidden' name='item-id' value='{$i.id}' />
				<input type='submit' value='Use' />
			</form>
		</li>
		{/foreach}
	</ul>
</body>
</html>