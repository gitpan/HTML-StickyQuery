package HTML::StickyQuery;

use strict;
use base qw(HTML::Parser);
use URI;
use Carp;
use vars qw($VERSION);

$VERSION = '0.03';

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
	if ($attr->{href} =~ m#^(mailto:|ftp:)#) {
	    $self->{output} .= $orig;
	    return;
	}
	if(!$self->{abs} && $attr->{href} =~ m#^(http://|https://)#) {
	    $self->{output} .= $orig;
	    return;
	}
	else {
	    if (!$self->{regexp} || $attr->{href} =~ m/$self->{regexp}/) {
		my $u = URI->new($attr->{href});
		if ($self->{override}) {
		    $u->query_form(%{$self->{param}});
		}
		else {
		    $u->query_form(%{$self->{param}},$u->query_form);
		}
		$self->{output} .= sprintf(qq{<$tagname href="%s"},$u->as_string);
		delete $attr->{href};
		while (my($key,$val) = each %$attr) {
		    $self->{output} .= qq{ $key=$val};
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
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

HTML::StickyQuery - add sticky query string to a tag href attributes.

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
and add query string to href attributes.

you can assign Session ID or any form data without using cookie.

if you want to use sticky CGI data via FORM.
it is better to use L<HTML::FillInForm>.

=head1 CONSTRUCTOR

=over 4

=item new(%option)

constructor of HTML::StickyQuery object. the options are below.

=over 5

=item abs

add query string to absolute URI or not. (default: 0)

but, if you enabled this option.
your query string are revealed via HTTP_REFERER. very insecure!

=item override

override original query string or not (default: 0)

=item regexp

regular expression of affected URI. (default: I<none>)

=back

=back

=head1 METHODS

=over 4

=item sticky(%options)

parse HTML and add query string. return HTML document.
the options are below.

=over 5

=item file

specify the HTML file.

=item scalarref

specify the HTML document as scalarref.

=item param

query string data. as hashref.

=back

=back

=head1 AUTHOR

IKEBE Tomohiro <ikebe@edge.co.jp>

=head1 SEE ALSO

L<HTML::Parser> L<HTML::FillInForm>

=head1 COPYRIGHT

Copyright(C) 2001 IKEBE Tomohiro All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself. 

=cut
