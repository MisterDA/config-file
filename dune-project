(lang dune 2.8)

(name config-file)
(version 1.2.1)

(generate_opam_files true)

(license LGPL-2.0-or-later)
(authors
 "Antonin Décimo"
 "Fabrice Le Fessant"
 "Jean-Baptiste Rouquier"
 "Maxence Guesdon"
)
(maintainers "zoggy@bat8.org")

(package
 (name config-file)
 (synopsis "Small library to define, load and save options files")
 (depends
  (ocaml (>= 4.0)))
 (tags (configuration)))
