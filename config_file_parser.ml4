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

(* This file is used to generate the code of the module Config_file.Raw.Parse. *)

module Parse = struct
  let lexer = Genlex.make_lexer ["="; "{"; "}"; "["; "]"; ";"; "("; ")"; ","]

(* parsers: *)
  let rec file l = parser
    | [< id = ident; 'Genlex.Kwd "="; v = value ; result = file ((id, v) :: l) >] -> result
    | [< >] -> List.rev l
  and value = parser
    | [< 'Genlex.Kwd "{"; v = file []; 'Genlex.Kwd "}" >] -> Section v
    | [< 'Genlex.Ident s >] -> String s
    | [< 'Genlex.String s >] -> String s
    | [< 'Genlex.Int i >] -> Int i
    | [< 'Genlex.Float f >] -> Float f
    | [< 'Genlex.Char c >] -> String (String.make 1 c)
    | [< 'Genlex.Kwd "["; v = list [] >] -> List v
    | [< 'Genlex.Kwd "("; v = list [] >] -> Tuple v
  and ident = parser
    | [< 'Genlex.Ident s >] -> s
    | [< 'Genlex.String s >] -> s
  and list l = parser
    | [< 'Genlex.Kwd ";"; result = list l >] -> result
    | [< 'Genlex.Kwd ","; result = list l >] -> result
    | [< v = value; result = list (v :: l) >] -> result
    | [< 'Genlex.Kwd "]" >] -> List.rev l
    | [< 'Genlex.Kwd ")" >] -> List.rev l
end
