exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SHOW_CONTROL of (
# 11 "parser.mly"
       (string*string)
# 13 "parser.ml"
)
  | SECTION of (
# 7 "parser.mly"
       (int*string)
# 18 "parser.ml"
)
  | RM_PRINTING of (
# 8 "parser.mly"
       (string)
# 23 "parser.ml"
)
  | QUERY of (
# 10 "parser.mly"
       (string*string)
# 28 "parser.ml"
)
  | LST of (
# 6 "parser.mly"
       (int)
# 33 "parser.ml"
)
  | LATEX_MATH
  | LATEX
  | ITEM
  | HTML
  | HRULE
  | EOF
  | ENDVERNAC
  | ENDVERBATIM
  | ENDPP
  | ENDLST
  | ENDCOM
  | EMPHASIS
  | CONTENT of (
# 8 "parser.mly"
       (string)
# 50 "parser.ml"
)
  | ADD_PRINTING of (
# 9 "parser.mly"
       (bool*string)
# 55 "parser.ml"
)

and _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  mutable _menhir_token: token;
  mutable _menhir_startp: Lexing.position;
  mutable _menhir_endp: Lexing.position;
  mutable _menhir_shifted: int
}

and _menhir_state = 
  | MenhirState58
  | MenhirState55
  | MenhirState49
  | MenhirState45
  | MenhirState39
  | MenhirState36
  | MenhirState31
  | MenhirState30
  | MenhirState18
  | MenhirState17
  | MenhirState16
  | MenhirState5
  | MenhirState4
  | MenhirState0


# 18 "parser.mly"
  
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""

  (** Merges a list of Cst.raw_content elements. The last non-empty fields
   * encountered are kept *)
  let merge_raw_content lst =
    let open Cst in List.fold_left (fun acc item ->
    { latex =
          if item.latex <> "" then item.latex else acc.latex;
      latex_math =
        if item.latex_math <> "" then item.latex_math else acc.latex_math;
      html =
        if item.html <> "" then item.html else acc.html;
      default =
        if item.default <> "" then item.default else acc.default})
    {latex = ""; latex_math = ""; html = ""; default= ""} lst

# 103 "parser.ml"
let _eRR =
  Error

let rec _menhir_goto_parse_lst : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_lst -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv287 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv285 * _menhir_state * 'tv_parse_lst) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | LST _v ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState39 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv286)) : 'freshtv288)

and _menhir_goto_list_parse_lst_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_lst_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv263 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv261 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_lst_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 142 "parser.ml"
         in
        _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv262)) : 'freshtv264)
    | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv273 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 150 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv271 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 158 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv267 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 167 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv265 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 174 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_lst = 
# 70 "parser.mly"
  (`List lst)
# 180 "parser.ml"
             in
            _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv266)) : 'freshtv268)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv269 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 190 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv270)) : 'freshtv272)) : 'freshtv274)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv283 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 199 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv281 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 207 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv277 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 216 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv275 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 223 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 66 "parser.mly"
    (`List lst)
# 229 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv276)) : 'freshtv278)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv279 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 239 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv280)) : 'freshtv282)) : 'freshtv284)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_term_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_term_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv245 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv243 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_term_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 259 "parser.ml"
         in
        _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv244)) : 'freshtv246)
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv249 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv247 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, c) = _menhir_stack in
        let _v : 'tv_parse_lst = 
# 72 "parser.mly"
  (`Item  (`Seq c) )
# 271 "parser.ml"
         in
        _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv248)) : 'freshtv250)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv259 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv257 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EMPHASIS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv253 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv251 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 64 "parser.mly"
    (`Emphasis (`Seq lst))
# 293 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv252)) : 'freshtv254)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv255 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv256)) : 'freshtv258)) : 'freshtv260)
    | _ ->
        _menhir_fail ()

and _menhir_goto_parse_seq : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_seq -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv241 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv239 * _menhir_state * 'tv_parse_seq) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | CONTENT _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | EMPHASIS ->
        _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | HRULE ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | HTML ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | LATEX ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | LATEX_MATH ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | LST _v ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | QUERY _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | RM_PRINTING _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | SECTION _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | SHOW_CONTROL _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState49) : 'freshtv240)) : 'freshtv242)

