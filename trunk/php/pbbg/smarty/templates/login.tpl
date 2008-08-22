<html>
<head>
	<title>Login</title>
</head>
<body>
	{if $error ne ""}
		<span style='color:red'>Error: {$error}</span>
	{/if}
	<p><a href='register.php'>Not registered yet?</a></p>
	<form action='login.php' method='post'>
		Username: <input type='text' name='username' id='username' value='{$smarty.post.username}' /><br />
		Password: <input type='password' name='password' /><br />
		<input type='submit' value='Login' />
	</form>	
	<script type='text/javascript'>
	document.getElementById('username').focus();
	</script>
</body>
</html>