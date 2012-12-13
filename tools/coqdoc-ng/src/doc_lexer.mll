{
  (*Doc_lexer: Lexer for the documentation language of coq*)

  open Lexing
  open Parser

  let tokens = Queue.create ()

  (** This buffer stores the current string being parsed *)
  let buff = Buffer.create 42

  (** Empties the buffer buff and stores the string into a CONTENT tokens
   * inside the queue *)
  let get_flush () =
    let str = Buffer.contents buff in
    Buffer.clear buff;
    if str <> "" then
      Queue.push (CONTENT str) tokens


  (** Set of functions in order to manage the lists *)
  let lst_lvl = ref []
  let push elt = lst_lvl := elt::!lst_lvl
  let pop () = match !lst_lvl with [] -> () | e::l -> lst_lvl := l
  let get_lvl () = match !lst_lvl with [] -> -1 | e::l -> e

  (** Handles the eof: while the queue is not empty, no EOF tokens
   * will be returned *)
  let treat_eof () =
    if Queue.is_empty tokens then
      if !lst_lvl <> [] then (pop (); ENDLST) else EOF
    else
      Queue.pop tokens


  let tok_lst =
    [("[",STARTVERNAC);
      ("]",ENDVERNAC);
      ("[[",STARTPP);
      ("]]",ENDPP);
      ("<<",STARTVERBATIM);
      (">>",ENDVERBATIM);
      ("----",HRULE);
      ("_",EMPHASIS);
    ("%",LATEX);
    ("$",LATEX_MATH);
    ("#",HTML);]
  let tok_htbl = Hashtbl.create 11

  let _ = List.iter (fun (key,tok) -> Hashtbl.add tok_htbl key tok) tok_lst

}

let sp = [' '  '\t']
let nl = "\r\n" | '\n'

let tok_reg = "[" | "]" | "[[" | "]]" | "<<" | ">>" | "----" | "_" | "%"
          | "$" | "#"

let sp_nl = sp | nl (* Space or newline *)
let name = ['a'-'z''A'-'Z''0'-'9']+

rule lex_doc = parse
  (** Token matching *)
  | sp_nl* (tok_reg as tok) sp_nl*
    {get_flush (); Queue.push (Hashtbl.find tok_htbl tok) tokens;
      Queue.pop tokens}

    (** Query matching, the arguments are split in the parser *)
  | '@' (name as query) '{' (_* as arglist) '}'
    {get_flush (); Queue.push (QUERY (query,arglist)) tokens;
    Queue.pop tokens}

    (** Section matching: the importance of the title is the number of stars *)
  | ("*"+ as lvl) ' ' ([^'\n']+ as title)
    {get_flush (); Queue.push (SECTION ((String.length lvl), title)) tokens;
    Queue.pop tokens}

    (** List matching: if a line starts with a '-', then it is an element of a
     * list *)
  | nl (sp* as lvl) "- " {get_flush ();
    let depth = String.length lvl in
    if depth > (get_lvl ()) then (* New sublist *)
      (Queue.push (LST depth) tokens; Queue.push ITEM tokens;
      push depth;
      Queue.pop tokens)
      else if depth < (get_lvl ()) then (* End of sublist *)
        (Queue.push ENDLST tokens;
      Queue.push ITEM tokens;
      pop ();
      Queue.pop tokens)
    else (* Another item *)
      (Queue.push ITEM tokens; Queue.pop tokens)}

  | "remove" sp+ "printing" sp+ ([^' ''\t']+ as tok) sp+
    {get_flush (); Queue.push (RM_PRINTING tok) tokens; Queue.pop tokens}

  | "printing"("_macro"* as macro) sp+ ([^' ''\t']+ as tok) sp+
    {let is_macro = if String.length macro > 0 then true else false in
    print_endline ("printing: " ^ tok);
      get_flush (); Queue.push (ADD_PRINTING (is_macro,tok)) tokens; Queue.pop tokens}

  | eof { (if (Buffer.length buff <> 0) then get_flush ()); treat_eof ()}
  | _ as c {Buffer.add_char buff c; lex_doc lexbuf}
