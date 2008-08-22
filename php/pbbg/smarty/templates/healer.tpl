<html>
<head>
	<title>The Healer</title>
</head>
<body>
	<p>Welcome to the healer. You currently have <strong>{$curhp}</strong> HP out of a maximum of <strong>{$maxhp}</strong>.</p>
	<p>You have <strong>{$gold}</strong> gold to heal yourself with, and it will cost you <strong>1 gold per HP healed</strong> to heal yourself.</p>
	{if $healed ne 0}
		<p>You have been healed for <strong>{$healed}</strong> HP.</p>
	{/if}
	<form action='healer.php' method='post'>
		<input type='text' name='amount' id='amount' /><br />
		<input type='submit' name='action' value='Heal Me' />
	</form>
	<p><a href='index.php'>Back to main</a></p>
	<script type='text/javascript'>
		document.getElementById('amount').focus();
	</script>
</body>
</html>