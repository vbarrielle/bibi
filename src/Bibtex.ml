
(** {1 Bibtex file} *)

module E = CCResult

type 'a or_error = ('a, string) CCResult.t

type id = string

module ID_map = CCMap.Make(String)

(** A field "foo = bar" *)
type field = {
  f_name: string;
  f_value: string;
}

type entry = {
  e_kind: string;
  e_fields: field list;
}

type t = entry ID_map.t
(** entry name -> entry *)

let empty = ID_map.empty
let add = ID_map.add
let to_list = ID_map.to_list
let of_list = ID_map.of_list
let mem = ID_map.mem
let get = ID_map.get

let parse lexbuf =
  try
    Bibtex_parse.entries Bibtex_lex.main lexbuf
    |> List.map
      (fun (id,e_kind,e_fields) ->
         let e_fields =
           List.map (fun (f_name,f_value) -> {f_name; f_value}) e_fields
         in
         id, {e_kind; e_fields})
    |> of_list
    |> E.return

  with e -> E.of_exn_trace e

let parse_file file =
  try
    CCIO.with_in file
      (fun ic ->
         let lexbuf = Lexing.from_channel ic in
         lexbuf.Lexing.lex_curr_p <-
           {lexbuf.Lexing.lex_curr_p with Lexing.pos_fname=file};
         parse lexbuf)
  with e -> E.of_exn_trace e

