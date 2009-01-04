<html>
<head>
	<title>The Forest</title>
</head>
<body>
	{if $combat eq ''}
		<p>You've encountered a {$monster}!</p>
		<form action='forest.php' method='post'>
			<input type='submit' name='action' value='Attack' /> or 
			<input type='submit' name='action' value='Run Away' />
			<input type='hidden' name='monster' value='{$monster}' />
		</form>
	{else}
		<ul>
		{foreach from=$combat key=id item=i}
			<li><strong>{$i.attacker}</strong> attacks {$i.defender} for {$i.damage} damage!</li>
		{/foreach}
		</ul>
		{if $won eq 1}
			<p>You killed <strong>{$smarty.post.monster}</strong>! You gained <strong>{$gold}</strong> gold, and {$exp} experience.</p>
			{if $level_up eq 1}
			    <p><strong>You gained a level!</strong></p>
			{/if}
			<p>You found a <strong>{$item}</strong>!</p>
			<p><a href='forest.php'>Explore Again</a></p>
		{/if}
		{if $lost eq 1}
			<p>You were killed by <strong>{$smarty.post.monster}</strong>.</p>
		{/if}		
			<p><a href='index.php'>Back to main</a></p>
	{/if}
</body>
</html>