(* This lexer does the separation between comments,
 * documentation and code.
 *)

open Lexing
open Parser

module Vernac_lexer = struct

  exception Lexer_Error of string

  let reg = Str.regexp "\\((\\*\\*\\)\\|\\((\\*\\)\\|\\(\\*)\\)"
  let tokens = Queue.create ()

  (** Parsing function : generates the tokens
   * from the result a Str.full_split
   *)
  let rec gen_tokens tokens depth = function
    [] -> depth
    |(Str.Delim e)::l when e = "(*" -> begin
        if depth = 0 then Queue.push STARTCOM tokens
        else Queue.push (CONTENT "(*") tokens;
      gen_tokens tokens (depth + 1) l end
    |(Str.Delim e)::l when e = "*)" -> begin
        if depth = 1 then Queue.push ENDCOM tokens
        else Queue.push (CONTENT "*)") tokens;
      gen_tokens tokens (depth - 1) l end
    |(Str.Delim e)::l when e = "(**" -> begin
        if depth = 0 then Queue.push STARTDOC tokens
        else Queue.push (CONTENT "(**") tokens;
      gen_tokens tokens (depth + 1) l end
    |(Str.Delim e)::l | (Str.Text e)::l -> begin
      Queue.push (CONTENT e) tokens; gen_tokens tokens depth l end

  (** Reads from an input channel and applies gen_tokens. *)
  let lex in_chan =
    let depth = ref 0 in
    let aux () =
        if (Queue.is_empty tokens) then
            begin try depth := gen_tokens tokens !depth
              (Str.full_split reg ((input_line in_chan ) ^ "\n"))
            with End_of_file -> Queue.push EOF tokens end;
        (Queue.pop tokens, Lexing.dummy_pos, Lexing.dummy_pos)
    in aux

end
