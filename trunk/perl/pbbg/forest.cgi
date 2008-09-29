#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use HTML::Template;
use DBI;
use config;
use weaponstats;
 
my $query = new CGI;
my %arguments = $query->Vars;

my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth;
my %parameters;

if(%arguments) {
	if($arguments{action} eq 'Attack') {
		# fighting the monster	
		use stats;
		use monsterstats;
		my $cookie = $query->cookie('username+password'); 
		my ($username) = split(/\+/,$cookie);
		$sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
		$sth->execute($username);
		my $userID;
		$sth->bind_columns(\$userID);
		$sth->fetch;
		my %player = (
			name		=>	$username,
			attack		=>	stats::getStat('atk',$userID),
			defence		=>	stats::getStat('def',$userID),
			curhp		=>	stats::getStat('curhp',$userID)
		);
		my $phand = stats::getStat('phand',$userID);
		$player{attack} += weaponstats::getWeaponStat('atk',$phand);
		use armorstats;
		my @armor = qw(atorso ahead alegs aright aleft);
		foreach my $key(@armor) {
			my $id = stats::getStat($key,$userID);
			my $defence = armorstats::getArmorStat('defence',$id);
			$player{defence} += $defence;
		}		
		$sth = $dbh->prepare("SELECT id FROM monsters WHERE name = ?");
		$sth->execute($arguments{monster});
		my $monsterID;
		$sth->bind_columns(\$monsterID);
		$sth->fetch;
		my %monster = (
			name		=>	$arguments{monster},
			attack		=>	monsterstats::getMonsterStat('atk',$monsterID),
			defence		=>	monsterstats::getMonsterStat('def',$monsterID),
			curhp		=>	monsterstats::getMonsterStat('maxhp',$monsterID)
		);
		my @combat;
		my $turns = 0;
		my ($attacker,$defender);
		while($player{curhp} > 0 && $monster{curhp} > 0) {
			my %attack;
			if($turns % 2 != 0) {
				$attacker = \%monster;
				$defender = \%player;
			} else {
				$attacker = \%player;
				$defender = \%monster;
			}
			my $damage = 0;
			if($attacker->{attack} > $defender->{defence}) {
				$damage = $attacker->{attack} - $defender->{defence};	
			}
			my %attack = (
				attacker => $attacker->{name},
				defender => $defender->{name},
				damage => $damage
			);
			$defender->{curhp} -= $damage;
			push @combat, \%attack;
			$turns++;
		}
		stats::setStat('curhp',$userID,$player{curhp});
		if($player{curhp} > 0) {
			# player won
			stats::setStat('gc',$userID,stats::getStat('gc',$userID) + monsterstats::getMonsterStat('gc',$monsterID));
			$parameters{won} = 1;
			$parameters{gold} = monsterstats::getMonsterStat('gc',$monsterID);
		} else {
			# monster won	
			$parameters{lost} = 1;
		}
		$parameters{combat} = \@combat;
	} else {
		# running away - back to the index page!
		print $query->redirect('index.cgi');
	}	
} else {
	$sth = $dbh->prepare("SELECT name FROM monsters ORDER BY RAND() LIMIT 1");
	$sth->execute();
	my $monster;
	$sth->bind_columns(\$monster);
	$sth->fetch;
	$parameters{monster} = $monster;
}


my $template = HTML::Template->new(
		filename	=>	'forest.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;