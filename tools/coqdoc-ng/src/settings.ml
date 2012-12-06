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
type filename = Anonymous | Named of string

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
  input      = [ default_input ];
  output     = default_output;
  input_type = IVernac;
}

(** Load a document. *)
let load_input_document fname = try {
  document_filename = Named fname;
  document_channel  = open_in fname;
  document_type     = frontend_type_of_extension (Filename.chop_extension fname)
} with (Sys_error _) as e ->
  (* FIXME: Use a standardize way of raising fatal errors. *)
  raise e

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

  ("-o", Arg.String (fun s -> io.output.document_filename <- Named s), 
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
      | Anonymous -> 
	(** If no filename is specified, we are good. *)
	()
      | Named filename -> 
	let extension = Filename.chop_extension filename in
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

(** Parses the command line and sets up the variables. *)
let parse () =
  Arg.parse speclist parse_anon usage;
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
