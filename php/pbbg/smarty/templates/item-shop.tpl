<html>
<head>
	<title>The Item Shop</title>
</head>
<body>
	<p>Welcome to the Item Shop.</p>
	<p><a href='index.php'>Back to main</a></p>
	<h3>Current Inventory:</h3>
	<ul>
		{foreach from=$inventory key=item_id item=i}
		<li>
			{$i.name} x {$i.quantity}
			<form action='item-shop.php' method='post'>
				<input type='hidden' name='sell-id' value='{$i.item_id}' />
				<input type='submit' value='Sell' />
			</form>
		</li>
		{/foreach}
	</ul>
	<p>You may purchase any of the items listed below.</p>
	{if $error ne ''}
		<p style='color:red'>{$error}</p>
	{/if}
	{if $message ne ''}
		<p style='color:green'>{$message}</p>
	{/if}
	<ul>
		{foreach from=$items key=id item=i}
			<li>
				<strong>{$i.name}</strong> - <em>{$i.price} gold coins</em>
				<form action='item-shop.php' method='post'>
					<input type='hidden' name='item-id' value='{$i.id}' />
					<input type='submit' value='Buy' />
				</form>
		{/foreach}
	</ul>
</body>
</html>