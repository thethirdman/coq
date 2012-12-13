exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SECTION of (
# 5 "parser.mly"
       (int*string)
# 13 "parser.ml"
)
  | RM_TOKEN of (
# 6 "parser.mly"
       (string)
# 18 "parser.ml"
)
  | QUERY of (
# 7 "parser.mly"
       (string*string)
# 23 "parser.ml"
)
  | LST of (
# 4 "parser.mly"
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
# 6 "parser.mly"
       (string)
# 45 "parser.ml"
)
  | ADD_TOKEN of (
# 6 "parser.mly"
       (string)
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
  | MenhirState58
  | MenhirState54
  | MenhirState48
  | MenhirState45
  | MenhirState40
  | MenhirState39
  | MenhirState27
  | MenhirState26
  | MenhirState25
  | MenhirState16
  | MenhirState12
  | MenhirState6
  | MenhirState2
  | MenhirState1


# 13 "parser.mly"
  
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""

# 84 "parser.ml"
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
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | LST _v ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState48
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState48) : 'freshtv284)) : 'freshtv286)

and _menhir_goto_list_parse_lst_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_lst_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv261 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv259 * _menhir_state * 'tv_parse_lst) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_lst_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 123 "parser.ml"
         in
        _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv260)) : 'freshtv262)
    | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv271 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 131 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv269 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 139 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv265 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 148 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv263 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 155 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_lst = 
# 45 "parser.mly"
  (`List lst)
# 161 "parser.ml"
             in
            _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv264)) : 'freshtv266)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv267 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 171 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv268)) : 'freshtv270)) : 'freshtv272)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv281 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 180 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv279 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 188 "parser.ml"
        )) * _menhir_state * 'tv_list_parse_lst_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDLST ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv275 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 197 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv273 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 204 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, _), _, lst) = _menhir_stack in
            let _v : 'tv_parse_seq = 
# 41 "parser.mly"
    (`List lst)
# 210 "parser.ml"
             in
            _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv274)) : 'freshtv276)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv277 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 220 "parser.ml"
            )) * _menhir_state * 'tv_list_parse_lst_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv278)) : 'freshtv280)) : 'freshtv282)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_term_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_term_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv243 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv241 * _menhir_state * 'tv_parse_term) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_term_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 240 "parser.ml"
         in
        _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv242)) : 'freshtv244)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv247 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv245 * _menhir_state) * _menhir_state * 'tv_list_parse_term_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, c) = _menhir_stack in
        let _v : 'tv_parse_lst = 
# 47 "parser.mly"
  ((`Item  (0,`Seq c)) )
# 252 "parser.ml"
         in
        _menhir_goto_parse_lst _menhir_env _menhir_stack _menhir_s _v) : 'freshtv246)) : 'freshtv248)
    | MenhirState54 ->
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
# 39 "parser.mly"
    (`Emphasis (`Seq lst))
# 274 "parser.ml"
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

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

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
    | ADD_TOKEN _v ->
        _menhir_run39 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | CONTENT _v ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | EMPHASIS ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | HRULE ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | HTML ->
        _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | LATEX ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | LATEX_MATH ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | LST _v ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | QUERY _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | RM_TOKEN _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState58) : 'freshtv238)) : 'freshtv240)

and _menhir_goto_list_raw_terms_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_raw_terms_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv225 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv223 * _menhir_state * 'tv_raw_terms) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_raw_terms_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 351 "parser.ml"
         in
        _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv224)) : 'freshtv226)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv235 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 359 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv233 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 367 "parser.ml"
        )) * _menhir_state * 'tv_list_raw_terms_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv229 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 376 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv227 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 383 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, tok), _, translations) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 66 "parser.mly"
