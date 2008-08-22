<html>
<head>
	<title>Register</title>
</head>
<body>
	{if $message eq ""}
		<p><a href='login.php'>Already Registered?</a></p>
	{/if}
	{if $error ne ""}
		<span style='color:red'>Error: {$error}</span>
	{/if}
	{if $message ne ""}
		<span style='color:green'>{$message}</span>
		<p><a href='login.php'>Click here to log in</a></p>
	{/if}
	<form method='post' action='register.php'>
		Username: <input type='text' name='username' id='username' value='{$smarty.post.username}' /><br />
		Password: <input type='password' name='password' /><br />
		Confirm Password: <input type='password' name='confirm' /><br />
		<input type='submit' value='Register!' />
	</form>
	<script type='text/javascript'>
	document.getElementById('username').focus();
	</script>
</body>
</html>