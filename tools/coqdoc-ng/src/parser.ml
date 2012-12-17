exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SECTION of (
# 7 "parser.mly"
       (int*string)
# 13 "parser.ml"
)
  | RM_PRINTING of (
# 8 "parser.mly"
       (string)
# 18 "parser.ml"
)
  | QUERY of (
# 10 "parser.mly"
       (string*string)
# 23 "parser.ml"
)
  | LST of (
# 6 "parser.mly"
       (int)
# 28 "parser.ml"
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
# 45 "parser.ml"
)
  | ADD_PRINTING of (
# 9 "parser.mly"
       (bool*string)
# 50 "parser.ml"
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
  | MenhirState57
  | MenhirState54
  | MenhirState48
  | MenhirState44
  | MenhirState38
  | MenhirState35
  | MenhirState30
  | MenhirState29
  | MenhirState17
  | MenhirState16
  | MenhirState15
  | MenhirState5
  | MenhirState4
  | MenhirState0


# 17 "parser.mly"
  
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

# 98 "parser.ml"
let _eRR =
  Error

let rec _menhir_goto_parse_lst : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_lst -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv285 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv283 * _menhir_state * 'tv_parse_lst) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState38
    | LST _v ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState38
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState38) : 'freshtv284)) : 'freshtv286)

and _menhir_goto_list_parse_lst_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_lst_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState38 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv261 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv259 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_lst_ = 
# 116 "/usr/share/menhir/standard.mly"
    ( x :: xs )
# 137 "parser.ml"
         in
        _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv260)) : 'freshtv262)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv271 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 145 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv269 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 153 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv265 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 162 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv263 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 169 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_lst = 
# 69 "parser.mly"
  (`List lst)
# 175 "parser.ml"
             in
            _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv264)) : 'freshtv266)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv267 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 185 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv268)) : 'freshtv270)) : 'freshtv272)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv281 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 194 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv279 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 202 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv275 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 211 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv273 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 218 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 65 "parser.mly"
    (`List lst)
# 224 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv274)) : 'freshtv276)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv277 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 234 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv278)) : 'freshtv280)) : 'freshtv282)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_term_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_term_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv243 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv241 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_term_ = 
# 116 "/usr/share/menhir/standard.mly"
    ( x :: xs )
# 254 "parser.ml"
         in
        _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv242)) : 'freshtv244)
    | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv247 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv245 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, c) = _menhir_stack in
        let _v : 'tv_parse_lst = 
# 71 "parser.mly"
  (`Item  (`Seq c) )
# 266 "parser.ml"
         in
        _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv246)) : 'freshtv248)
    | MenhirState44 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv257 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv255 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EMPHASIS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv251 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv249 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 63 "parser.mly"
    (`Emphasis (`Seq lst))
# 288 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv250)) : 'freshtv252)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv253 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv254)) : 'freshtv256)) : 'freshtv258)
    | _ ->
        _menhir_fail ()

and _menhir_goto_parse_seq : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_seq -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv239 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv237 * _menhir_state * 'tv_parse_seq) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | EMPHASIS ->
        _menhir_run44 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | HRULE ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | HTML ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | LATEX ->
        _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | LATEX_MATH ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | LST _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState48) : 'freshtv238)) : 'freshtv240)

and _menhir_goto_list_raw_terms_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_raw_terms_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv225 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv223 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_raw_terms_ = 
# 116 "/usr/share/menhir/standard.mly"
    ( x :: xs )
# 360 "parser.ml"
         in
        _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv224)) : 'freshtv226)
    | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv235 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 368 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv233 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 376 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv229 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 385 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv227 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 392 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _1), _, translations) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 91 "parser.mly"
( let open Cst in
  let final_translation = (merge_raw_content translations) in
  `Add_printing {is_command = (fst _1); match_element = (snd _1);
  replace_with = {latex = final_translation.latex; html =
    final_translation.html; latex_math = final_translation.latex_math;
    default = (snd _1)}}
)
# 404 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv228)) : 'freshtv230)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv231 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 414 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv232)) : 'freshtv234)) : 'freshtv236)
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
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv205 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv203 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_seq_ = 
# 116 "/usr/share/menhir/standard.mly"
    ( x :: xs )
# 439 "parser.ml"
         in
        _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv204)) : 'freshtv206)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv221 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv219 * _menhir_state * 'tv_list_parse_seq_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv215 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv213 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, lst) = _menhir_stack in
            let _v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 460 "parser.ml"
            ) = 
# 55 "parser.mly"
    (`Seq lst)
# 464 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv211) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 472 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv209) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 480 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv207) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_1 : (
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 488 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv208)) : 'freshtv210)) : 'freshtv212)) : 'freshtv214)) : 'freshtv216)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv217 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv218)) : 'freshtv220)) : 'freshtv222)
    | _ ->
        _menhir_fail ()

