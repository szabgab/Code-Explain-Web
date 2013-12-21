package Code::Explain::Web;
use Dancer ':syntax';

our $VERSION = '0.1';

my $LIMIT = 20;

use Code::Explain;


=head1 NAME

Code::Explain::Web - Experimental web interface for the Code::Explain service

=head1 SYNOPSIS

L<http://code.szabgab.com/>


=head1 DESCRIPTION

=head1 Author

Gabor Szabo L<http://szabgab.com/>

=cut

get '/' => sub {
	my %data = (
		code_explain_version => $Code::Explain::VERSION,
		limit                => $LIMIT,
	);
	return template 'index', \%data;
};

post '/explain' => sub {
	my $code = params->{'code'};
	$code = '' if not defined $code;
	$code =~ s/^\s+|\s+$//g;

	my %data = (
		code_explain_version => $Code::Explain::VERSION,
		limit                => $LIMIT,
		code                 => $code,
	);
	if ($code) {
		$data{html_code} = _escape($code);
		if (length $code > $LIMIT) {
			$data{too_long} = length $code;
		} else {
			my $time = time;
			my $log_file = path( config->{appdir}, 'logs', 'code.txt' );
			if ( open my $fh, '>>', $log_file ) {
				print $fh "$time - $code\n\n";
				close $fh;
			}
			require Code::Explain;
			my $ce = Code::Explain->new( code => $code );
			$data{explanation} = $ce->explain();
			$data{ppi_dump}    = [ map { _escape($_) } $ce->ppi_dump ];
			$data{ppi_explain} = [ map { $_->{code} = _escape($_->{code}); $_ } $ce->ppi_explain ];
		} 
	}
	return to_json \%data;
};

sub _escape {
	my $txt = shift;
	$txt =~ s/</&lt;/g;
	$txt =~ s/>/&gt;/g;
	return $txt;
}

true;

