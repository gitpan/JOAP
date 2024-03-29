#!/usr/bin/perl -w -It/lib

# tag: test for JOAP Server subclass <search> handling

# Copyright (c) 2003, Evan Prodromou <evan@prodromou.san-francisco.ca.us>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA


use Test::More tests => 9;

use Net::Jabber qw(Client);
use MyServer;

$SRC = "User\@example.net/Client";
$DEST = "joap.example.com";

my $srv = new MyServer;

# search (erroneously) a server

my $iq = new Net::Jabber::IQ;
my $ID = 'joap_search_1';

$iq->SetTo($DEST);
$iq->SetFrom($SRC);
$iq->SetID($ID);
$iq->SetType('get');

my $search = $iq->NewQuery($JOAP::NS, 'search');

my $res = $srv->on_iq($iq);

ok($res, "Got a search result.");

is($res->GetType, "error", "It's an error result.");
is($res->GetID, $ID, "ID came back correct.");
is($res->GetFrom, $DEST, "from is right.");
is($res->GetTo, $SRC, "to is right.");

is($res->GetErrorCode, 405, "Error code is correct.");

my $qry = $res->GetQuery;

ok($qry, "Can get the query.");
is($qry->GetTag, 'search', "Returned query has search tag.");
is($qry->GetXMLNS, $JOAP::NS, "Returned query has joap XMLNS.");
