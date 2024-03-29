## release-1.2.1 (2021-09-30)  Antonin Décimo  <antonin@tarides.com>

  * build: switch build system to Dune
  * build: use cppo and camlp4 for pre-processing
  * fix: fix warnings

## release-1.2 (2014-03-20)  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

### 2014-02-11  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

  * add: compile and install .cmxs files

### 2013-02-25  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

  * add: new read_string method, thanks to Armaël Guéneau

## release-1.1 (2012-04-11)  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

  * add: use findlib to install

### 2004-11-19  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

  * add: .headache_config

### 2004-11-9  Jean-Baptiste Rouquier

  * config_file.mli, config_file.ml: removed color_cp (could be string or int)
  * Minors changes in the documentation.
  * Header of config_file.ml (TODO and Changelog).

### 2004-11-03  Maxence Guesdon  <Maxence.Guesdon@inria.fr>

  * mod: installation ok
  * add: configure.in, configure, master.Makefile.in, gpl_header
  * fix: Makefile

### 2004-09-10  Jean-Baptiste Rouquier

  * config_file.ml: renamed group#load into group#read.
  * Customizable behaviour (log file for instance) on error in configuration
    files.
  * Configuration file created if it doesn't exist.
  * Bugfix in Raw.of_file.

### 2004-08-20  Jean-Baptiste Rouquier

  * config_file.ml: object rewrite, no more Obj.magic.
  * Lots of comments added (also in config_file.mli).
  * Interface to module Arg handles not only "simple" configuration parameters,
    ie also handles configuration parameters inside a Section.
  * Use of module Format to prettier print the config file and the
    command_line_args
  * Use of module Queue to keep the cps in the order they were added to the
    group.
