package HTML::StickyQuery;

use strict;
use base qw(HTML::Parser);
use URI;
use Carp;
use vars qw($VERSION);

$VERSION = '0.04';

sub new {
    my $class = shift;
    croak "odd number of " . __PACKAGE__ . "->new arguments"
      if @_ % 2;
    my %args = @_;
    my $self = bless {
		      override => 0,
		      abs => 0,
		      regexp => undef,
		     },$class;
    foreach my $key(qw(override abs regexp)) {
	$self->{$key} = $args{$key} if exists $args{$key};
    }
    $self->init;
    $self;
}

sub sticky {
    my $self = shift;
    my %args = @_;

    $self->{param} = $args{param} 
      if exists $args{param};
    $self->{output} = "";

    if (ref($args{param}) ne 'HASH') {
	croak "param must be a hash reference";
    }
    if ($args{file}) {
	$self->parse_file($args{file});
    }
    elsif ($args{scalarref}) {
	$self->parse(${$args{scalarref}});
    }
    elsif ($args{arrayref}) {
	foreach my $line(@{$args{arrayref}}) {
	    $self->parse($line);
	}
    }
    return $self->{output};
}

sub output {
    my $self = shift;
    return $self->{output};
}

sub start {
    my ($self,$tagname,$attr,$attrseq,$orig) = @_;
    if ($tagname ne 'a') {
	$self->{output} .= $orig;
	return;
    }
    else {
	my $u = URI->new($attr->{href});
	# ignore abstitute URI
	if (!$self->{abs} && $u->scheme) {
	    $self->{output} .= $orig;
	    return;
	}
	# when URI has other scheme (ie. mailto ftp ..)
	if(defined($u->scheme) && $u->scheme ne 'http' && $u->scheme ne 'https') {
	    $self->{output} .= $orig;
	    return;
	}
	else {
	    if (!$self->{regexp} || $attr->{href} =~ m/$self->{regexp}/) {
		if ($self->{override}) {
		    $u->query_form(%{$self->{param}});
		}
		else {
                   my %merged = (%{$self->{param}}, $u->query_form);
                   $u->query_form(%merged);
		}
		$self->{output} .= sprintf(qq{<$tagname href="%s"},
					   $u->as_string);
		delete $attr->{href};
		while (my($key,$val) = each %$attr) {
		    $self->{output} .= qq{ $key="$val"};
		}
		$self->{output} .= '>';
		return;
	    }
	    $self->{output} .= $orig;
	}
    }
}

sub end {
    my ($self,$tagname,$orig) = @_;
    $self->{output} .= $orig;
}

sub text {
    my ($self,$orig) = @_;
    $self->{output} .= $orig;
}

1;

__END__

=head1 NAME

HTML::StickyQuery - add sticky QUERY_STRING to a tag href attributes.

=head1 SYNOPSIS

  use HTML::StickyQuery;

  my $s = HTML::StickyQuery->new(
                                 regexp => '\.cgi$',
                                 abs => 0,
                                 override => 1
                                 );
  print $s->sticky(
                   file => 'foo.html',
                   param => {
                             SESSIONID => 'xxx'
                             }
                   );

=head1 DESCRIPTION

this module is sub class of L<HTML::Parser> and uses it to parse HTML document
and add QUERY_STRING to href attributes.

you can assign Session ID or any form data without using cookie.

if you want to use sticky CGI data via FORM.
it is better to use L<HTML::FillInForm>.

=head1 CONSTRUCTOR

=over 4

=item new(%option)

constructor of HTML::StickyQuery object. the options are below.

=over 5

=item abs

add QUERY_STRING to absolute URI or not. (default: 0)

=item override

override original QUERY_STRING or not (default: 0)

=item regexp

regular expression of affected URI. (default: I<none>)

=back

=back

=head1 METHODS

=over 4

=item sticky(%options)

parse HTML and add QUERY_STRING. return HTML document.
the options are below.

=over 5

=item file

specify the HTML file.

=item scalarref

specify the HTML document as scalarref.

=item arrayref

specify the HTML document as arrayref.

=item param

QUERY_STRING data. as hashref.

=back

=back

=head1 AUTHOR

IKEBE Tomohiro <ikebe@edge.co.jp>

=head1 SEE ALSO

L<HTML::Parser> L<HTML::FillInForm>

=head1 CREDITS

Fixes,Bug Reports.

 Tatsuhiko Miyagawa

=head1 COPYRIGHT

Copyright(C) 2001 IKEBE Tomohiro All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself. 

=cut

