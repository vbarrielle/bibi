
module E = CCResult
module B = Bibtex

module Cmd_list = struct
  (* TODO: parametrize by file name? *)

  let run () =
    let open E.Infix in
    B.parse_file "biblio.bib" >>= fun b ->
    Format.printf "@[<v>%a@]@."
      CCFormat.(list string) (B.to_list b |> List.map fst);
    E.return ()
end

module Cmd_init = struct
  let run () =
    try
      if not (Sys.file_exists ".git") then (
        ignore (Sys.command "git init");
      );
      (* create file *)
      let biblio = "biblio.bib" in
      if not (Sys.file_exists biblio) then (
        CCIO.with_out biblio
          (fun oc -> output_string oc "% created by bibi\n"; flush oc)
      );
      E.return ()
    with e ->
      E.of_exn_trace e
end

(** Parse command line *)

open Cmdliner

let term_list =
  Term.(pure Cmd_list.run $ pure ()), Term.info ~doc:"list entries" "list"

let term_init =
  Term.(pure Cmd_init.run $ pure ()), Term.info ~doc:"initialize repository" "init"

let help =
  let doc = "Manage your bibliography, citations, and papers" in
  let man = [
    `S "DESCRIPTION";
    `P "$(b,bibi) is a set of tools to manage a bibtex file and \
        additional data such as per-paper notes and pdf files";
    `S "COMMANDS";
    `S "OPTIONS";
  ] in
  Term.(ret (pure (fun () -> `Help (`Pager, None)) $ pure ())),
  Term.info ~version:"dev" ~man ~doc "bibi"

let () =
  let terms = [term_list; term_init] in
  begin match Cmdliner.Term.eval_choice help terms with
    | `Version | `Help | `Error `Parse | `Error `Term | `Error `Exn -> exit 2
    | `Ok (E.Ok ()) -> ()
    | `Ok (E.Error e) ->
      print_endline ("error: " ^ e);
      exit 1
  end