and _menhir_reduce4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_lst_ = 
# 114 "/usr/share/menhir/standard.mly"
    ( [] )
# 506 "parser.ml"
     in
    _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run16 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (int)
# 513 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv201 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 522 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | LST _v ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16) : 'freshtv202)

and _menhir_run17 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv199 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | HRULE ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | HTML ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | LATEX ->
        _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | LATEX_MATH ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | ENDLST | ITEM | LST _ ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState17) : 'freshtv200)

and _menhir_goto_raw_terms : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_raw_terms -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState30 | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv191 * _menhir_state * 'tv_raw_terms) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | LATEX ->
            _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | LATEX_MATH ->
            _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | EOF ->
            _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState30
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState30) : 'freshtv192)) : 'freshtv194)
    | MenhirState48 | MenhirState0 | MenhirState44 | MenhirState35 | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv197 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv195 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _1) = _menhir_stack in
        let _v : 'tv_parse_term = 
# 101 "parser.mly"
  (`Raw _1)
# 610 "parser.ml"
         in
        _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv196)) : 'freshtv198)
    | _ ->
        _menhir_fail ()

and _menhir_reduce8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_term_ = 
# 114 "/usr/share/menhir/standard.mly"
    ( [] )
# 621 "parser.ml"
     in
    _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_parse_term : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_term -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState44 | MenhirState35 | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv183 * _menhir_state * 'tv_parse_term) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ADD_PRINTING _v ->
            _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | CONTENT _v ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | HRULE ->
            _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | HTML ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | LATEX ->
            _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | LATEX_MATH ->
            _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | QUERY _v ->
            _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | RM_PRINTING _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | SECTION _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | STARTPP ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | STARTVERBATIM ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | STARTVERNAC ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | EMPHASIS | ENDLST | ITEM | LST _ ->
            _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState35) : 'freshtv184)) : 'freshtv186)
    | MenhirState48 | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv189 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, term) = _menhir_stack in
        let _v : 'tv_parse_seq = 
# 61 "parser.mly"
    (term)
# 677 "parser.ml"
         in
        _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv188)) : 'freshtv190)
    | _ ->
        _menhir_fail ()

and _menhir_reduce10 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_raw_terms_ = 
# 114 "/usr/share/menhir/standard.mly"
    ( [] )
# 688 "parser.ml"
     in
    _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_list_CONTENT_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_CONTENT_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv151 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 701 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv149 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 707 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_CONTENT_ = 
# 116 "/usr/share/menhir/standard.mly"
    ( x :: xs )
# 713 "parser.ml"
         in
        _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv150)) : 'freshtv152)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv161 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv159 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERBATIM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv155 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv153 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 80 "parser.mly"
  (`Verbatim (merge_contents _2))
# 735 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv154)) : 'freshtv156)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv157 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv158)) : 'freshtv160)) : 'freshtv162)
    | MenhirState54 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv171) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv169) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv165) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv163) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 763 "parser.ml"
            ) = 
# 45 "parser.mly"
  (Cst.Doc (merge_contents _2))
# 767 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv164)) : 'freshtv166)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv167) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv168)) : 'freshtv170)) : 'freshtv172)
    | MenhirState57 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv181) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv179) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv175) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv173) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 795 "parser.ml"
            ) = 
# 43 "parser.mly"
  (Cst.Comment (merge_contents _2))
# 799 "parser.ml"
             in
            _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv174)) : 'freshtv176)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv177) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv178)) : 'freshtv180)) : 'freshtv182)
    | _ ->
        _menhir_fail ()

and _menhir_reduce6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_seq_ = 
# 114 "/usr/share/menhir/standard.mly"
    ( [] )
# 817 "parser.ml"
     in
    _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv147 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv143 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 835 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv141 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 843 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERNAC ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv137 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 852 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv135 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 859 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 76 "parser.mly"
  (`Vernac _2)
# 865 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv136)) : 'freshtv138)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv139 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 875 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv140)) : 'freshtv142)) : 'freshtv144)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv145 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv146)) : 'freshtv148)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv133 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState4 _v
    | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState4
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState4) : 'freshtv134)

and _menhir_run9 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv131 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 8 "parser.mly"
       (string)
# 918 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv125 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 926 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDPP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv121 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 935 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv119 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 942 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 78 "parser.mly"
  (`Pretty_print _2)
# 948 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv120)) : 'freshtv122)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv123 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 958 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv124)) : 'freshtv126)) : 'freshtv128)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv129 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv130)) : 'freshtv132)

and _menhir_run12 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (int*string)
# 973 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv117) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 7 "parser.mly"
       (int*string)
