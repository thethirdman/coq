(** These are the options of the standalone coqdoc driver. **)

(** FIXME: Please add a uniform way to produce error messages. *)
let fatal_error msg =
  print_string msg;
  print_newline ();
  exit 1

(** File type for input files. *)
type frontend_type =
  (** A documented Coq source code. *)
  | IVernac
  (** A LaTeX file that includes Coq snippets. *)
  | ICoqTeX
  (** An HTML document that includes Coq snippets. *)
  | IHTML

(** The file extension of a backend_type. *)
let extension_of_frontend_type = function
  | IVernac -> ".v"
  | ICoqTeX -> ".tex"
  | IHTML -> ".html"

(** The frontend_type of a file extension. *)
let frontend_type_of_extension = function
  | ".v" -> IVernac
  | ".tex" -> ICoqTeX
  | ".html" -> IHTML
  | _ -> assert false

(** Description of frontend type. *)
let string_of_frontend_type = function
  | IVernac -> "coq source"
  | ICoqTeX -> "TeX file with Coq snippets"
  | IHTML -> "HTML document with Coq snippets"

(** File type for output files. *)
type backend_type =
  (** A set of HTML documents, that refer to each other and
      may refer to external HTML documents. *)
  | OHTML
  (** A self-contained LaTeX document. *)
  | OLaTeX
  (** A text-based standalone document. *)
  | OPrettyPrint

(** The file extension of a backend_type. *)
let extension_of_backend_type = function
  | OHTML -> ".html"
  | OLaTeX -> ".tex"
  | OPrettyPrint -> ".txt"

(** Description of backend type. *)
let string_of_backend_type = function
  | OHTML -> "HTML documents"
  | OLaTeX -> "standalone LaTeX document"
  | OPrettyPrint -> "standalone text document"

(** Documents are transmitted through standard UNIX channels. *)
type filename = Anonymous | Named of string | Directory of string

type ('io, 'io_type) document = {
  mutable document_filename : filename;
  mutable document_channel  : 'io;
  mutable document_type     : 'io_type;
}

(** Description of expected inputs and outputs. *)
type input  = (in_channel, frontend_type) document

(* FIXME: For the moment, we do not handle multiple output files...  *)
type output = (out_channel, backend_type) document
type io = {
  mutable input      : input list;
  mutable input_type : frontend_type;
  mutable output     : output;
}

(** ... and their default values. *)
let default_input = {
  document_filename = Anonymous;
  document_channel  = stdin;
  document_type     = IVernac;
}

let default_output = {
  document_filename = Anonymous;
  document_channel  = stdout;
  document_type     = OHTML;
}

(** Global settings. *)
let io = {
  input      = [];
  output     = default_output;
  input_type = IVernac;
}

let is_default_output = ref true
let toc_only = ref false

(** Load a document. *)
let extension_of_filename fname =
  let reg = Str.regexp "\\." in
  try
    let off = Str.search_backward reg fname (String.length fname) in
    (Str.string_after fname off)
  with Not_found -> "(no extension)"

let make_input_document fname =
  if Sys.is_directory fname then
    {document_filename = Directory fname;
      document_channel = stdin; (** default value *)
      document_type = IVernac;}
  else
    try {
      document_filename = Named fname;
      document_channel  = open_in fname;
      document_type     = frontend_type_of_extension (extension_of_filename fname)
    } with (Sys_error _) as e ->
  (* FIXME: Use a standardize way of raising fatal errors. *)
  raise e

let load_output_directory fname =
  if not !is_default_output then
    raise (Invalid_argument ("Error: I cannot have multiple file as an ouput."
      ^ "please specify only one file or a directory"))
  else
    is_default_output := false;
  let doc = {document_type = io.output.document_type;
            document_filename = Directory fname;
            document_channel = stdout;} in (** default value *)
  io.output <- doc

let load_output_document fname =
  if not !is_default_output then
    raise (Invalid_argument ("Error: I cannot have multiple file as an ouput."
      ^ "please specify only one file or a directory"))
  else
    is_default_output := false;
  if Sys.file_exists fname && Sys.is_directory fname then
      load_output_directory fname
  else
    try
      let doc = {document_type = io.output.document_type (* FIXME *);
               document_filename = Named fname;
               document_channel = open_out fname;} in
      io.output <- doc
  with (Sys_error _) as e -> raise e

