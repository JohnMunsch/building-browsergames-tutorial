<html>
<head>
	<title>The Armor Shop</title>
</head>
<body>
	<p>Welcome to the Armor Shop.</p>
	<p><a href='index.php'>Back to main</a></p>
	<h3>Current Armor:</h3>
	<ul>
		<li>
			Head:
			{if $ahead ne ''}
				{$ahead}
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='sell' value='ahead' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
		<li>
			Torso:
			{if $atorso ne ''}
				{$atorso}
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='sell' value='atorso' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
		<li>
			Legs:
			{if $alegs ne ''}
				{$alegs}
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='sell' value='alegs' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
		<li>
			Right Arm:
			{if $aright ne ''}
				{$aright}
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='sell' value='aright' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>
		<li>
			Left Arm:
			{if $aleft ne ''}
				{$aleft}
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='sell' value='aleft' />
					<input type='submit' value='Sell' />
				</form>
			{else}
				None
			{/if}
		</li>

	</ul>
	<p>You may purchase any of the armor listed below.</p>
	{if $error ne ''}
		<p style='color:red'>{$error}</p>
	{/if}
	{if $message ne ''}
		<p style='color:green'>{$message}</p>
	{/if}
	<ul>
		{foreach from=$armor key=id item=i}
			<li>
				<strong>{$i.name}</strong> - <em>{$i.price} gold coins</em>
				<form action='armor-shop.php' method='post'>
					<input type='hidden' name='armor-id' value='{$i.id}' />
					<input type='submit' value='Buy' />
				</form>
		{/foreach}
	</ul>
</body>
</html>