# 983 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 82 "parser.mly"
  (`Section _1)
# 988 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv118)

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 995 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv115) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (tok : (
# 8 "parser.mly"
       (string)
# 1005 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 99 "parser.mly"
( `Rm_printing tok )
# 1010 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv116)

and _menhir_run14 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 10 "parser.mly"
       (string*string)
# 1017 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv113) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (query : (
# 10 "parser.mly"
       (string*string)
# 1027 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 88 "parser.mly"
  (let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist)))
# 1033 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)

and _menhir_run15 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (int)
# 1040 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv111 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1049 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | LST _v ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState15 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState15) : 'freshtv112)

and _menhir_run18 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
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
# 1078 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv103 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1086 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX_MATH ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv99 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1095 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv97 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1102 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 107 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=_2; Cst.html=""; Cst.default = ""})
# 1108 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv98)) : 'freshtv100)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1118 "parser.ml"
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

and _menhir_run21 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
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
# 1144 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv89 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1152 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv85 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1161 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv83 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1168 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 105 "parser.mly"
  ({Cst.latex = _2; Cst.latex_math=""; Cst.html=""; Cst.default = ""})
# 1174 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv84)) : 'freshtv86)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv87 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1184 "parser.ml"
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

and _menhir_run24 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
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
# 1210 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv75 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1218 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv71 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1227 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv69 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1234 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 109 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=""; Cst.html=_2; Cst.default = ""})
# 1240 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv70)) : 'freshtv72)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv73 * _menhir_state) * (
# 8 "parser.mly"
       (string)
# 1250 "parser.ml"
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

and _menhir_run27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv67) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _v : 'tv_parse_term = 
# 84 "parser.mly"
  (`Hrule)
# 1271 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv68)

and _menhir_run44 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv65 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_PRINTING _v ->
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState44 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState44 _v
    | HRULE ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | HTML ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | LATEX ->
        _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | LATEX_MATH ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState44 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState44 _v
    | SECTION _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState44 _v
    | STARTPP ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | STARTVERBATIM ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | STARTVERNAC ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | EMPHASIS ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState44
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState44) : 'freshtv66)

and _menhir_run28 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1317 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv63) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 8 "parser.mly"
       (string)
# 1327 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 86 "parser.mly"
  (`Content _1)
# 1332 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv64)

and _menhir_run29 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 9 "parser.mly"
       (bool*string)
# 1339 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv61 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1348 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | HTML ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | LATEX ->
        _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | LATEX_MATH ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | EOF ->
        _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState29
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState29) : 'freshtv62)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState57 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv34)
    | MenhirState54 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv35) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv36)
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState44 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState38 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState29 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv47 * _menhir_state * (
# 9 "parser.mly"
       (bool*string)
# 1406 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState17 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv49 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv51 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1420 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * (
# 6 "parser.mly"
       (int)
# 1429 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1438 "parser.ml"
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
# 114 "/usr/share/menhir/standard.mly"
    ( [] )
# 1457 "parser.ml"
     in
    _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 8 "parser.mly"
       (string)
# 1464 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv31 * _menhir_state * (
# 8 "parser.mly"
       (string)
# 1473 "parser.ml"
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
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1501 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv29) = Obj.magic _menhir_stack in
    let (_v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1509 "parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
    let (_1 : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1516 "parser.ml"
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
# 15 "parser.mly"
      (Cst.doc_with_eval)
# 1535 "parser.ml"
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
        _menhir_run29 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | CONTENT _v ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | EMPHASIS ->
        _menhir_run44 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HRULE ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | HTML ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX ->
        _menhir_run21 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LATEX_MATH ->
        _menhir_run18 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LST _v ->
        _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | QUERY _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | RM_PRINTING _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | SECTION _v ->
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
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1585 "parser.ml"
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
# 1603 "parser.ml"
        )) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
        let (_1 : (
# 8 "parser.mly"
       (string)
# 1610 "parser.ml"
        )) = _v in
        ((let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1615 "parser.ml"
        ) = 
# 47 "parser.mly"
  (Cst.Code _1 )
# 1619 "parser.ml"
         in
        _menhir_goto_parse_vernac _menhir_env _menhir_stack _v) : 'freshtv2)) : 'freshtv4)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        ((let _v : (
# 14 "parser.mly"
      ((string,string) Cst.cst_node)
# 1630 "parser.ml"
        ) = 
# 49 "parser.mly"
  (raise Cst.End_of_file)
# 1634 "parser.ml"
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
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState57 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState57) : 'freshtv10)) : 'freshtv12)
    | STARTDOC ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState54) : 'freshtv14)) : 'freshtv16)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv18)) : 'freshtv20)) : 'freshtv22))



