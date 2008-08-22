<html>
<head>
	<title>Change Password</title>
</head>
<body>
	{if $error ne ""}
		<span style='color:red'>Error: {$error}</span>
	{/if}
	{if $message ne ""}
		<span style='color:green'>{$message}</span>
	{/if}
	<form method='post' action='changepass.php'>
		Password: <input type='password' name='password' id='password' /><br />
		Confirm Password: <input type='password' name='confirm' /><br />
		<input type='submit' value='Change Password' />
	</form>
	<script type='text/javascript'>
	document.getElementById('password').focus();
	</script>
</body>
</html>