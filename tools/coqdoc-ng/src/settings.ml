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
  | OPrettyPrint -> ".pp"

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

(** Load a document. *)
let extension_of_filename fname =
  let reg = Str.regexp "\\." in
  try
    let off = Str.search_backward reg fname (String.length fname) in
    (Str.string_after fname off)
  with Not_found -> "(no extension)"

let load_input_document fname =
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

let load_output_document fname =
  if Sys.file_exists fname then
    if Sys.is_directory fname then
      let doc = {document_type = OHTML;
              document_filename = Directory fname;
              document_channel = stdout;} in (** default value *)
      io.output <- doc
    else
    try
      let doc = {document_type = OHTML (* FIXME *);
               document_filename = Named fname;
               document_channel = open_out fname;} in
      io.output <- doc
  with (Sys_error _) as e -> raise e
  else
    raise (Invalid_argument ("File does not exists: " ^ fname))

let load_input_document fname =
  io.input <- (load_input_document fname) :: io.input

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

  ("-o", Arg.String (fun s -> load_output_document s),
   " Specify output file. If unspecified, default output will be stdout.");

  ("--html", Arg.Unit (fun () -> io.output.document_type <- OHTML),
   " Produce a HTML document (default).");

  ("--latex", Arg.Unit (fun () -> io.output.document_type <- OLaTeX),
   " Produce a LaTeX document.");

  ("--pp", Arg.Unit (fun () -> io.output.document_type <- OPrettyPrint),
   " Produce a LaTeX document.");
  ]

let print_help_if_required () =
  if !print_help then (
    print_string (Arg.usage_string speclist usage);
    exit 0
  )

(** Load requested inputs. *)
let parse_anon = function
  | s when Sys.file_exists s ->
        load_input_document s
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
              let cur_file = files.(i) in
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
  let out_document = Settings.output_document () in
  (** We first get the input filename (without file hierarchy not extension) *)
  let input_fname =  match Settings.input_filename input_file with
    | Settings.Named s -> Filename.chop_extension (Filename.basename s)
    |_ -> assert false in
  (** We then generate the output_filename *)
  let output_name = dirname ^ "/" ^ input_fname ^
    Settings.extension_of_backend_type (Settings.output_type out_document) in

  (** We finally create the output type *)
  {Settings.document_type = Settings.output_type out_document;
   Settings.document_filename = Settings.Named output_name;
   Settings.document_channel = open_out output_name;}

