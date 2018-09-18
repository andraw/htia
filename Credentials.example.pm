package Credentials;

### FILL IN WHAT YOU NEED TO ###
### SAVE AS Credentials.pm   ###

use strict; use warnings;

use parent 'Exporter'; 

our $username = "you";
our $client_id = "something";
our $client_secret = "orother";

our @EXPORT = qw($username $client_id $client_secret);

1;