let load_input_document inp =
  io.input <- inp :: io.input

let make_load_input_document fname =
  let inp = make_input_document fname in
  load_input_document inp

let load_files_from fname =
  let old_dir = Sys.getcwd () in Sys.chdir (Filename.dirname fname);
  let i_chan = open_in fname in
  try while true do
    make_load_input_document (input_line i_chan)
  done
  with End_of_file -> Sys.chdir old_dir

(* FIXME: make a real usage doc_string *)
let usage = "This is coqdoc ...\n\n" ^
            "Usage: " ^ Sys.argv.(0) ^ " [options] [files]\n"

let print_help =
  ref false

(* Option list for coqdoc *)
(* FIXME: This should include at least all the options of the old coqdoc
   FIXME: as well as all the options of old coqtex.
   FIXME: In addition, we would like an emulation mode for the old coqdoc
   FIXME: and also a wrapping of the old implementation.
*)
let speclist = Arg.align [
  ("-h", Arg.Set print_help,
   " Print this help message and exit.");
  ("--vernac", Arg.String (fun fname ->
      try load_input_document { document_filename = Named fname;
      document_channel = open_in fname; document_type = IVernac; }
      with (Sys_error _) as e -> raise e),
  " Consider file as a .v file ");
  ("--tex", Arg.String (fun fname ->
      try load_input_document { document_filename = Named fname;
      document_channel = open_in fname; document_type = ICoqTeX; }
      with (Sys_error _) as e -> raise e),
  " Consider file as a .v file ");
  ("-o", Arg.String (fun s -> load_output_document s),
   " Specify output file. If unspecified, default output will be stdout.");
   ("--files-from", Arg.String (fun s -> load_files_from s),
   " Read input file names to process from file");

  ("-d", Arg.String (fun s ->
    if Sys.file_exists s && Sys.is_directory s then load_output_directory s
    else raise (Invalid_argument ("Error: the file " ^ s ^ " does not exists or"
    ^ "is not a directory"))),
    " Specify output directory. Generates a file for each input file, with"
    ^ "the same basename");

  ("--html", Arg.Unit (fun () -> io.output.document_type <- OHTML),
   " Produce a HTML document (default).");

  ("--latex", Arg.Unit (fun () -> io.output.document_type <- OLaTeX),
   " Produce a LaTeX document.");

  ("--raw", Arg.Unit (fun () -> io.output.document_type <- OPrettyPrint),
   " Produce a LaTeX document.");

  ("--stdout", Arg.Unit (fun () -> io.output <-
    {document_type = OHTML; document_filename = Anonymous;
     document_channel = stdout;}),
   " Prints the generated document on standard output");

  ("--toc", Arg.Set toc_only,
    "Only outputs the table of contents");
  ("--no-externals", Arg.Clear Hyperlinks.show_stdlib,
  "Do not print links to Coq standard library");
  ]

let print_help_if_required () =
  if !print_help then (
    print_string (Arg.usage_string speclist usage);
    exit 0
  )

(** Load requested inputs. *)
let parse_anon = function
  | s when Sys.file_exists s ->
        make_load_input_document s
  | x ->
    raise (Arg.Bad ("Invalid argument: " ^ x))

(** Check settings consistency. *)
let check_settings_consistency () =
  let rec check () =
    check_output_extension_consistency ();
    check_feasible_translation ()

  (** Check output extension: the output document type and filename
      extension must coincide. *)
  and check_output_extension_consistency () =
    match io.output.document_filename with
      | Anonymous | Directory _ ->
	(** If no filename is specified, we are good. *)
	()
      | Named filename ->
	let extension = extension_of_filename filename in
	let xextension = extension_of_backend_type io.output.document_type in
	if extension <> xextension then
	  fatal_error (Printf.sprintf
			 "The %s back-end only creates `%s' files."
			 (string_of_backend_type io.output.document_type)
			 xextension)

  (** They are a couple of front-end/back-end that are not implemented. *)
  and check_feasible_translation () =
    let rec similar_inputs p is =
      match p, is with
	| None, [] ->
	  fatal_error "I cannot produce a document out of nothing!"
	| None, i :: is ->
	  similar_inputs (Some i.document_type) is
	| Some t, [] ->
	  t
	| Some t, i :: is ->
	  if i.document_type <> t then
	    fatal_error "I need all the input files to be of the same kind."
	  else
	    similar_inputs p is
    in
    let input_type = similar_inputs None io.input in
    io.input_type <- input_type;
    match input_type, io.output.document_type with
      | IHTML, (OLaTeX | OPrettyPrint) ->
	fatal_error (Printf.sprintf
		       "You cannot produce a %s document out of a %s input."
		       (string_of_backend_type io.output.document_type)
		       (string_of_frontend_type input_type))
      | _ ->
	()
  in
  check ()

