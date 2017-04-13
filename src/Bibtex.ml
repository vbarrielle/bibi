
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

module Loc = struct
  type t = {
    file : string;
    start_line : int;
    start_column : int;
    stop_line : int;
    stop_column : int;
  }

  let mk file start_line start_column stop_line stop_column =
    { file; start_line; start_column; stop_line; stop_column; }

  let of_lexbuf lexbuf =
    let start = Lexing.lexeme_start_p lexbuf in
    let end_ = Lexing.lexeme_end_p lexbuf in
    let s_l = start.Lexing.pos_lnum in
    let s_c = start.Lexing.pos_cnum - start.Lexing.pos_bol in
    let e_l = end_.Lexing.pos_lnum in
    let e_c = end_.Lexing.pos_cnum - end_.Lexing.pos_bol in
    let file = start.Lexing.pos_fname in
    mk file s_l s_c e_l e_c

  let pp out pos =
    if pos.start_line = pos.stop_line
    then
      Format.fprintf out "@[file '%s': line %d, col %d to %d@]"
        pos.file pos.start_line pos.start_column pos.stop_column
    else
      Format.fprintf out "@[file '%s': line %d, col %d to line %d, col %d@]"
        pos.file
        pos.start_line pos.start_column
        pos.stop_line pos.stop_column
end

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
  with
    | Bibtex_parse.Error ->
      let pos = Loc.of_lexbuf lexbuf in
      CCFormat.ksprintf ~f:E.fail "parse error %a" Loc.pp pos
    | e -> E.of_exn_trace e

let parse_file file =
  try
    CCIO.with_in file
      (fun ic ->
         let lexbuf = Lexing.from_channel ic in
         lexbuf.Lexing.lex_curr_p <-
           {lexbuf.Lexing.lex_curr_p with Lexing.pos_fname=file};
         parse lexbuf)
  with e -> E.of_exn_trace e