and _menhir_goto_list_raw_terms_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_raw_terms_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv227 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv225 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_raw_terms_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 367 "parser.ml"
         in
        _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv226)) : 'freshtv228)
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv237 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 375 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv235 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 383 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv231 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 392 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv229 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 399 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _1), _, translations) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 92 "parser.mly"
( let open Cst in
  let final_translation = (merge_raw_content translations) in
  `Add_printing {is_command = (fst _1); match_element = (snd _1);
  replace_with = {latex = final_translation.latex; html =
    final_translation.html; latex_math = final_translation.latex_math;
    default = (snd _1)}}
)
# 411 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)) : 'freshtv232)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv233 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 421 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv234)) : 'freshtv236)) : 'freshtv238)
    | _ ->
        _menhir_fail ()

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_list_parse_seq_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_seq_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState49 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv207 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv205 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_seq_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 446 "parser.ml"
         in
        _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv206)) : 'freshtv208)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv223 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv221 * _menhir_state * 'tv_list_parse_seq_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv217 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv215 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, lst) = _menhir_stack in
            let _v : (
# 16 "parser.mly"
      (Cst.doc_with_eval)
# 467 "parser.ml"
            ) = 
# 56 "parser.mly"
    (`Seq lst)
# 471 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv213) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 16 "parser.mly"
      (Cst.doc_with_eval)
# 479 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv211) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 16 "parser.mly"
      (Cst.doc_with_eval)
# 487 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv209) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_1 : (
# 16 "parser.mly"
      (Cst.doc_with_eval)
# 495 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv210)) : 'freshtv212)) : 'freshtv214)) : 'freshtv216)) : 'freshtv218)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv219 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv220)) : 'freshtv222)) : 'freshtv224)
    | _ ->
        _menhir_fail ()

and _menhir_reduce4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_lst_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 513 "parser.ml"
     in
    _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run17 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (int)
# 520 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv203 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 529 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | LST _v ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState17) : 'freshtv204)

and _menhir_run18 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv201 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | CONTENT _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | HRULE ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | HTML ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | LATEX ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | LATEX_MATH ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | QUERY _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | RM_PRINTING _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | SECTION _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | SHOW_CONTROL _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | ENDLST | ITEM | LST _ ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState18
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState18) : 'freshtv202)

and _menhir_goto_raw_terms : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_raw_terms -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState31 | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv195 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * 'tv_raw_terms) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | LATEX ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | LATEX_MATH ->
            _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | EOF ->
            _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState31) : 'freshtv194)) : 'freshtv196)
    | MenhirState49 | MenhirState0 | MenhirState45 | MenhirState36 | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv199 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv197 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _1) = _menhir_stack in
        let _v : 'tv_parse_term = 
# 102 "parser.mly"
  (`Raw _1)
# 619 "parser.ml"
         in
        _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv198)) : 'freshtv200)
    | _ ->
        _menhir_fail ()

and _menhir_reduce8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_term_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 630 "parser.ml"
     in
    _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_parse_term : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_term -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState45 | MenhirState36 | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185 * _menhir_state * 'tv_parse_term) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ADD_PRINTING _v ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | CONTENT _v ->
            _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | HRULE ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | HTML ->
            _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | LATEX ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | LATEX_MATH ->
            _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | QUERY _v ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | RM_PRINTING _v ->
            _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | SECTION _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | SHOW_CONTROL _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | STARTPP ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | STARTVERBATIM ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | STARTVERNAC ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | EMPHASIS | ENDLST | ITEM | LST _ ->
            _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState36) : 'freshtv186)) : 'freshtv188)
    | MenhirState49 | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv191 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv189 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, term) = _menhir_stack in
        let _v : 'tv_parse_seq = 
# 62 "parser.mly"
    (term)
# 688 "parser.ml"
         in
        _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv190)) : 'freshtv192)
    | _ ->
        _menhir_fail ()

and _menhir_reduce10 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_raw_terms_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 699 "parser.ml"
     in
    _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_list_CONTENT_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_CONTENT_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv153 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 712 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv151 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 718 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_CONTENT_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 724 "parser.ml"
         in
        _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv152)) : 'freshtv154)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv163 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv161 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERBATIM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv157 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv155 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 81 "parser.mly"
  (`Verbatim (merge_contents _2))
