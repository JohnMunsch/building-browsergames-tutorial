<html>
<head>
	<title>Equipment Management</title>
</head>
<body>
	<h3>Current Equipment:</h3>
	<p><a href='index.php'>Back to main</a></p>
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
	<p>
		<form action='equipment.php' method='post'>
			<input type='submit' value='Swap' name='swap' />
		</form>
	</p>
</body>
</html>