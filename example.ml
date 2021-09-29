(*********************************************************************************)
(*                Config_file                                                    *)
(*                                                                               *)
(*    Copyright (C) 2011 Institut National de Recherche en Informatique          *)
(*    et en Automatique. All rights reserved.                                    *)
(*                                                                               *)
(*    This program is free software; you can redistribute it and/or modify       *)
(*    it under the terms of the GNU Library General Public License as            *)
(*    published by the Free Software Foundation; either version 2 of the         *)
(*    License, or any later version.                                             *)
(*                                                                               *)
(*    This program is distributed in the hope that it will be useful,            *)
(*    but WITHOUT ANY WARRANTY; without even the implied warranty of             *)
(*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *)
(*    GNU Library General Public License for more details.                       *)
(*                                                                               *)
(*    You should have received a copy of the GNU Library General Public          *)
(*    License along with this program; if not, write to the Free Software        *)
(*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   *)
(*    02111-1307  USA                                                            *)
(*                                                                               *)
(*********************************************************************************)

open Config_file

let group = new group

(* We create a cp foo of type int. Its default value is 42: *)
let foo = new int_cp ~group [ "foo" ] 42 "Help about foo."

(* We create two other cp in section "section1": *)
let bar =
  new list_cp
    int_wrappers ~group [ "section1"; "bar" ] [ 1; 2; 3; 4 ] "Help about bar."

let baz =
  new tuple2_cp
    string_wrappers bool_wrappers ~group [ "section1"; "baz" ] ("switch", true)
    ""
;;

(* We save them in file "temp.ml" and check the result: *)
group#write "temp.ml";;

Printf.printf "edit temp.ml and press enter...\n%!";
ignore (input_line stdin);

(* We load the file and play with the value of foo: *)
group#read "temp.ml";
Printf.printf "foo is %d\n%!" foo#get;
foo#set 28;
Printf.printf "foo is %d\n%!" foo#get;

(* How to define command line arguments and print them (see module Arg): *)
Arg.usage (group#command_line_args ~section_separator:"-") "usage message"

(* We define a new type of cp: *)
let int64_wrappers =
  {
    to_raw = (fun v -> Raw.String (Int64.to_string v));
    of_raw =
      (function
      | Raw.Int v -> Int64.of_int v
      | Raw.Float v -> Int64.of_float v
      | Raw.String v -> Int64.of_string v
      | r ->
          raise
            (Wrong_type
               (fun outchan ->
                 Printf.fprintf outchan "Raw.Int expected, got %a\n%!"
                   Raw.to_channel r)));
  }

class int64_cp = [int64] cp_custom_type int64_wrappers
(* See the implementation for other examples *)

(* ********************************************************************** *)
(* Advanced usage *)

(* How to use group.read without failing on error:
   In case [groupable_cp] doesn't get a suitable type, we just print a warning in foo.log
   and discard the value from temp.ml (thus keeping the current value of [groupable_cp])*)
let log_file = open_out "foo.log";;

group#read
  ~on_type_error:(fun groupable_cp _raw_cp output filename _in_channel ->
    Printf.fprintf log_file
      "Type error while loading configuration parameter %s from file %s.\n%!"
      (String.concat "." groupable_cp#get_name)
      filename;
    output log_file (* get more information into log_file *))
  "temp.ml"

(* Here is a more complex custom type. *)
type myrecord = { a : float; b : int list }

let myrecord_wrappers =
  let b_to_raw = (list_wrappers int_wrappers).to_raw in
  let b_of_raw = (list_wrappers int_wrappers).of_raw in
  let field_of_option name = function
    | Some a -> a
    | None ->
        Printf.eprintf "Field %s undefined\n%!" name;
        exit 1
  in
  let a = ref None and b = ref None in
  {
    to_raw =
      (fun { a; b } ->
        Raw.Section [ ("a", float_wrappers.to_raw a); ("b", b_to_raw b) ]);
    of_raw =
      (function
      | Raw.Section l ->
          List.iter
            (fun (name, value) ->
              match name with
              | "a" -> a := Some value
              | "b" -> b := Some value
              | s -> Printf.eprintf "Unknown field %s\n%!" s)
            l;
          {
            a = float_wrappers.of_raw (field_of_option "a" !a);
            b = b_of_raw (field_of_option "b" !b);
          }
      | r ->
          raise
            (Wrong_type
               (fun outchan ->
                 Printf.fprintf outchan "Raw.Section expected, got %a\n%!"
                   Raw.to_channel r)));
  }

class myrecord_cp = [myrecord] cp_custom_type myrecord_wrappers