(** This function does the final computations after the command line is
 * parsed. This is a necessary step because:
 *  - If no input file is specified, we want to set a default input
 *  - We want to generate the list of file when a Directory type is given
 *  both in input and output
 *)
let check_input_output () =
  if io.input = [] then io.input <- [default_input]
  else
    io.input <- List.fold_left (fun acc file ->
      match file.document_filename with
      | Directory dirname ->
          begin
            (** We read the files in the directory *)
            let new_files = ref [] in
            let files = Sys.readdir dirname in
            for i = 0 to Array.length files - 1 do
              let cur_file = dirname ^ "/" ^ files.(i) in
              let ext = extension_of_frontend_type io.input_type in
              (** For each file in the dir, if it has a good extension *)
              if (ext = (extension_of_filename cur_file))
                && not (Sys.is_directory cur_file) then
                  new_files :=
                    {document_filename = Named cur_file;
                     document_channel = open_in cur_file;
                     document_type = io.input_type;}
                    ::!new_files
            done;
            (** We add the list of new files in the list, replacing the
             * directory *)
            (!new_files)@acc
          end
      | _ -> file::acc) [] io.input

(** Parses the command line and sets up the variables. *)
let parse () =
  Arg.parse speclist parse_anon usage;
  check_input_output ();
  print_help_if_required ();
  check_settings_consistency ()

(** Accessors *)
let input_documents () = io.input
let input_filename i   = i.document_filename
let input_channel i    = i.document_channel
let input_type ()      = io.input_type
let output_document () = io.output
let output_filename o  = o.document_filename
let output_channel o   = o.document_channel
let output_type o      = o.document_type

(* This function forges a new output file from a given input file *)
(* Its main use it when coqdoc has to manage a set of input
 * files, and an output directory *)
let make_output_from_input dirname input_file =
  (** We first get the input filename (without file hierarchy not extension) *)
  let input_fname =  match input_file.document_filename with
    | Named s -> Filename.chop_extension (Filename.basename s)
    |_ -> assert false in
  (** We then generate the output_filename *)
  let output_name = dirname ^ "/" ^ input_fname ^
    extension_of_backend_type (output_type io.output) in

  (** We finally create the output type *)
  {document_type = io.output.document_type;
   document_filename = Named output_name;
   document_channel = open_out output_name;}


(** This function generate the list of (module_name, input),
 * it enables the obtention of a module name (a string) from an input type.
 * This allows to keep the physical file structure inside coqdoc.
 *)
let module_list =
  let lst = ref [] in
  let aux inp = match inp.document_filename with
    | Named fname ->
        String.capitalize (Filename.chop_extension (Filename.basename fname))
    | Anonymous -> ""
    |_ -> assert false
  in
  (fun () ->
    if !lst = [] then
      lst := List.map (fun inp -> (inp,aux inp)) (input_documents ());
    !lst)

(** Takes an input and returns its corresponding module name *)
let module_from_input inp =
  snd (List.find (fun e -> inp = (fst e)) (module_list ()))

(** Takes a module name and returns its corresponding input *)
let input_from_module m =
  fst (List.find (fun e -> m = (snd e)) (module_list ()))

(** This function takes an input module and gives the name of the corresponding
 * output file, or an empty string if it is empty. *)
let output_name_of_module m =
  match io.output.document_filename with
    (** if the output type is a directory, we generate a new output using
     * the input type, in order to obtain the name of this output module *)
    | Directory d ->
        begin try
          begin match
            (make_output_from_input d (input_from_module m)).document_filename
          with
            Named s -> s
            |_ -> assert false
          end
        with Not_found -> ""
        end
    | Anonymous -> ""
    | Named n -> n
