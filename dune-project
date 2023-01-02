(lang dune 2.9)
(name config-file)

(generate_opam_files true)
(formatting disabled)

(source (github MisterDA/config-file))
(license "LGPL-2.0-or-later")
(authors
 "Antonin Décimo <antonin@tarides.com>"
 "Fabrice Le Fessant <fabrice.lefessant@inria.fr>"
 "Maxence Guesdon <maxence.guesdon@inria.fr>"
 "Jean-Baptiste Rouquier <jrouquie@gmail.com>"
)
(maintainers "Antonin Décimo <antonin@tarides.com>")

(package
 (name config-file)
 (synopsis "A library used to manage configuration files")
 (description
"\| Config_file is a library used to manage the configuration file(s) of
"\| an application. You simply define your options and it performs the
"\| loading and saving of the options in a file. You can also use the same
"\| options in the command line.
 )
 (depends
  (ocaml (>= 4.02))
  camlp-streams
  (camlp4 :build)
  (cppo :build)))
