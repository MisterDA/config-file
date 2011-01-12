#################################################################################
#                                                                               #
#                 Config_file                                                   #
#                                                                               #
#    Copyright (C) 2004-2011 Institut National de Recherche en Informatique     #
#    et en Automatique. All rights reserved.                                    #
#                                                                               #
#    This program is free software; you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as published by       #
#    the Free Software Foundation; either version 2 of the License, or          #
#    any later version.                                                         #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU General Public License for more details.                               #
#                                                                               #
#    You should have received a copy of the GNU General Public License          #
#    along with this program; if not, write to the Free Software                #
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   #
#    02111-1307  USA                                                            #
#                                                                               #
#    Contact: Maxence.Guesdon@inria.fr                                          #
#################################################################################

# $Id: Makefile 111 2005-10-21 08:46:14Z zoggy $

include master.Makefile

# Compilation
#############

byte: lib
opt: libopt
all: byte opt
lib: config_file.cmi config_file.cmo
libopt: config_file.cmi config_file.cmx

re : depend clean all

parser: config_file_parser.ml4
	camlp4 pa_o.cmo pa_op.cmo pr_o.cmo -- -o config_file_parser.ml -impl config_file_parser.ml4

example: byte
	ocaml config_file.cmo example.ml
test: byte
	ocaml config_file.cmo test.ml

# Documentation :
#################
doc: dummy
	$(MKDIR) doc
	$(OCAMLDOC) -html -d doc -colorize-code \
	-t "The Config_file library" \
	config_file.mli config_file.ml

# myself :
##########

master.Makefile: master.Makefile.in config.status
	./config.status

config.status: configure
	./config.status --recheck

configure: configure.in
	autoconf
# backup, clean and depend :
############################

distclean: clean
	$(RM) config.cache config.log config.status master.Makefile
	$(RM) doc autom4te.cache configure.lineno

clean:: dummy
	$(RM) *~ \#*\# *.cm* *.o *.a *.annot

dummy:

###########
# Headers
###########
headers: dummy
	headache -h gpl_header -c .headache_config configure.in configure \
	master.Makefile.in Makefile \
	*.ml *.mli *.ml4

noheaders: dummy
	headache -r -c .headache_config configure.in configure \
	master.Makefile.in Makefile \
	*.ml *.mli *.ml4



#################
# installation
#################

install: dummy
	$(MKDIR) $(INSTALLDIR)
	$(CP) config_file.cmi config_file.cmo $(INSTALLDIR)
	if test -f config_file.cmx; then $(MAKE) installopt; fi

installopt: dummy
	$(MKDIR) $(INSTALLDIR)
	$(CP) config_file.cmi config_file.cmx config_file.o $(INSTALLDIR)

# Web site install
###################
REMOTE_DEST=zoggy@config-file.forge.ocamlcore.org:/home/groups/config-file/htdocs/
installsite: all doc
	scp -r web/index.html web/style.css ocamldoc $(REMOTE_DEST)

# distribution
###############
archive: dummy
	git archive --prefix=config-file-$(VERSION)/ HEAD | gzip > /tmp/config-file-$(VERSION).tar.gz



###########################
# additional dependencies
###########################

# DO NOT DELETE