# 746 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv156)) : 'freshtv158)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv159 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv160)) : 'freshtv162)) : 'freshtv164)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv173) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv171) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv167) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv165) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 774 "parser.ml"
            ) = 
# 46 "parser.mly"
  (Cst.Doc (merge_contents _2))
# 778 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv166)) : 'freshtv168)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv169) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv170)) : 'freshtv172)) : 'freshtv174)
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv183) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv181) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv177) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv175) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 806 "parser.ml"
            ) = 
# 44 "parser.mly"
  (Cst.Comment (merge_contents _2))
# 810 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv176)) : 'freshtv178)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv179) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv180)) : 'freshtv182)) : 'freshtv184)
    | _ ->
        _menhir_fail ()

and _menhir_reduce6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_seq_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 828 "parser.ml"
     in
    _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv149 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv145 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 846 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv143 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 854 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERNAC ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv139 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 863 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv137 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 870 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 77 "parser.mly"
  (`Vernac _2)
# 876 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv138)) : 'freshtv140)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv141 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 886 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv142)) : 'freshtv144)) : 'freshtv146)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv147 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv148)) : 'freshtv150)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv135 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState4 _v
    | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState4
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState4) : 'freshtv136)

and _menhir_run9 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv133 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv129 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 929 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv127 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 937 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDPP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv123 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 946 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv121 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 953 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 79 "parser.mly"
  (`Pretty_print _2)
# 959 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv122)) : 'freshtv124)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv125 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 969 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv126)) : 'freshtv128)) : 'freshtv130)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv131 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv132)) : 'freshtv134)

and _menhir_run12 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 11 "parser.mly"
       (string*string)
# 984 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv119) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (show_contr : (
# 11 "parser.mly"
       (string*string)
# 994 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 104 "parser.mly"
( `Control (match show_contr with
  | "begin","show" -> Cst.BeginShow
  | "begin","hide" -> Cst.BeginHide
  | "end","show" ->   Cst.EndShow
  | "end","hide" ->  Cst.EndHide
  | _,_ -> assert false))
# 1004 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv120)

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (int*string)
# 1011 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv117) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 7 "parser.mly"
       (int*string)
# 1021 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 83 "parser.mly"
  (`Section _1)
# 1026 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv118)

and _menhir_run14 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1033 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv115) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (tok : (
# 8 "parser.mly"
       (string)
# 1043 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 100 "parser.mly"
( `Rm_printing tok )
# 1048 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv116)

and _menhir_run15 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 10 "parser.mly"
       (string*string)
# 1055 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv113) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (query : (
# 10 "parser.mly"
       (string*string)
# 1065 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 89 "parser.mly"
  (let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist)))
# 1071 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)

and _menhir_run16 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (int)
# 1078 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv111 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1087 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | LST _v ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16) : 'freshtv112)

and _menhir_run19 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv109 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv105 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1116 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv103 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1124 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX_MATH ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv99 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1133 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv97 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1140 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 115 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=_2; Cst.html=""; Cst.default = ""})
# 1146 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv98)) : 'freshtv100)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1156 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv102)) : 'freshtv104)) : 'freshtv106)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv107 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv108)) : 'freshtv110)

and _menhir_run22 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv95 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv91 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1182 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv89 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1190 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv85 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1199 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv83 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1206 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 113 "parser.mly"
  ({Cst.latex = _2; Cst.latex_math=""; Cst.html=""; Cst.default = ""})
# 1212 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv84)) : 'freshtv86)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv87 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1222 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv88)) : 'freshtv90)) : 'freshtv92)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv93 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv94)) : 'freshtv96)

and _menhir_run25 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv81 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv77 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1248 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv75 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1256 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv71 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1265 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv69 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1272 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 117 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=""; Cst.html=_2; Cst.default = ""})
# 1278 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv70)) : 'freshtv72)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv73 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1288 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv74)) : 'freshtv76)) : 'freshtv78)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv79 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv80)) : 'freshtv82)

and _menhir_run28 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv67) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _v : 'tv_parse_term = 
# 85 "parser.mly"
  (`Hrule)
# 1309 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv68)

and _menhir_run45 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv65 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | CONTENT _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | HRULE ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | HTML ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | LATEX ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | LATEX_MATH ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | QUERY _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | RM_PRINTING _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | SECTION _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | SHOW_CONTROL _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | EMPHASIS ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState45) : 'freshtv66)

and _menhir_run29 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1357 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv63) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 8 "parser.mly"
       (string)