(
  let open Cst in
  let merged_term =
    List.fold_left (fun acc item ->
      {latex = if item.latex <> "" then item.latex else acc.latex;
      latex_math = if item.latex_math <> "" then item.latex_math else acc.latex_math;
      html = if item.html <> "" then item.html else acc.html;})
    {latex = ""; latex_math = ""; html = ""} translations in
  `Add_token (tok, merged_term))
# 397 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv228)) : 'freshtv230)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv231 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 407 "parser.ml"
            )) * _menhir_state * 'tv_list_raw_terms_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv232)) : 'freshtv234)) : 'freshtv236)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_CONTENT_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_CONTENT_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv191 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 423 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv189 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 429 "parser.ml"
        )) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_CONTENT_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 435 "parser.ml"
         in
        _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv190)) : 'freshtv192)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv201) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv199) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv195) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv193) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 456 "parser.ml"
            ) = 
# 25 "parser.mly"
  (Cst.Doc (merge_contents _2))
# 460 "parser.ml"
             in
            _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv194)) : 'freshtv196)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv197) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv198)) : 'freshtv200)) : 'freshtv202)
    | MenhirState6 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv211) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv209) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDCOM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv205) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv203) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _, _2) = _menhir_stack in
            let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 488 "parser.ml"
            ) = 
# 23 "parser.mly"
  (Cst.Comment (merge_contents _2))
# 492 "parser.ml"
             in
            _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv204)) : 'freshtv206)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv207) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv208)) : 'freshtv210)) : 'freshtv212)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv221 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv219 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERBATIM ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv215 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv213 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 55 "parser.mly"
  (`Verbatim (merge_contents _2))
# 521 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv214)) : 'freshtv216)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv217 * _menhir_state) * _menhir_state * 'tv_list_CONTENT_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv218)) : 'freshtv220)) : 'freshtv222)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_parse_seq_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_parse_seq_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv171 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv169 * _menhir_state * 'tv_parse_seq) * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, x), _, xs) = _menhir_stack in
        let _v : 'tv_list_parse_seq_ = 
# 116 "/usr/local/share/menhir/standard.mly"
    ( x :: xs )
# 547 "parser.ml"
         in
        _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv170)) : 'freshtv172)
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185 * _menhir_state * 'tv_list_parse_seq_) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv181 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv179 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, lst) = _menhir_stack in
            let _v : (
# 11 "parser.mly"
      (Cst.doc)
# 568 "parser.ml"
            ) = 
# 33 "parser.mly"
    (`Seq lst)
# 572 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv177) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 11 "parser.mly"
      (Cst.doc)
# 580 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv175) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 11 "parser.mly"
      (Cst.doc)
# 588 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv173) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_1 : (
# 11 "parser.mly"
      (Cst.doc)
# 596 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv174)) : 'freshtv176)) : 'freshtv178)) : 'freshtv180)) : 'freshtv182)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv183 * _menhir_state * 'tv_list_parse_seq_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv184)) : 'freshtv186)) : 'freshtv188)
    | _ ->
        _menhir_fail ()

and _menhir_reduce4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_lst_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 614 "parser.ml"
     in
    _menhir_goto_list_parse_lst_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run26 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 4 "parser.mly"
       (int)
# 621 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv167 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 630 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | LST _v ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState26
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState26) : 'freshtv168)

and _menhir_run27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv165 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_TOKEN _v ->
        _menhir_run39 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | CONTENT _v ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | HRULE ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | HTML ->
        _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | LATEX ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | LATEX_MATH ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | QUERY _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | RM_TOKEN _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | ENDLST | ITEM | LST _ ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState27
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27) : 'freshtv166)

and _menhir_goto_raw_terms : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_raw_terms -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState40 | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv159 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv157 * _menhir_state * 'tv_raw_terms) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | LATEX ->
            _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | LATEX_MATH ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | EOF ->
            _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40) : 'freshtv158)) : 'freshtv160)
    | MenhirState58 | MenhirState12 | MenhirState54 | MenhirState45 | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv163 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv161 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _1) = _menhir_stack in
        let _v : 'tv_parse_term = 
# 78 "parser.mly"
  (`Raw _1)
# 718 "parser.ml"
         in
        _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv162)) : 'freshtv164)
    | _ ->
        _menhir_fail ()

and _menhir_reduce8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_term_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 729 "parser.ml"
     in
    _menhir_goto_list_parse_term_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_parse_term : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parse_term -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState54 | MenhirState45 | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv151 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        let _tok = _menhir_env._menhir_token in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv149 * _menhir_state * 'tv_parse_term) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ADD_TOKEN _v ->
            _menhir_run39 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | CONTENT _v ->
            _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | HRULE ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | HTML ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LATEX ->
            _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LATEX_MATH ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | QUERY _v ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | RM_TOKEN _v ->
            _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | SECTION _v ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | STARTPP ->
            _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | STARTVERBATIM ->
            _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | STARTVERNAC ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | EMPHASIS | ENDLST | ITEM | LST _ ->
            _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState45) : 'freshtv150)) : 'freshtv152)
    | MenhirState58 | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv155 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv153 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, term) = _menhir_stack in
        let _v : 'tv_parse_seq = 
# 37 "parser.mly"
    (term)
