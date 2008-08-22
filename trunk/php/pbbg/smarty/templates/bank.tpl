<html>
<head>
	<title>The Bank</title>
</head>
<body>
	<p>Welcome to the bank. You currently have <strong>{$inbank}</strong> gold in the bank, and <strong>{$gold}</strong> gold in hand.</p>
	{if $deposited ne 0}
		<p>You deposited <strong>{$deposited}</strong> gold into your bank account. Your total in the bank is now <strong>{$inbank}</strong>.</p>
	{/if}
	{if $withdrawn ne 0}
		<p>You withdraw <strong>{$withdrawn}</strong> gold from your bank account. Your total gold in hand is now <strong>{$gold}</strong>.</p>
	{/if}
	<form action='bank.php' method='post'>
		<input type='text' name='amount' id='amount' /><br />
		<input type='submit' name='action' value='Deposit' /> or 
		<input type='submit' name='action' value='Withdraw' />
	</form>
	<p><a href='index.php'>Back to main</a></p>
	<script type='text/javascript'>
		document.getElementById('amount').focus();
	</script>
</body>
</html>