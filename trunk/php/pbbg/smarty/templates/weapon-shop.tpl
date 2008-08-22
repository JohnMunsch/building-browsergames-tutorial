<html>
<head>
	<title>The Weapon Shop</title>
</head>
<body>
	<p>Welcome to the Weapon Shop.</p>
	<p><a href='index.php'>Back to main</a></p>
	<h3>Current Equipment:</h3>
	<ul>
		<li>
			Primary Hand:
			{if $phand ne ''}
				{$phand}
				<form action='weapon-shop.php' method='post'>
					<input type='hidden' name='sell' value='phand' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
		<li>
			Secondary Hand:
			{if $shand ne ''}
				{$shand}
				<form action='weapon-shop.php' method='post'>
					<input type='hidden' name='sell' value='shand' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
	</ul>
	<p>Below are the weapons currently available for purchase.</p>
	{if $error ne ''}
		<p style='color:red'>{$error}</p>
	{/if}
	{if $message ne ''}
		<p style='color:green'>{$message}</p>
	{/if}
	<ul>
		{foreach from=$weapons key=id item=i}
			<li>
				<strong>{$i.name}</strong> - <em>{$i.price} gold coins</em>
				<form action='weapon-shop.php' method='post'>
					<input type='hidden' name='weapon-id' value='{$i.id}' />
					<input type='submit' value='Buy' />
				</form>
		{/foreach}
	</ul>
</body>
</html>