# 785 "parser.ml"
         in
        _menhir_goto_parse_seq _menhir_env _menhir_stack _menhir_s _v) : 'freshtv154)) : 'freshtv156)
    | _ ->
        _menhir_fail ()

and _menhir_reduce10 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_raw_terms_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 796 "parser.ml"
     in
    _menhir_goto_list_raw_terms_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_reduce2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_CONTENT_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 805 "parser.ml"
     in
    _menhir_goto_list_CONTENT_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run2 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 812 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv147 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 821 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
    | ENDCOM | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2) : 'freshtv148)

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

and _menhir_goto_main : _menhir_env -> 'ttv_tail -> (
# 10 "parser.mly"
      (string Cst.cst_node)
# 849 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv145) = Obj.magic _menhir_stack in
    let (_v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 857 "parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv143) = Obj.magic _menhir_stack in
    let (_1 : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 864 "parser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv144)) : 'freshtv146)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv115 * _menhir_state * 'tv_parse_seq) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv116)
    | MenhirState54 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv118)
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv119 * _menhir_state * 'tv_parse_lst) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv120)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv121 * _menhir_state * 'tv_parse_term) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv122)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv123 * _menhir_state * 'tv_raw_terms) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv124)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv125 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 901 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv126)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv128)
    | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv129 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 915 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv130)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv131 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 924 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv132)
    | MenhirState16 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv133 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv134)
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv135) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv136)
    | MenhirState6 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv137) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv138)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv139 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 946 "parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv140)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv141) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv142)

and _menhir_reduce6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_parse_seq_ = 
# 114 "/usr/local/share/menhir/standard.mly"
    ( [] )
# 960 "parser.ml"
     in
    _menhir_goto_list_parse_seq_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv113 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv109 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 978 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv107 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 986 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDVERNAC ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv103 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 995 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1002 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 51 "parser.mly"
  (`Vernac _2)
# 1008 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv102)) : 'freshtv104)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv105 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1018 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv106)) : 'freshtv108)) : 'freshtv110)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv111 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv112)) : 'freshtv114)

and _menhir_run16 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv99 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
    | ENDVERBATIM ->
        _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState16
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16) : 'freshtv100)

and _menhir_run19 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv97 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv93 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1061 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv91 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1069 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | ENDPP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv87 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1078 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv85 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1085 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_parse_term = 
# 53 "parser.mly"
  (`Pretty_print _2)
# 1091 "parser.ml"
             in
            _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv86)) : 'freshtv88)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv89 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1101 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv90)) : 'freshtv92)) : 'freshtv94)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv95 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv96)) : 'freshtv98)

and _menhir_run22 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 5 "parser.mly"
       (int*string)
# 1116 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv83) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 5 "parser.mly"
       (int*string)
# 1126 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 57 "parser.mly"
  (`Section _1)
# 1131 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv84)

and _menhir_run23 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 1138 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv81) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (tok : (
# 6 "parser.mly"
       (string)
# 1148 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 76 "parser.mly"
( `Rm_token tok )
# 1153 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv82)

and _menhir_run24 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (string*string)
# 1160 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv79) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (query : (
# 7 "parser.mly"
       (string*string)
# 1170 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 63 "parser.mly"
  (let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist)))
# 1176 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv80)

and _menhir_run25 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 4 "parser.mly"
       (int)
# 1183 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv77 * _menhir_state * (
# 4 "parser.mly"
       (int)
# 1192 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ITEM ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState25
    | LST _v ->
        _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
    | ENDLST ->
        _menhir_reduce4 _menhir_env (Obj.magic _menhir_stack) MenhirState25
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25) : 'freshtv78)

and _menhir_run28 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv75 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv71 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1221 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv69 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1229 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX_MATH ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv65 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1238 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv63 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1245 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 84 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=_2; Cst.html="";})
# 1251 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv64)) : 'freshtv66)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv67 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1261 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv68)) : 'freshtv70)) : 'freshtv72)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv73 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv74)) : 'freshtv76)

and _menhir_run31 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv61 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1287 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv55 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1295 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | LATEX ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv51 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1304 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv49 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1311 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 82 "parser.mly"
  ({Cst.latex = _2; Cst.latex_math=""; Cst.html="";})
# 1317 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv50)) : 'freshtv52)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv53 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1327 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)) : 'freshtv56)) : 'freshtv58)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv59 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv60)) : 'freshtv62)

