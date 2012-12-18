(*
 * This module contains the CST representation of the entry file parsing
 *)

exception End_of_file

(* Type representing inline tex/html in source files; Also contains a
 * default case if the used output field in the backend is not handled *)
type raw_content = { latex : string; latex_math : string; html : string;
                      default : string}

(* Type for code elements *)
type code =  Keyword of string | Ident of string | Literal of string
            | Tactic of string
            | Symbol of string | NoFormat of string
            | Output_command of raw_content * string list
            (** Type for hyperlinks:
              * - A Root defines the destination of a link
              * - A Link defines a reference to a root
              *)
            | Root of (string * string) (** name_to_show * reference *)
            | Link of (string * string) (**FIXME: put code instead of string *)

(** Describes a user-defined printing rule. This type handles both
 * printing and printing_command commands (differentiated with the
 * is_command bool. The match_element is the element that should be replaced
 * by replace_with (which is a raw_content in order to have its output
 * "backend free", the default field containing the match_element *)
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
  (* Type for formatted code output: list of code elements *)
  ]

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
  | `Item of 'a (* List items in coqdoc *)
  | `Emphasis of 'a
  (* Type for a sequence of doc elements: DO NOT CONFUSE WITH `List *)
  | `Seq of 'a list ]

(** Types representing the documentation elements (what is located inside
 * documentations comments in the source file), before and after evaluation.
 *)
type doc_with_eval = [flat_element | eval_element | doc_with_eval rec_element]
type doc_no_eval = [flat_element | doc_no_eval rec_element]


(** Type containing the full input file structure. After evaluation,
 * everything is translated into a do_no_eval type: comments are discarded
 * and code is translated into formatted documentation *)
type ('a,'b) cst_node =
  | Comment of string
  | Doc of 'a
  | Code of 'b

type ('a,'b) cst = (('a,'b) cst_node) list

(* Converts source and doc types into the common type cst *)
let make_cst (doc_converter:string -> doc_with_eval) = function
  | Doc d -> Doc (doc_converter d)
  | Comment s -> Comment s
  | Code s -> Code s
