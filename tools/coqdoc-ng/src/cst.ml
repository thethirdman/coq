(*
 * This module contains the CST representation of the entry file parsing
 *)

exception End_of_file

(* Type representing inline tex/html in source files; Also contains a
 * default rule in case the output type is not handled *)
type raw_content = { latex : string; latex_math : string; html : string;
                      default : string}

(* Type for code elements *)
type code =  Keyword of string | Ident of string | Literal of string
            | Tactic of string
            | Symbol of string | NoFormat of string

type printing_rule = {
  is_command : bool;
  match_element : string;
  replace_with : raw_content}


(** This type contains the terminal elements of a cst: those elements
 * are both not recursive, and supposed to appear after evaluation
 * of the cst *)
type flat_element =
  [ `Vernac of string
  | `Pretty_print of string
  | `Section of (int*string)
  | `Hrule
  | `Raw of raw_content
  | `Verbatim of string
  | `Content of string
  (** This is an output specific command: the idea is to generate a command
   * call inside the generated document.
   * The first element is the command to call; The second element is the list
   * of arguments given to this command. Each backend should implement its
   * way to output commands *)
  | `Output_command of raw_content * string list
  (* Type for formatted code output: list of code elements *)
  | `Code of code list ]

(** This type contains all the elements that will be evaluated.
 * They will disappear in the final document *)
type eval_element =
  [ `Add_printing of printing_rule
  | `Rm_printing of string
  (* Type for documentation queries: @name{arg_list} *)
  | `Query of (string*string list) ]

(** This type contains all the recursive elements of the cst. They are
 * parameterized because before evaluation, they can contains either
 * flat_elements or eval_elements. After evaluation, they should
 * only contain flat_elements *)
type 'a rec_element =
  (* Type for documentation lists *)
  [ `List of 'a list
  | `Item of (int * 'a) (* List items in coqdoc *)
  | `Emphasis of 'a
  (** Type for hyperlinks:
    * - A Root defines the destination of a link
    * - A Link defines a reference to a root
    *)
  | `Root of ('a * string) (** name_to_show * reference *)
  | `Link of ('a * string)
  (* Type for a sequence of doc elements: DO NOT CONFUSE WITH `List *)
  | `Seq of 'a list ]

type doc_no_eval = [flat_element | doc_no_eval rec_element]
type doc_with_eval = [flat_element | eval_element | doc_with_eval rec_element]


(* Final CST *)
type 'a cst_node =
  | Comment of string
  | Doc of 'a
  | Code of string

type 'a cst = ('a cst_node) list

(* Converts source and doc types into the common type cst *)
let make_cst lst (doc_converter:string -> doc_with_eval) = assert false