and _menhir_run34 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv47 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1353 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv41 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1361 "parser.ml"
        )) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | HTML ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv37 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1370 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _ = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv35 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1377 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _2) = _menhir_stack in
            let _v : 'tv_raw_terms = 
# 86 "parser.mly"
  ({Cst.latex = ""; Cst.latex_math=""; Cst.html=_2;})
# 1383 "parser.ml"
             in
            _menhir_goto_raw_terms _menhir_env _menhir_stack _menhir_s _v) : 'freshtv36)) : 'freshtv38)
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv39 * _menhir_state) * (
# 6 "parser.mly"
       (string)
# 1393 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)) : 'freshtv42)) : 'freshtv44)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)) : 'freshtv48)

and _menhir_run37 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv33) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _v : 'tv_parse_term = 
# 59 "parser.mly"
  (`Hrule)
# 1414 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv34)

and _menhir_run54 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv31 * _menhir_state) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_TOKEN _v ->
        _menhir_run39 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
    | CONTENT _v ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
    | HRULE ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | HTML ->
        _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | LATEX ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | LATEX_MATH ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | QUERY _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
    | RM_TOKEN _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | EMPHASIS ->
        _menhir_reduce8 _menhir_env (Obj.magic _menhir_stack) MenhirState54
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState54) : 'freshtv32)

and _menhir_run38 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 1460 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _ = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv29) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_1 : (
# 6 "parser.mly"
       (string)
# 1470 "parser.ml"
    )) = _v in
    ((let _v : 'tv_parse_term = 
# 61 "parser.mly"
  (`Content _1)
# 1475 "parser.ml"
     in
    _menhir_goto_parse_term _menhir_env _menhir_stack _menhir_s _v) : 'freshtv30)

and _menhir_run39 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (string)
# 1482 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _tok = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27 * _menhir_state * (
# 6 "parser.mly"
       (string)
# 1491 "parser.ml"
    )) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | HTML ->
        _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | LATEX ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | LATEX_MATH ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | EOF ->
        _menhir_reduce10 _menhir_env (Obj.magic _menhir_stack) MenhirState39
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv28)

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

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1523 "parser.ml"
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
    | CONTENT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        let (_v : (
# 6 "parser.mly"
       (string)
# 1541 "parser.ml"
        )) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        let (_1 : (
# 6 "parser.mly"
       (string)
# 1548 "parser.ml"
        )) = _v in
        ((let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1553 "parser.ml"
        ) = 
# 27 "parser.mly"
  (Cst.Code _1 )
# 1557 "parser.ml"
         in
        _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv6)) : 'freshtv8)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9) = Obj.magic _menhir_stack in
        ((let _v : (
# 10 "parser.mly"
      (string Cst.cst_node)
# 1568 "parser.ml"
        ) = 
# 29 "parser.mly"
  (raise Cst.End_of_file)
# 1572 "parser.ml"
         in
        _menhir_goto_main _menhir_env _menhir_stack _v) : 'freshtv10)) : 'freshtv12)
    | STARTCOM ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState6 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState6
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState6) : 'freshtv14)) : 'freshtv16)
    | STARTDOC ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv19) = Obj.magic _menhir_stack in
        ((let _tok = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = _menhir_stack in
        let (_tok : token) = _tok in
        ((match _tok with
        | CONTENT _v ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState1 _v
        | ENDCOM ->
            _menhir_reduce2 _menhir_env (Obj.magic _menhir_stack) MenhirState1
        | _ ->
            assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
            _menhir_env._menhir_shifted <- (-1);
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState1) : 'freshtv18)) : 'freshtv20)
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv21) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv22)) : 'freshtv24)) : 'freshtv26))

and parse_doc : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 11 "parser.mly"
      (Cst.doc)
# 1617 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = _menhir_init lexer lexbuf in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv3) = () in
    ((assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = _menhir_stack in
    let (_tok : token) = _tok in
    ((match _tok with
    | ADD_TOKEN _v ->
        _menhir_run39 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | CONTENT _v ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | EMPHASIS ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | HRULE ->
        _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | HTML ->
        _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LATEX ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LATEX_MATH ->
        _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | LST _v ->
        _menhir_run25 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | QUERY _v ->
        _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | RM_TOKEN _v ->
        _menhir_run23 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | SECTION _v ->
        _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
    | STARTPP ->
        _menhir_run19 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | STARTVERBATIM ->
        _menhir_run16 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | STARTVERNAC ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | EOF ->
        _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) MenhirState12
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState12) : 'freshtv2)) : 'freshtv4))



