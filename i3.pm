#!/usr/bin/env perl

=head1 i3

i3wm Perl interface

=cut

package i3;

use warnings;
use strict;

use JSON::XS;

######################################################################

=head2 members

=head3 workspaces

The full workspaces' state data.

=head2 methods

=head3 new([command])

Constructor.

=over 12

=item command

A command returning a JSON containing the workspaces' state.

Default value: "i3-msg -t get_workspaces"

=back

=cut
sub new {
    my $class = shift;
    my $cmd   = shift // "i3-msg -t get_workspaces";
    my $self  = { cmd        => $cmd,
                  workspaces => decode_json `$cmd` };
    bless $self, $class;
}

######################################################################

=head3 update()

Updates the saved workspaces' state.

=cut
sub update {
    my $self = shift;
    $self->{workspaces} = decode_json `$self->{cmd}`;
    return $self;
}

######################################################################

=head3 workspaces()

Returns the list of workspaces' names.

=cut
sub workspaces {
    my $self = shift;
    map
      {$_->{name}}
      @{$self->{workspaces}};
}

######################################################################

=head3 current_workspace()

Returns a hash containing information about the focused workspace.

=cut
sub current_workspace {
    my $self = shift;
    for my $workspace (@{$self->{workspaces}}) {
        return $workspace if $workspace->{focused}
    }
    return undef;
}

1;