# 1367 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 87 "parser.mly"
  (`Content _1)
# 1372 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv64)

and _menhir_run30 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 9 "parser.mly"
       (bool*string)
# 1379 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv61 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1388 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | HTML ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | LATEX ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | LATEX_MATH ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | EOF ->
        _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState30) : 'freshtv62)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv34)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv35) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv36)
    | MenhirState49 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv47 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1446 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv49 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv51 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1460 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1469 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1478 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv59) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv60)

and _menhir_reduce2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_CONTENT_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 1497 "parser.ml"
     in
    _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1504 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv31 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1513 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState5 _v
    | ENDCOM | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState5
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv32)

and _menhir_discard : _menhir_env -> token =
  fun _menhir_env ->
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = _menhir_env._menhir_lexer lexbuf in
    _menhir_env._menhir_token <- _tok;
    _menhir_env._menhir_startp <- lexbuf.Lexing.lex_start_p;
    _menhir_env._menhir_endp <- lexbuf.Lexing.lex_curr_p;
    let shifted = Pervasives.(+) _menhir_env._menhir_shifted 1 in
    if Pervasives.(>=) shifted 0 then
      _menhir_env._menhir_shifted <- shifted;
    _tok

and _menhir_goto_parse_vernac : _menhir_env -> 'ttv_tail -> (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1541 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv29) = Obj.magic _menhir_stack in
    let (_v : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1549 "parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
    let (_1 : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1556 "parser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv28)) : 'freshtv30)

and _menhir_init : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> _menhir_env =
  fun lexer lexbuf ->
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_startp = lexbuf.Lexing.lex_start_p;
      _menhir_endp = lexbuf.Lexing.lex_curr_p;
      _menhir_shifted = 4611686018427387903;
      }

and parse_doc : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 16 "parser.mly"
      (Cst.doc_with_eval)
# 1575 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv25) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv23) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | CONTENT _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | EMPHASIS ->
        _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HRULE ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HTML ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX_MATH ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LST _v ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | QUERY _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | RM_PRINTING _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | SECTION _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | SHOW_CONTROL _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv24)) : 'freshtv26))

and parse_vernac : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1627 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv21) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv19) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 1645 "parser.ml"
        )) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
        let (_1 : (
# 8 "parser.mly"
       (string)
# 1652 "parser.ml"
        )) = _v in
        ((let _v : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1657 "parser.ml"
        ) = 
# 48 "parser.mly"
  (Cst.Code _1 )
# 1661 "parser.ml"
         in
        _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv2)) : 'freshtv4)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        ((let _v : (
# 15 "parser.mly"
      (string Cst.cst_node)
# 1672 "parser.ml"
        ) = 
# 50 "parser.mly"
  (raise Cst.End_of_file)
# 1676 "parser.ml"
         in
        _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv6)) : 'freshtv8)
    | STARTCOM ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState58
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState58) : 'freshtv10)) : 'freshtv12)
    | STARTDOC ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState55 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState55
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState55) : 'freshtv14)) : 'freshtv16)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv18)) : 'freshtv20)) : 'freshtv22))



