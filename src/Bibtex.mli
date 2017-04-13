
(** {1 Bibtex file} *)

type 'a or_error = ('a, string) CCResult.t

type id = string

module ID_map : CCMap.S with type key = id

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

val empty : t

val add : id -> entry -> t -> t

val mem : id -> t -> bool

val get : id -> t -> entry option

val to_list : t -> (id * entry) list

val of_list : (id * entry) list -> t

val parse : Lexing.lexbuf -> t or_error

val parse_file : string -> t or_error

